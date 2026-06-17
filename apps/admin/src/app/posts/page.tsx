'use client'

import { useEffect, useState } from 'react'
import { supabaseAdmin } from '@/lib/supabase-admin'

interface Post {
  id: string
  content: string
  anonymous_user_id: string
  is_moderated: boolean
  moderation_status: string
  moderation_action: string
  created_at: string
}

export default function PostsPage() {
  const [posts, setPosts] = useState<Post[]>([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')

  async function fetchPosts() {
    setLoading(true)
    let query = supabaseAdmin
      .from('community_posts')
      .select('*')
      .order('created_at', { ascending: false })

    if (filter !== 'all') {
      query = query.eq('moderation_status', filter)
    }

    const { data, error } = await query

    if (error) {
      console.error('Error fetching posts:', error)
    } else {
      setPosts(data || [])
    }
    setLoading(false)
  }

  useEffect(() => {
    fetchPosts()
  }, [filter])

  async function handleUpdate(id: string, updates: Partial<Post>) {
    const { error } = await supabaseAdmin
      .from('community_posts')
      .update(updates)
      .eq('id', id)

    if (error) {
      console.error('Error updating post:', error)
      return
    }
    fetchPosts()
  }

  function confirmRemove(id: string) {
    if (window.confirm('Are you sure you want to remove this post?')) {
      handleUpdate(id, {
        moderation_status: 'removed',
        is_moderated: true,
        moderation_action: 'Removed by moderator',
      })
    }
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-2xl font-bold text-charcoal">Posts</h2>
        <div className="flex gap-2">
          <select
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
            className="px-3 py-2 border border-sage rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-forest"
          >
            <option value="all">All</option>
            <option value="none">None</option>
            <option value="flagged">Flagged</option>
            <option value="approved">Approved</option>
            <option value="removed">Removed</option>
          </select>
          <button
            onClick={fetchPosts}
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
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Author</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Status</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Action</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Created</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {posts.map((post) => (
              <tr key={post.id} className="hover:bg-ivory/50">
                <td className="px-6 py-4 text-sm text-slate max-w-sm truncate">
                  {post.content}
                </td>
                <td className="px-6 py-4 text-sm text-slate">
                  {post.anonymous_user_id?.substring(0, 12)}...
                </td>
                <td className="px-6 py-4">
                  <span className={`inline-block px-2 py-1 text-xs rounded-full ${
                    post.moderation_status === 'none' || !post.moderation_status ? 'bg-sage/20 text-sage' :
                    post.moderation_status === 'flagged' ? 'bg-gold/20 text-gold' :
                    post.moderation_status === 'approved' ? 'bg-forest/20 text-forest' :
                    post.moderation_status === 'removed' ? 'bg-red-100 text-red-700' :
                    'bg-slate/20 text-slate'
                  }`}>
                    {post.moderation_status || 'none'}
                  </span>
                </td>
                <td className="px-6 py-4 text-sm text-slate">
                  {post.moderation_action || '-'}
                </td>
                <td className="px-6 py-4 text-sm text-slate">
                  {new Date(post.created_at).toLocaleDateString()}
                </td>
                <td className="px-6 py-4">
                  <div className="flex gap-2">
                    {post.moderation_status !== 'approved' && (
                      <button
                        onClick={() => handleUpdate(post.id, { moderation_status: 'approved', is_moderated: false })}
                        className="px-3 py-1 text-xs bg-forest text-white rounded-md hover:bg-opacity-90 transition-colors"
                      >
                        Approve
                      </button>
                    )}
                    {post.moderation_status !== 'removed' && (
                      <button
                        onClick={() => confirmRemove(post.id)}
                        className="px-3 py-1 text-xs bg-red-600 text-white rounded-md hover:bg-opacity-90 transition-colors"
                      >
                        Remove
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
            {posts.length === 0 && (
              <tr>
                <td colSpan={6} className="px-6 py-8 text-center text-slate">
                  No posts found.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
