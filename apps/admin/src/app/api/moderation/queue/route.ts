import { NextRequest } from 'next/server'
import { requireAdminUser } from '@/lib/admin-auth'
import { supabaseAdmin } from '@/lib/supabase-admin'

export const dynamic = 'force-dynamic'

export async function GET(request: NextRequest) {
  const admin = await requireAdminUser(request)
  if ('error' in admin) return admin.error

  const type = request.nextUrl.searchParams.get('type') ?? 'reports'
  const status = request.nextUrl.searchParams.get('status') ?? 'all'

  if (type === 'posts') {
    let query = supabaseAdmin
      .from('community_posts')
      .select('id,title,content,anonymous_user_id,moderation_status,moderation_action,is_moderated,created_at,reply_count,like_count')
      .order('created_at', { ascending: false })
      .limit(200)

    if (status !== 'all') query = query.eq('moderation_status', status)
    const { data, error } = await query
    if (error) return Response.json({ error: error.message }, { status: 500 })
    return Response.json({ items: data ?? [] })
  }

  if (type === 'replies') {
    let query = supabaseAdmin
      .from('community_replies')
      .select('id,post_id,content,anonymous_user_id,moderation_status,moderation_action,is_moderated,created_at')
      .order('created_at', { ascending: false })
      .limit(200)

    if (status !== 'all') query = query.eq('moderation_status', status)
    const { data, error } = await query
    if (error) return Response.json({ error: error.message }, { status: 500 })
    return Response.json({ items: data ?? [] })
  }

  const { data: reports, error } = await supabaseAdmin
    .from('community_reports')
    .select('id,content_type,content_id,reported_by,reason,status,created_at,resolved_at,resolution_action')
    .order('created_at', { ascending: false })
    .limit(200)

  if (error) return Response.json({ error: error.message }, { status: 500 })

  const grouped = new Map<string, any>()
  for (const report of reports ?? []) {
    const key = `${report.content_type}:${report.content_id}`
    const existing = grouped.get(key) ?? {
      content_type: report.content_type,
      content_id: report.content_id,
      reasons: [],
      status: report.status,
      report_count: 0,
      latest_created_at: report.created_at,
      content_preview: '(loading)',
    }
    existing.reasons.push(report.reason)
    existing.report_count += 1
    if (new Date(report.created_at) > new Date(existing.latest_created_at)) {
      existing.latest_created_at = report.created_at
    }
    if (report.status !== 'pending') existing.status = report.status
    grouped.set(key, existing)
  }

  const items = Array.from(grouped.values())
  for (const item of items) {
    const table = item.content_type === 'post' ? 'community_posts' : 'community_replies'
    const { data } = await supabaseAdmin
      .from(table)
      .select('content')
      .eq('id', item.content_id)
      .maybeSingle()
    item.content_preview = data?.content?.slice(0, 180) ?? '(deleted)'
  }

  return Response.json({ items })
}
