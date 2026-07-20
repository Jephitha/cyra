import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

const authClient = createClient(supabaseUrl, supabaseAnonKey)

export async function requireAdminUser(request: Request) {
  const authHeader = request.headers.get('authorization') ?? ''
  const token = authHeader.replace(/^Bearer\s+/i, '').trim()

  if (!token) {
    return { error: Response.json({ error: 'Missing authorization' }, { status: 401 }) }
  }

  const { data, error } = await authClient.auth.getUser(token)
  if (error || !data.user) {
    return { error: Response.json({ error: 'Invalid session' }, { status: 401 }) }
  }

  const allowedEmails = (process.env.ADMIN_EMAILS ?? '')
    .split(',')
    .map((email) => email.trim().toLowerCase())
    .filter(Boolean)

  if (
    process.env.NODE_ENV === 'production' &&
    allowedEmails.length > 0 &&
    !allowedEmails.includes((data.user.email ?? '').toLowerCase())
  ) {
    return { error: Response.json({ error: 'Admin access required' }, { status: 403 }) }
  }

  return { user: data.user }
}
