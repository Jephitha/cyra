import { serve } from 'https://deno.land/std@0.224.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.0'

interface ModerationRequest {
  postId: string
  content: string
  title?: string
}

interface ModerationDecision {
  action: 'approved' | 'flagged' | 'removed'
  reason: string
  confidence: number
  flaggedCategories: string[]
}

const HARMFUL_PATTERNS: { pattern: RegExp; category: string; severity: number }[] = [
  { pattern: /\b(self[\s-]?harm|suicide|kill\s+(my)?\s*self|end\s+(my)?\s*life)\b/i, category: 'self_harm', severity: 10 },
  { pattern: /\b(hate\s+speech|racist|sexist|homophobic|transphobic|bigot)\b/i, category: 'hate_speech', severity: 9 },
  { pattern: /\b(harass|bully|threaten|intimidate|stalk)\b/i, category: 'harassment', severity: 8 },
  { pattern: /\b(spam|scam|fake\s+account|impersonate|phishing)\b/i, category: 'spam', severity: 6 },
  { pattern: /\b(explicit|porn|nudity|sexual\s+content|nsfw)\b/i, category: 'explicit', severity: 7 },
  { pattern: /\b(drugs|illegal|unlawful|criminal)\b/i, category: 'illegal_activity', severity: 9 },
  { pattern: /\b(medical\s+advice|diagnosis|cure|treatment|cure)\s+(for|covid|pcod|pcos|endometriosis)\b/i, category: 'medical_misinformation', severity: 5 },
  { pattern: /\b(abortion\s+(pill|method|at\s+home)|self[\s-]?induce)\b/i, category: 'sensitive_medical', severity: 8 },
  { pattern: /\b(personal\s+info|phone|address|email|ssn|social\s+security)\b/i, category: 'personal_information', severity: 9 },
  { pattern: /\b(pro[\s-]?ana|pro[\s-]?mia|thinspo|thinspiration)\b/i, category: 'eating_disorder', severity: 9 },
]

function moderateContent(content: string, title?: string): ModerationDecision {
  const fullText = title ? `${title} ${content}` : content
  const flaggedCategories: string[] = []
  let maxSeverity = 0
  let reasons: string[] = []

  for (const rule of HARMFUL_PATTERNS) {
    if (rule.pattern.test(fullText)) {
      flaggedCategories.push(rule.category)
      if (rule.severity > maxSeverity) maxSeverity = rule.severity
      reasons.push(`Matched pattern for: ${rule.category}`)
    }
  }

  if (flaggedCategories.length === 0) {
    return { action: 'approved', reason: 'No harmful content detected', confidence: 0.95, flaggedCategories: [] }
  }

  const uniqueCategories = [...new Set(flaggedCategories)]
  const confidence = Math.min(0.5 + maxSeverity * 0.05, 0.98)

  if (maxSeverity >= 8) {
    return { action: 'removed', reason: 'Content violates community guidelines: ' + uniqueCategories.join(', '), confidence, flaggedCategories: uniqueCategories }
  }

  return { action: 'flagged', reason: 'Content flagged for review: ' + uniqueCategories.join(', '), confidence, flaggedCategories: uniqueCategories }
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } }
    )

    const { data: { user }, error: authError } = await supabaseClient.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    const body: ModerationRequest = await req.json()
    if (!body.content || !body.postId) {
      return new Response(JSON.stringify({ error: 'postId and content are required' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
    }

    const decision = moderateContent(body.content, body.title)

    if (decision.action !== 'approved') {
      const updateData: Record<string, any> = {
        moderation_status: decision.action === 'removed' ? 'removed' : 'flagged',
        is_moderated: true,
      }
      if (decision.action === 'removed') {
        updateData.content = '[This content has been removed for violating community guidelines]'
      }

      await supabaseClient.from('community_posts').update(updateData).eq('id', body.postId)
    } else {
      await supabaseClient.from('community_posts').update({ moderation_status: 'approved', is_moderated: true }).eq('id', body.postId)
    }

    // Log for admin review if flagged
    if (decision.action === 'flagged') {
      await supabaseClient.from('audit_logs').insert({
        user_id: user.id,
        action: 'content_flagged',
        resource_type: 'community_post',
        resource_id: body.postId,
        metadata: { reason: decision.reason, categories: decision.flaggedCategories, confidence: decision.confidence },
      })
    }

    return new Response(JSON.stringify({
      postId: body.postId,
      decision: decision.action,
      reason: decision.reason,
      confidence: decision.confidence,
    }), { status: 200, headers: { 'Content-Type': 'application/json' } })
  } catch (error) {
    console.error('Error in content moderation:', error)
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: { 'Content-Type': 'application/json' } })
  }
})
