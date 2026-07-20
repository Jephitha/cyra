'use client'

import { useEffect, useMemo, useState } from 'react'
import { supabase } from '@/lib/supabase'

type QueueType = 'reports' | 'posts' | 'replies'

interface ModerationQueueProps {
  title: string
  type: QueueType
}

interface QueueItem {
  id?: string
  content_type?: string
  content_id?: string
  title?: string
  content?: string
  content_preview?: string
  anonymous_user_id?: string
  post_id?: string
  reasons?: string[]
  report_count?: number
  status?: string
  moderation_status?: string
  moderation_action?: string
  is_moderated?: boolean
  created_at?: string
  latest_created_at?: string
}

const filters = ['all', 'pending', 'flagged', 'approved', 'removed']

export function ModerationQueue({ title, type }: ModerationQueueProps) {
  const [items, setItems] = useState<QueueItem[]>([])
  const [filter, setFilter] = useState('all')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const visibleFilters = useMemo(
    () => type === 'reports' ? ['all', 'pending', 'resolved'] : filters,
    [type]
  )

  async function authHeaders() {
    const { data } = await supabase.auth.getSession()
    const token = data.session?.access_token
    if (!token) throw new Error('Admin session expired. Sign in again.')
    return { Authorization: `Bearer ${token}` }
  }

  async function fetchItems() {
    setLoading(true)
    setError(null)
    try {
      const headers = await authHeaders()
      const response = await fetch(`/api/moderation/queue?type=${type}&status=${filter}`, { headers })
      const payload = await response.json()
      if (!response.ok) throw new Error(payload.error ?? 'Could not load moderation queue.')
      setItems(payload.items ?? [])
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Could not load moderation queue.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    fetchItems()
  }, [filter])

  async function moderate(item: QueueItem, action: 'approved' | 'flagged' | 'removed') {
    const contentType = type === 'reports' ? item.content_type : type === 'posts' ? 'post' : 'reply'
    const contentId = type === 'reports' ? item.content_id : item.id
    if (!contentType || !contentId) return

    const reason =
      action === 'approved'
        ? 'Approved by moderator'
        : action === 'flagged'
          ? 'Flagged for follow-up'
          : 'Removed by moderator'

    try {
      const headers = await authHeaders()
      const response = await fetch('/api/moderation/action', {
        method: 'POST',
        headers: { ...headers, 'Content-Type': 'application/json' },
        body: JSON.stringify({ contentType, contentId, action, reason }),
      })
      const payload = await response.json()
      if (!response.ok) throw new Error(payload.error ?? 'Moderation action failed.')
      await fetchItems()
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Moderation action failed.')
    }
  }

  return (
    <div>
      <div className="mb-6 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-2xl font-bold text-charcoal">{title}</h2>
          <p className="mt-1 text-sm text-slate">Review community content, resolve reports, and leave an audit trail.</p>
        </div>
        <div className="flex gap-2">
          <select
            value={filter}
            onChange={(event) => setFilter(event.target.value)}
            className="rounded-md border border-sage px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-forest"
          >
            {visibleFilters.map((value) => (
              <option key={value} value={value}>{value}</option>
            ))}
          </select>
          <button onClick={fetchItems} className="rounded-md bg-forest px-4 py-2 text-sm text-white hover:bg-opacity-90">
            Refresh
          </button>
        </div>
      </div>

      {error && (
        <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
          {error}
        </div>
      )}

      <div className="overflow-x-auto rounded-lg bg-white shadow">
        <table className="w-full min-w-[900px]">
          <thead className="bg-ivory">
            <tr>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Content</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Type</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Reporter / Author</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Reason / Action</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Status</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Created</th>
              <th className="px-6 py-3 text-left text-sm font-medium text-slate">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {loading ? (
              <tr><td colSpan={7} className="px-6 py-10 text-center text-slate">Loading...</td></tr>
            ) : items.length === 0 ? (
              <tr><td colSpan={7} className="px-6 py-10 text-center text-slate">No items found.</td></tr>
            ) : items.map((item) => {
              const content = item.content_preview ?? item.content ?? item.title ?? '(deleted)'
              const status = item.status ?? item.moderation_status ?? (item.is_moderated ? 'moderated' : 'pending')
              const contentType = item.content_type ?? (type === 'posts' ? 'post' : 'reply')
              return (
                <tr key={`${contentType}:${item.content_id ?? item.id}`} className="hover:bg-ivory/50">
                  <td className="max-w-md px-6 py-4 text-sm text-slate">
                    <div className="line-clamp-3">{content}</div>
                  </td>
                  <td className="px-6 py-4 text-sm capitalize">{contentType}</td>
                  <td className="px-6 py-4 text-sm text-slate">
                    {(item.anonymous_user_id ?? item.post_id ?? 'unknown').slice(0, 16)}
                  </td>
                  <td className="max-w-xs px-6 py-4 text-sm text-slate">
                    {item.reasons?.join(', ') ?? item.moderation_action ?? '-'}
                    {item.report_count ? <span className="ml-2 rounded-full bg-gold/20 px-2 py-1 text-xs text-gold">{item.report_count}</span> : null}
                  </td>
                  <td className="px-6 py-4">
                    <span className="rounded-full bg-sage/20 px-2 py-1 text-xs text-forest">{status}</span>
                  </td>
                  <td className="px-6 py-4 text-sm text-slate">
                    {new Date(item.latest_created_at ?? item.created_at ?? Date.now()).toLocaleDateString()}
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex gap-2">
                      <button onClick={() => moderate(item, 'approved')} className="rounded-md bg-forest px-3 py-1 text-xs text-white">Approve</button>
                      <button onClick={() => moderate(item, 'flagged')} className="rounded-md bg-gold px-3 py-1 text-xs text-white">Flag</button>
                      <button onClick={() => moderate(item, 'removed')} className="rounded-md bg-red-600 px-3 py-1 text-xs text-white">Remove</button>
                    </div>
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  )
}
