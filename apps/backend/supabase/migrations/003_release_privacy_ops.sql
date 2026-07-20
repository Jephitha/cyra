-- Cyra release privacy and operations hardening
-- Community RLS, moderation audit, export/deletion queues, sync metadata,
-- backup/log/rate-limit/alerting primitives.

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================
-- HELPERS
-- ============================================================
CREATE OR REPLACE FUNCTION is_service_role()
RETURNS boolean AS $$
BEGIN
  RETURN auth.role() = 'service_role';
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

-- ============================================================
-- COMMUNITY MODERATION AUDIT
-- ============================================================
CREATE TABLE IF NOT EXISTS community_moderation_actions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_type TEXT NOT NULL CHECK (content_type IN ('post', 'reply')),
  content_id TEXT NOT NULL,
  action TEXT NOT NULL CHECK (action IN ('approved', 'flagged', 'removed', 'restored')),
  reason TEXT,
  moderator_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  source TEXT NOT NULL DEFAULT 'admin' CHECK (source IN ('admin', 'automation', 'report')),
  metadata JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_moderation_actions_content
  ON community_moderation_actions(content_type, content_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_moderation_actions_created
  ON community_moderation_actions(created_at DESC);

ALTER TABLE community_moderation_actions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS community_moderation_actions_service_all ON community_moderation_actions;
CREATE POLICY community_moderation_actions_service_all
  ON community_moderation_actions FOR ALL
  USING (is_service_role())
  WITH CHECK (is_service_role());

ALTER TABLE community_reports ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ;
ALTER TABLE community_reports ADD COLUMN IF NOT EXISTS resolution_action TEXT;
ALTER TABLE community_reports ADD COLUMN IF NOT EXISTS resolver_user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL;
CREATE INDEX IF NOT EXISTS idx_community_reports_status_created
  ON community_reports(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_reports_content
  ON community_reports(content_type, content_id);

-- ============================================================
-- COMMUNITY RLS TIGHTENING
-- ============================================================
DROP POLICY IF EXISTS community_posts_select ON community_posts;
DROP POLICY IF EXISTS community_posts_insert ON community_posts;
DROP POLICY IF EXISTS community_posts_update ON community_posts;
DROP POLICY IF EXISTS community_posts_delete ON community_posts;
CREATE POLICY community_posts_select
  ON community_posts FOR SELECT
  USING (
    moderation_status = 'approved'
    OR user_id = auth.uid()
    OR is_service_role()
  );
CREATE POLICY community_posts_insert
  ON community_posts FOR INSERT
  WITH CHECK (
    is_service_role()
    OR (
      COALESCE(moderation_status, 'pending') = 'pending'
      AND (user_id = auth.uid() OR anonymous_user_id IS NOT NULL)
    )
  );
CREATE POLICY community_posts_update_owner
  ON community_posts FOR UPDATE
  USING (user_id = auth.uid() OR is_service_role())
  WITH CHECK (user_id = auth.uid() OR is_service_role());
CREATE POLICY community_posts_delete_owner
  ON community_posts FOR DELETE
  USING (user_id = auth.uid() OR is_service_role());

DROP POLICY IF EXISTS community_replies_select ON community_replies;
DROP POLICY IF EXISTS community_replies_insert ON community_replies;
CREATE POLICY community_replies_select
  ON community_replies FOR SELECT
  USING (
    COALESCE(moderation_status, 'pending') = 'approved'
    OR is_service_role()
  );
CREATE POLICY community_replies_insert
  ON community_replies FOR INSERT
  WITH CHECK (
    is_service_role()
    OR (
      anonymous_user_id IS NOT NULL
      AND EXISTS (
        SELECT 1 FROM community_posts p
        WHERE p.id = post_id AND p.moderation_status = 'approved'
      )
    )
  );
DROP POLICY IF EXISTS community_replies_update_service ON community_replies;
CREATE POLICY community_replies_update_service
  ON community_replies FOR UPDATE
  USING (is_service_role())
  WITH CHECK (is_service_role());
DROP POLICY IF EXISTS community_replies_delete_service ON community_replies;
CREATE POLICY community_replies_delete_service
  ON community_replies FOR DELETE
  USING (is_service_role());

DROP POLICY IF EXISTS community_likes_select ON community_likes;
DROP POLICY IF EXISTS community_likes_insert ON community_likes;
DROP POLICY IF EXISTS community_likes_delete ON community_likes;
CREATE POLICY community_likes_select
  ON community_likes FOR SELECT
  USING (true);
CREATE POLICY community_likes_insert
  ON community_likes FOR INSERT
  WITH CHECK (
    anonymous_user_id IS NOT NULL
    AND EXISTS (
      SELECT 1 FROM community_posts p
      WHERE p.id = post_id AND p.moderation_status = 'approved'
    )
  );
CREATE POLICY community_likes_delete
  ON community_likes FOR DELETE
  USING (is_service_role());

DROP POLICY IF EXISTS community_reports_insert ON community_reports;
CREATE POLICY community_reports_insert
  ON community_reports FOR INSERT
  WITH CHECK (
    status = 'pending'
    AND reported_by IS NOT NULL
    AND content_type IN ('post', 'reply')
  );
DROP POLICY IF EXISTS community_reports_service_all ON community_reports;
CREATE POLICY community_reports_service_all
  ON community_reports FOR ALL
  USING (is_service_role())
  WITH CHECK (is_service_role());

DROP POLICY IF EXISTS "Anyone can read own notifications" ON community_moderation_notifications;
DROP POLICY IF EXISTS "Only service_role can insert" ON community_moderation_notifications;
CREATE POLICY community_moderation_notifications_service_all
  ON community_moderation_notifications FOR ALL
  USING (is_service_role())
  WITH CHECK (is_service_role());

-- ============================================================
-- CLOUD SYNC / RESTORE PRIMITIVES
-- ============================================================
CREATE TABLE IF NOT EXISTS user_sync_manifests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  device_id TEXT NOT NULL,
  encryption_scheme TEXT NOT NULL DEFAULT 'xchacha20poly1305',
  key_recovery_method TEXT NOT NULL DEFAULT 'user_recovery_code'
    CHECK (key_recovery_method IN ('user_recovery_code', 'none')),
  consent_version TEXT NOT NULL,
  last_synced_at TIMESTAMPTZ,
  conflict_policy TEXT NOT NULL DEFAULT 'newest_client_wins'
    CHECK (conflict_policy IN ('newest_client_wins', 'manual_review')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, device_id)
);

CREATE TABLE IF NOT EXISTS user_sync_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  manifest_id UUID REFERENCES user_sync_manifests(id) ON DELETE CASCADE,
  record_type TEXT NOT NULL,
  record_id TEXT NOT NULL,
  encrypted_payload BYTEA NOT NULL,
  payload_hash TEXT NOT NULL,
  client_updated_at TIMESTAMPTZ NOT NULL,
  server_updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,
  conflict_state TEXT NOT NULL DEFAULT 'clean'
    CHECK (conflict_state IN ('clean', 'conflict', 'server_deleted')),
  UNIQUE(user_id, record_type, record_id)
);

CREATE INDEX IF NOT EXISTS idx_user_sync_items_user_updated
  ON user_sync_items(user_id, server_updated_at DESC);

ALTER TABLE user_sync_manifests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sync_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS user_sync_manifests_owner ON user_sync_manifests;
CREATE POLICY user_sync_manifests_owner ON user_sync_manifests FOR ALL
  USING (user_id = auth.uid() OR is_service_role())
  WITH CHECK (user_id = auth.uid() OR is_service_role());
DROP POLICY IF EXISTS user_sync_items_owner ON user_sync_items;
CREATE POLICY user_sync_items_owner ON user_sync_items FOR ALL
  USING (user_id = auth.uid() OR is_service_role())
  WITH CHECK (user_id = auth.uid() OR is_service_role());

-- ============================================================
-- USER DATA REQUESTS AND PERMANENT DELETION
-- ============================================================
CREATE TABLE IF NOT EXISTS user_data_export_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'queued'
    CHECK (status IN ('queued', 'processing', 'ready', 'failed', 'expired')),
  fresh_auth_at TIMESTAMPTZ NOT NULL,
  storage_bucket TEXT NOT NULL DEFAULT 'user_exports',
  storage_path TEXT,
  encrypted_with TEXT NOT NULL DEFAULT 'user_public_key',
  signed_url_expires_at TIMESTAMPTZ,
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  audit_metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS user_data_deletion_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  status TEXT NOT NULL DEFAULT 'queued'
    CHECK (status IN ('queued', 'processing', 'completed', 'failed')),
  fresh_auth_at TIMESTAMPTZ NOT NULL,
  requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  anonymized_subject_hash TEXT,
  retention_notes TEXT,
  audit_metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS user_identity_tombstones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  deleted_user_id UUID NOT NULL,
  email_sha256 TEXT,
  phone_sha256 TEXT,
  reason TEXT NOT NULL DEFAULT 'user_requested_deletion',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  retention_until TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '400 days'),
  UNIQUE(deleted_user_id)
);

ALTER TABLE user_data_export_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_data_deletion_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_identity_tombstones ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS user_data_export_requests_owner_select ON user_data_export_requests;
CREATE POLICY user_data_export_requests_owner_select
  ON user_data_export_requests FOR SELECT
  USING (user_id = auth.uid() OR is_service_role());
DROP POLICY IF EXISTS user_data_export_requests_owner_insert ON user_data_export_requests;
CREATE POLICY user_data_export_requests_owner_insert
  ON user_data_export_requests FOR INSERT
  WITH CHECK (user_id = auth.uid() OR is_service_role());
DROP POLICY IF EXISTS user_data_export_requests_service_update ON user_data_export_requests;
CREATE POLICY user_data_export_requests_service_update
  ON user_data_export_requests FOR UPDATE
  USING (is_service_role())
  WITH CHECK (is_service_role());

DROP POLICY IF EXISTS user_data_deletion_requests_owner_select ON user_data_deletion_requests;
CREATE POLICY user_data_deletion_requests_owner_select
  ON user_data_deletion_requests FOR SELECT
  USING (user_id = auth.uid() OR is_service_role());
DROP POLICY IF EXISTS user_data_deletion_requests_owner_insert ON user_data_deletion_requests;
CREATE POLICY user_data_deletion_requests_owner_insert
  ON user_data_deletion_requests FOR INSERT
  WITH CHECK (user_id = auth.uid() OR is_service_role());
DROP POLICY IF EXISTS user_data_deletion_requests_service_update ON user_data_deletion_requests;
CREATE POLICY user_data_deletion_requests_service_update
  ON user_data_deletion_requests FOR UPDATE
  USING (is_service_role())
  WITH CHECK (is_service_role());

DROP POLICY IF EXISTS user_identity_tombstones_service_all ON user_identity_tombstones;
CREATE POLICY user_identity_tombstones_service_all
  ON user_identity_tombstones FOR ALL
  USING (is_service_role())
  WITH CHECK (is_service_role());

-- ============================================================
-- BACKUPS, LOGS, RATE LIMITS, ALERTING
-- ============================================================
CREATE TABLE IF NOT EXISTS backup_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  environment TEXT NOT NULL CHECK (environment IN ('staging', 'production')),
  backup_type TEXT NOT NULL CHECK (backup_type IN ('daily', 'weekly', 'pre_migration', 'restore_test')),
  status TEXT NOT NULL DEFAULT 'started'
    CHECK (status IN ('started', 'completed', 'failed')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  retention_until TIMESTAMPTZ NOT NULL,
  storage_location TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS operational_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  severity TEXT NOT NULL CHECK (severity IN ('info', 'warning', 'error', 'critical')),
  source TEXT NOT NULL,
  event_type TEXT NOT NULL,
  correlation_id TEXT,
  metadata JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS rate_limit_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  bucket TEXT NOT NULL,
  subject_hash TEXT NOT NULL,
  action TEXT NOT NULL,
  allowed BOOLEAN NOT NULL DEFAULT true,
  window_started_at TIMESTAMPTZ NOT NULL,
  window_seconds INTEGER NOT NULL,
  count INTEGER NOT NULL,
  metadata JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS alert_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  severity TEXT NOT NULL CHECK (severity IN ('warning', 'error', 'critical')),
  source TEXT NOT NULL,
  condition JSONB NOT NULL,
  destination TEXT NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE backup_runs ENABLE ROW LEVEL SECURITY;
ALTER TABLE operational_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE rate_limit_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE alert_rules ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS backup_runs_service_all ON backup_runs;
CREATE POLICY backup_runs_service_all ON backup_runs FOR ALL
  USING (is_service_role()) WITH CHECK (is_service_role());
DROP POLICY IF EXISTS operational_events_service_all ON operational_events;
CREATE POLICY operational_events_service_all ON operational_events FOR ALL
  USING (is_service_role()) WITH CHECK (is_service_role());
DROP POLICY IF EXISTS rate_limit_events_service_all ON rate_limit_events;
CREATE POLICY rate_limit_events_service_all ON rate_limit_events FOR ALL
  USING (is_service_role()) WITH CHECK (is_service_role());
DROP POLICY IF EXISTS alert_rules_service_all ON alert_rules;
CREATE POLICY alert_rules_service_all ON alert_rules FOR ALL
  USING (is_service_role()) WITH CHECK (is_service_role());

INSERT INTO storage.buckets (id, name, public) VALUES
  ('user_exports', 'user_exports', false)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS storage_user_exports_service_all ON storage.objects;
CREATE POLICY storage_user_exports_service_all ON storage.objects FOR ALL
  USING (bucket_id = 'user_exports' AND is_service_role())
  WITH CHECK (bucket_id = 'user_exports' AND is_service_role());

-- ============================================================
-- RPCS
-- ============================================================
CREATE OR REPLACE FUNCTION moderate_community_content(
  p_content_type TEXT,
  p_content_id TEXT,
  p_action TEXT,
  p_reason TEXT DEFAULT NULL,
  p_moderator_user_id UUID DEFAULT NULL,
  p_metadata JSONB DEFAULT '{}'
)
RETURNS UUID AS $$
DECLARE
  action_id UUID;
  target_anonymous_id TEXT;
BEGIN
  IF NOT is_service_role() THEN
    RAISE EXCEPTION 'service_role required';
  END IF;
  IF p_content_type NOT IN ('post', 'reply') THEN
    RAISE EXCEPTION 'invalid content type';
  END IF;
  IF p_action NOT IN ('approved', 'flagged', 'removed', 'restored') THEN
    RAISE EXCEPTION 'invalid moderation action';
  END IF;

  IF p_content_type = 'post' THEN
    UPDATE community_posts
      SET moderation_status = CASE WHEN p_action = 'restored' THEN 'approved' ELSE p_action END,
          is_moderated = p_action IN ('flagged', 'removed'),
          moderation_action = p_reason,
          updated_at = NOW()
      WHERE id = p_content_id
      RETURNING anonymous_user_id INTO target_anonymous_id;
  ELSE
    UPDATE community_replies
      SET moderation_status = CASE WHEN p_action = 'restored' THEN 'approved' ELSE p_action END,
          is_moderated = p_action IN ('flagged', 'removed'),
          moderation_action = p_reason
      WHERE id = p_content_id
      RETURNING anonymous_user_id INTO target_anonymous_id;
  END IF;

  INSERT INTO community_moderation_actions (
    content_type, content_id, action, reason, moderator_user_id, metadata
  )
  VALUES (p_content_type, p_content_id, p_action, p_reason, p_moderator_user_id, p_metadata)
  RETURNING id INTO action_id;

  UPDATE community_reports
    SET status = 'resolved',
        resolved_at = NOW(),
        resolution_action = p_action,
        resolver_user_id = p_moderator_user_id
    WHERE content_type = p_content_type
      AND content_id = p_content_id
      AND status = 'pending';

  IF target_anonymous_id IS NOT NULL THEN
    INSERT INTO community_moderation_notifications (
      anonymous_user_id, content_type, content_id, action, reason
    )
    VALUES (target_anonymous_id, p_content_type, p_content_id, p_action, p_reason);
  END IF;

  RETURN action_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION request_user_data_export(
  p_fresh_auth_at TIMESTAMPTZ,
  p_audit_metadata JSONB DEFAULT '{}'
)
RETURNS UUID AS $$
DECLARE
  request_id UUID;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'authentication required';
  END IF;
  IF p_fresh_auth_at < NOW() - INTERVAL '15 minutes' THEN
    RAISE EXCEPTION 'fresh authentication required';
  END IF;

  INSERT INTO user_data_export_requests(user_id, fresh_auth_at, audit_metadata)
  VALUES (auth.uid(), p_fresh_auth_at, p_audit_metadata)
  RETURNING id INTO request_id;

  INSERT INTO audit_logs(user_id, action, resource_type, resource_id, metadata)
  VALUES (auth.uid(), 'user_data_export_requested', 'user_data_export_requests', request_id::text, p_audit_metadata);

  RETURN request_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION request_account_deletion(
  p_fresh_auth_at TIMESTAMPTZ,
  p_subject_hash TEXT,
  p_audit_metadata JSONB DEFAULT '{}'
)
RETURNS UUID AS $$
DECLARE
  request_id UUID;
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE EXCEPTION 'authentication required';
  END IF;
  IF p_fresh_auth_at < NOW() - INTERVAL '15 minutes' THEN
    RAISE EXCEPTION 'fresh authentication required';
  END IF;

  INSERT INTO user_data_deletion_requests(
    user_id, fresh_auth_at, anonymized_subject_hash, audit_metadata
  )
  VALUES (auth.uid(), p_fresh_auth_at, p_subject_hash, p_audit_metadata)
  RETURNING id INTO request_id;

  INSERT INTO audit_logs(user_id, action, resource_type, resource_id, metadata)
  VALUES (auth.uid(), 'account_deletion_requested', 'user_data_deletion_requests', request_id::text, p_audit_metadata);

  RETURN request_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION anonymize_deleted_user(
  p_user_id UUID,
  p_email_sha256 TEXT DEFAULT NULL,
  p_phone_sha256 TEXT DEFAULT NULL
)
RETURNS void AS $$
BEGIN
  IF NOT is_service_role() THEN
    RAISE EXCEPTION 'service_role required';
  END IF;

  INSERT INTO user_identity_tombstones(deleted_user_id, email_sha256, phone_sha256)
  VALUES (p_user_id, p_email_sha256, p_phone_sha256)
  ON CONFLICT (deleted_user_id) DO NOTHING;

  UPDATE community_posts
    SET user_id = NULL,
        anonymous_user_id = 'deleted-user',
        title = NULL,
        content = CASE WHEN moderation_status = 'removed' THEN content ELSE '[deleted]' END,
        updated_at = NOW()
    WHERE user_id = p_user_id;

  UPDATE audit_logs
    SET user_id = NULL,
        metadata = COALESCE(metadata, '{}'::jsonb) || jsonb_build_object('anonymized_user', true)
    WHERE user_id = p_user_id;

  UPDATE user_data_deletion_requests
    SET status = 'completed',
        completed_at = NOW(),
        user_id = NULL,
        retention_notes = 'Primary user-owned data removed by auth cascade; audit/community records anonymized.'
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION record_operational_event(
  p_severity TEXT,
  p_source TEXT,
  p_event_type TEXT,
  p_metadata JSONB DEFAULT '{}',
  p_correlation_id TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  event_id UUID;
BEGIN
  IF NOT is_service_role() THEN
    RAISE EXCEPTION 'service_role required';
  END IF;
  INSERT INTO operational_events(severity, source, event_type, metadata, correlation_id)
  VALUES (p_severity, p_source, p_event_type, p_metadata, p_correlation_id)
  RETURNING id INTO event_id;
  RETURN event_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
