import { requireAdminUser } from '@/lib/admin-auth'
import { supabaseAdmin } from '@/lib/supabase-admin'

export const dynamic = 'force-dynamic'

export async function GET(request: Request) {
  const admin = await requireAdminUser(request)
  if ('error' in admin) return admin.error

  const [exportsQueued, deletionQueued, latestBackups, criticalEvents] =
    await Promise.all([
      supabaseAdmin
        .from('user_data_export_requests')
        .select('*', { count: 'exact', head: true })
        .in('status', ['queued', 'processing']),
      supabaseAdmin
        .from('user_data_deletion_requests')
        .select('*', { count: 'exact', head: true })
        .in('status', ['queued', 'processing']),
      supabaseAdmin
        .from('backup_runs')
        .select('environment,backup_type,status,started_at,completed_at')
        .order('started_at', { ascending: false })
        .limit(5),
      supabaseAdmin
        .from('operational_events')
        .select('severity,source,event_type,created_at')
        .in('severity', ['error', 'critical'])
        .order('created_at', { ascending: false })
        .limit(10),
    ])

  return Response.json({
    exportsQueued: exportsQueued.count ?? 0,
    deletionQueued: deletionQueued.count ?? 0,
    latestBackups: latestBackups.data ?? [],
    criticalEvents: criticalEvents.data ?? [],
  })
}
