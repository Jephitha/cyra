'use client'

import { useEffect, useState } from 'react'
import { supabaseAdmin } from '@/lib/supabase-admin'

interface Reply {
  id: string
  post_id: string
  content: string
  anonymous_user_id: string
  is_moderated: boolean
  moderation_action: string
  created_at: string
}

export default function RepliesPage() {
  const [replies, setReplies] = useState<Reply[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')

  async function fetchReplies() {
    setLoading(true)
    let query = supabaseAdmin
      .from('community_replies')
      .select('*')
      .order('created_at', { ascending: false })

    if (filter !== 'all') {
      query = query.eq('is_moderated', filter === 'moderated')
    }

    const { data, error } = await query

    if (error) {
      console.error('Error fetching replies:', error)
    } else {
      setReplies(data || [])
    }
    setLoading(false)
  }

  useEffect(() => {
    fetchReplies()
  }, [filter])

  async function handleRemove(id: string) {
    const { error } = await supabaseAdmin
      .from('community_replies')
      .update({
        is_moderated: true,
        moderation_action: 'Removed by moderator',
      })
      .eq('id', id)

    if (error) {
      console.error('Error removing reply:', error)
      return
    }
    fetchReplies()
  }

  async function handleApprove(id: string) {
    const { error } = await supabaseAdmin
      .from('community_replies')
      .update({
        is_moderated: false,
      })
      .eq('id', id)

    if (error) {
      console.error('Error approving reply:', error)
      return
    }
    fetchReplies()
  }

  function confirmRemove(id: string) {
    if (window.confirm('Are you sure you want to remove this reply?')) {
      handleRemove(id)
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin h-8 w-8 border-4 border-forest border-t-transparent rounded-full" />
      </div>
    )
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-charcoal">Replies</h2>
        <div className="flex gap-2">
          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="px-3 py-2 border border-sage rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-forest"
          >
            <option value="all">All</option>
            <option value="moderated">Moderated</option>
            <option value="false">Not Moderated</option>
          </select>
          <button
            onClick={fetchReplies}
            className="px-4 py-2 bg-forest text-white rounded-md hover:bg-opacity-90 transition-colors text-sm"
          >
            Refresh
          </button>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow overflow-x-auto">
        <table className="w-full">
          <thead className="bg-ivory">
            <tr>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Content</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Post ID</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Author</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Moderated</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Action</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Created</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {replies.map((reply) => (
              <tr key={reply.id} className="hover:bg-ivory/50">
                <td className="px-6 py-4 text-sm text-slate max-w-sm truncate">
                  {reply.content}
                </td>
                <td className="px-6 py-4 text-sm text-slate font-mono">
                  {reply.post_id?.substring(0, 12)}...
                </td>
                <td className="px-6 py-4 text-sm text-slate">
                  {reply.anonymous_user_id?.substring(0, 12)}...
                </td>
                <td className="px-6 py-4">
                  <span className={`inline-block px-2 py-1 text-xs rounded-full ${
                    reply.is_moderated ? 'bg-gold/20 text-gold' : 'bg-sage/20 text-sage'
                  }`}>
                    {reply.is_moderated ? 'Yes' : 'No'}
                  </span>
                </td>
                <td className="px-6 py-4 text-sm text-slate">
                  {reply.moderation_action || '-'}
                </td>
                <td className="px-6 py-4 text-sm text-slate">
                  {new Date(reply.created_at).toLocaleDateString()}
                </td>
                <td className="px-6 py-4">
                  <div className="flex gap-2">
                    {reply.is_moderated && (
                      <button
                        onClick={() => handleApprove(reply.id)}
                        className="px-3 py-1 text-xs bg-forest text-white rounded-md hover:bg-opacity-90 transition-colors"
                      >
                        Approve
                      </button>
                    )}
                    {!reply.is_moderated && (
                      <button
                        onClick={() => confirmRemove(reply.id)}
                        className="px-3 py-1 text-xs bg-red-600 text-white rounded-md hover:bg-opacity-90 transition-colors"
                      >
                        Remove
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
            {replies.length === 0 && (
              <tr>
                <td colSpan={7} className="px-6 py-8 text-center text-slate">
                  No replies found.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
