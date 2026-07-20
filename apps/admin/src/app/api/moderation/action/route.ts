import { requireAdminUser } from '@/lib/admin-auth'
import { supabaseAdmin } from '@/lib/supabase-admin'

export const dynamic = 'force-dynamic'

export async function POST(request: Request) {
  const admin = await requireAdminUser(request)
  if ('error' in admin) return admin.error

  const body = await request.json()
  const contentType = String(body.contentType ?? '')
  const contentId = String(body.contentId ?? '')
  const action = String(body.action ?? '')
  const reason = String(body.reason ?? '')

  if (!['post', 'reply'].includes(contentType) || !contentId) {
    return Response.json({ error: 'Invalid content target' }, { status: 400 })
  }
  if (!['approved', 'flagged', 'removed', 'restored'].includes(action)) {
    return Response.json({ error: 'Invalid moderation action' }, { status: 400 })
  }

  const { data, error } = await supabaseAdmin.rpc('moderate_community_content', {
    p_content_type: contentType,
    p_content_id: contentId,
    p_action: action,
    p_reason: reason || null,
    p_moderator_user_id: admin.user.id,
    p_metadata: {
      moderator_email: admin.user.email,
      source: 'cyra-admin',
    },
  })

  if (error) return Response.json({ error: error.message }, { status: 500 })
  return Response.json({ moderationActionId: data })
}
