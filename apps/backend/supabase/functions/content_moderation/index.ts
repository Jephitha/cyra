import { serve } from 'https://deno.land/std@0.224.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.45.0'

interface ModerationRequest {
  postId?: string
  replyId?: string
  contentType: 'post' | 'reply'
  content: string
  title?: string
  source: 'direct' | 'report'
}

interface ModerationDecision {
  action: 'approved' | 'flagged' | 'removed'
  reason: string
  confidence: number
  flaggedCategories: string[]
}

const HARMFUL_PATTERNS = [
  { pattern: /\b(self[\s-]?harm|suicide|kill\s+(my)?\s*self|end\s+(my)?\s*life)\b/i, category: 'self_harm', severity: 10 },
  { pattern: /\b(hate\s+speech|racist|sexist|homophobic|transphobic|bigot|misogynist|misandrist)\b/i, category: 'hate_speech', severity: 9 },
  { pattern: /\b(harass|bully|threaten|intimidate|stalk|doxx|dox)\b/i, category: 'harassment', severity: 8 },
  { pattern: /\b(spam|scam|fake\s+account|impersonate|phishing|promo|promotion|buy\s+now|click\s+here)\b/i, category: 'spam', severity: 6 },
  { pattern: /\b(explicit|porn|nudity|sexual\s+content|nsfw|erotic|adult\s+content)\b/i, category: 'explicit', severity: 7 },
  { pattern: /\b(drugs|illegal|unlawful|criminal|illegal\s+substance)\b/i, category: 'illegal_activity', severity: 9 },
  { pattern: /\b(cure\s+(for|covid|pcod|pcos|endometriosis|adenomyosis|fibroid)|miracle\s+cure|detox|cleanse|alkaline\s+diet)\b/i, category: 'medical_misinformation', severity: 5 },
  { pattern: /\b(abortion\s+(pill|method|at\s+home)|self[\s-]?induce|herbal\s+abortion)\b/i, category: 'sensitive_medical', severity: 8 },
  { pattern: /\b(personal\s+info|phone|address|email|ssn|social\s+security|credit\s+card|bank\s+account)\b/i, category: 'personal_information', severity: 9 },
  { pattern: /\b(pro[\s-]?ana|pro[\s-]?mia|thinspo|thinspiration|purge|binge\s+purge|laxative\s+abuse)\b/i, category: 'eating_disorder', severity: 9 },
  { pattern: /\b(you\s+should\s+(kys|kill\s+yourself)|nobody\s+likes\s+you|everyone\s+hates\s+you)\b/i, category: 'targeted_harassment', severity: 10 },
  { pattern: /\b(essential\s+oils?\s+(cure|treat|heal)|magic\s+supplement|snake\s+oil)\b/i, category: 'unverified_treatment', severity: 5 },
  { pattern: /\b(dm\s+me|pm\s+me|message\s+me\s+privately|send\s+me\s+(pics?|photos?|pictures?))\b/i, category: 'soliciting_info', severity: 7 },
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
    return {
      action: 'removed',
      reason: 'Content violates community guidelines: ' + uniqueCategories.join(', '),
      confidence,
      flaggedCategories: uniqueCategories,
    }
  }

  return {
    action: 'flagged',
    reason: 'Content flagged for review: ' + uniqueCategories.join(', '),
    confidence,
    flaggedCategories: uniqueCategories,
  }
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    )

    const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(
      authHeader.replace('Bearer ', '')
    )
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), { status: 401, headers: { 'Content-Type': 'application/json' } })
    }

    const body: ModerationRequest = await req.json()
    if (!body.content || !body.contentType) {
      return new Response(JSON.stringify({ error: 'content and contentType are required' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
    }

    if (body.contentType === 'post' && !body.postId) {
      return new Response(JSON.stringify({ error: 'postId required for post moderation' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
    }
    if (body.contentType === 'reply' && !body.replyId) {
      return new Response(JSON.stringify({ error: 'replyId required for reply moderation' }), { status: 400, headers: { 'Content-Type': 'application/json' } })
    }

    const decision = moderateContent(body.content, body.title)
    const tableName = body.contentType === 'post' ? 'community_posts' : 'community_replies'
    const recordId = body.contentType === 'post' ? body.postId! : body.replyId!

    const { data: record } = await supabaseAdmin
      .from(tableName)
      .select('anonymous_user_id')
      .eq('id', recordId)
      .single()

    if (decision.action !== 'approved') {
      const updateData: Record<string, any> = {
        is_moderated: true,
      }

      if (body.contentType === 'post') {
        Object.assign(updateData, {
          moderation_status: decision.action === 'removed' ? 'removed' : 'flagged',
        })
      } else {
        Object.assign(updateData, {
          moderation_action: decision.action === 'removed' ? 'removed' : 'flagged',
        })
      }

      await supabaseAdmin.from(tableName).update(updateData).eq('id', recordId)

      if (record?.anonymous_user_id) {
        await supabaseAdmin.from('community_moderation_notifications').insert({
          anonymous_user_id: record.anonymous_user_id,
          content_type: body.contentType,
          content_id: recordId,
          action: decision.action,
          reason: decision.reason,
          is_read: false,
        })
      }
    } else {
      const updateData: Record<string, any> = {
        is_moderated: false,
      }

      if (body.contentType === 'post') {
        Object.assign(updateData, { moderation_status: 'approved' })
      }

      await supabaseAdmin.from(tableName).update(updateData).eq('id', recordId)
    }

    if (decision.action === 'flagged') {
      await supabaseAdmin.from('audit_logs').insert({
        user_id: user.id,
        action: 'content_flagged',
        resource_type: `community_${body.contentType}`,
        resource_id: recordId,
        metadata: { reason: decision.reason, categories: decision.flaggedCategories, confidence: decision.confidence },
      })
    }

    return new Response(JSON.stringify({
      recordId,
      contentType: body.contentType,
      decision: decision.action,
      reason: decision.reason,
      confidence: decision.confidence,
    }), { status: 200, headers: { 'Content-Type': 'application/json' } })

  } catch (error) {
    console.error('Error in content moderation:', error)
    return new Response(JSON.stringify({ error: 'Internal server error' }), { status: 500, headers: { 'Content-Type': 'application/json' } })
  }
})
