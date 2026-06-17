-- Cyra Community Features
-- Tables and functions for anonymous community interactions

-- ============================================================
-- COMMUNITY TOPICS
-- ============================================================
CREATE TABLE IF NOT EXISTS community_topics (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  post_count INTEGER DEFAULT 0,
  member_count INTEGER DEFAULT 0,
  icon_asset TEXT,
  is_moderated BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- COMMUNITY REPLIES
-- ============================================================
CREATE TABLE IF NOT EXISTS community_replies (
  id TEXT PRIMARY KEY,
  post_id TEXT NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  anonymous_user_id TEXT NOT NULL,
  is_anonymous BOOLEAN DEFAULT true,
  like_count INTEGER DEFAULT 0,
  is_moderated BOOLEAN DEFAULT false,
  moderation_action TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_community_replies_post_id ON community_replies(post_id);

-- ============================================================
-- COMMUNITY LIKES
-- ============================================================
CREATE TABLE IF NOT EXISTS community_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  post_id TEXT NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  anonymous_user_id TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(post_id, anonymous_user_id)
);

CREATE INDEX idx_community_likes_post_id ON community_likes(post_id);

-- ============================================================
-- COMMUNITY REPORTS
-- ============================================================
CREATE TABLE IF NOT EXISTS community_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_type TEXT NOT NULL,
  content_id TEXT NOT NULL,
  reported_by TEXT NOT NULL,
  reason TEXT NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- RPC FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION increment_reply_count(post_id TEXT)
RETURNS void AS $$
BEGIN
  UPDATE community_posts SET reply_count = reply_count + 1 WHERE id = post_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION increment_like_count(post_id TEXT)
RETURNS void AS $$
BEGIN
  UPDATE community_posts SET like_count = like_count + 1 WHERE id = post_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION decrement_like_count(post_id TEXT)
RETURNS void AS $$
BEGIN
  UPDATE community_posts SET like_count = GREATEST(0, like_count - 1) WHERE id = post_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- UPDATE EXISTING community_posts TABLE
-- Add columns needed by the anonymous community system
-- ============================================================
ALTER TABLE community_posts ADD COLUMN IF NOT EXISTS topic_id TEXT;
ALTER TABLE community_posts ADD COLUMN IF NOT EXISTS anonymous_user_id TEXT;
ALTER TABLE community_posts ADD COLUMN IF NOT EXISTS like_count INTEGER DEFAULT 0;
ALTER TABLE community_posts ADD COLUMN IF NOT EXISTS moderation_action TEXT;
ALTER TABLE community_posts ALTER COLUMN user_id DROP NOT NULL;

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Community Topics (public read, admin write)
ALTER TABLE community_topics ENABLE ROW LEVEL SECURITY;
CREATE POLICY community_topics_select ON community_topics FOR SELECT USING (true);

-- Community Replies
ALTER TABLE community_replies ENABLE ROW LEVEL SECURITY;
CREATE POLICY community_replies_select ON community_replies FOR SELECT USING (true);
CREATE POLICY community_replies_insert ON community_replies FOR INSERT WITH CHECK (true);

-- Community Likes
ALTER TABLE community_likes ENABLE ROW LEVEL SECURITY;
CREATE POLICY community_likes_select ON community_likes FOR SELECT USING (true);
CREATE POLICY community_likes_insert ON community_likes FOR INSERT WITH CHECK (true);
CREATE POLICY community_likes_delete ON community_likes FOR DELETE USING (true);

-- Community Reports (insert only)
ALTER TABLE community_reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY community_reports_insert ON community_reports FOR INSERT WITH CHECK (true);

-- Update community_posts RLS to allow anonymous access
DROP POLICY IF EXISTS community_posts_select ON community_posts;
DROP POLICY IF EXISTS community_posts_insert ON community_posts;
CREATE POLICY community_posts_select ON community_posts FOR SELECT USING (
  moderation_status = 'approved' OR user_id = auth.uid() OR anonymous_user_id IS NOT NULL
);
CREATE POLICY community_posts_insert ON community_posts FOR INSERT WITH CHECK (
  user_id = auth.uid() OR anonymous_user_id IS NOT NULL
);

-- ============================================================
-- MODERATION NOTIFICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS community_moderation_notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  anonymous_user_id TEXT NOT NULL,
  content_type TEXT NOT NULL CHECK (content_type IN ('post', 'reply')),
  content_id TEXT NOT NULL,
  action TEXT NOT NULL CHECK (action IN ('flagged', 'removed', 'approved')),
  reason TEXT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_mod_notifications_user ON community_moderation_notifications(anonymous_user_id);
CREATE INDEX idx_mod_notifications_read ON community_moderation_notifications(is_read);

ALTER TABLE community_moderation_notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can read own notifications"
  ON community_moderation_notifications FOR SELECT
  USING (true);
CREATE POLICY "Only service_role can insert"
  ON community_moderation_notifications FOR INSERT
  WITH CHECK (auth.role() = 'service_role');

-- ============================================================
-- ADD moderation_status TO community_replies
-- ============================================================
ALTER TABLE community_replies ADD COLUMN IF NOT EXISTS moderation_status TEXT
  DEFAULT 'pending' CHECK (moderation_status IN ('pending', 'approved', 'flagged', 'removed'));
