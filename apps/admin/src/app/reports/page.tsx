'use client'

import { useEffect, useState } from 'react'
import { supabaseAdmin } from '@/lib/supabase-admin'

interface Report {
  content_type: string
  content_id: string
  reason: string
  status: string
  created_at: string
}

interface AggregatedReport {
  content_type: string
  content_id: string
  reasons: string[]
  status: string
  report_count: number
  latest_created_at: string
  content_preview?: string
}

export default function ReportsPage() {
  const [reports, setReports] = useState<AggregatedReport[]>([])
  const [loading, setLoading] = useState(true)

  async function fetchReports() {
    setLoading(true)
    const { data, error } = await supabaseAdmin
      .from('community_reports')
      .select('content_type, content_id, reason, status, created_at')
      .order('created_at', { ascending: false })

    if (error) {
      console.error('Error fetching reports:', error)
      setLoading(false)
      return
    }

    const grouped: Record<string, AggregatedReport> = {}
    for (const r of (data as Report[])) {
      const key = `${r.content_type}:${r.content_id}`
      if (!grouped[key]) {
        grouped[key] = {
          content_type: r.content_type,
          content_id: r.content_id,
          reasons: [],
          status: r.status,
          report_count: 0,
          latest_created_at: r.created_at,
        }
      }
      grouped[key].reasons.push(r.reason)
      grouped[key].report_count++
      if (new Date(r.created_at) > new Date(grouped[key].latest_created_at)) {
        grouped[key].latest_created_at = r.created_at
      }
      if (r.status !== 'pending') {
        grouped[key].status = r.status
      }
    }

    const groupedArray = Object.values(grouped)
    groupedArray.sort(
      (a, b) => new Date(b.latest_created_at).getTime() - new Date(a.latest_created_at).getTime()
    )

    for (const report of groupedArray) {
      const table = report.content_type === 'post' ? 'community_posts' : 'community_replies'
      const { data: contentData } = await supabaseAdmin
        .from(table)
        .select('content')
        .eq('id', report.content_id)
        .single()
      report.content_preview = contentData?.content?.substring(0, 100) || '(deleted)'
    }

    setReports(groupedArray)
    setLoading(false)
  }

  useEffect(() => {
    fetchReports()
  }, [])

  async function handleRemove(contentType: string, contentId: string) {
    const table = contentType === 'post' ? 'community_posts' : 'community_replies'
    const { error } = await supabaseAdmin
      .from(table)
      .update({
        moderation_status: 'removed',
        is_moderated: true,
        moderation_action: 'Removed by moderator',
      })
      .eq('id', contentId)

    if (error) {
      console.error('Error removing content:', error)
      return
    }

    await supabaseAdmin
      .from('community_reports')
      .update({ status: 'resolved' })
      .eq('content_id', contentId)

    fetchReports()
  }

  async function handleApprove(contentType: string, contentId: string) {
    const table = contentType === 'post' ? 'community_posts' : 'community_replies'
    const { error } = await supabaseAdmin
      .from(table)
      .update({
        moderation_status: 'approved',
        is_moderated: false,
      })
      .eq('id', contentId)

    if (error) {
      console.error('Error approving content:', error)
      return
    }

    await supabaseAdmin
      .from('community_reports')
      .update({ status: 'resolved' })
      .eq('content_id', contentId)

    fetchReports()
  }

  async function handleFlag(contentType: string, contentId: string) {
    const table = contentType === 'post' ? 'community_posts' : 'community_replies'
    await supabaseAdmin
      .from(table)
      .update({ moderation_status: 'flagged' })
      .eq('id', contentId)

    fetchReports()
  }

  function confirmRemove(contentType: string, contentId: string) {
    if (window.confirm('Are you sure you want to remove this content? This action cannot be undone.')) {
      handleRemove(contentType, contentId)
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
        <h2 className="text-2xl font-bold text-charcoal">Reports</h2>
        <button
          onClick={fetchReports}
          className="px-4 py-2 bg-forest text-white rounded-md hover:bg-opacity-90 transition-colors text-sm"
        >
          Refresh
        </button>
      </div>

      <div className="bg-white rounded-lg shadow overflow-x-auto">
        <table className="w-full">
          <thead className="bg-ivory">
            <tr>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Type</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Content Preview</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Reason</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Reports</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Status</th>
              <th className="text-left px-6 py-3 text-sm font-medium text-slate">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {reports.map((report) => (
              <tr key={`${report.content_type}:${report.content_id}`} className="hover:bg-ivory/50">
                <td className="px-6 py-4 text-sm capitalize">
                  <span className={`inline-block px-2 py-1 text-xs rounded-full ${
                    report.content_type === 'post' ? 'bg-blue-100 text-blue-700' : 'bg-purple-100 text-purple-700'
                  }`}>
                    {report.content_type}
                  </span>
                </td>
                <td className="px-6 py-4 text-sm text-slate max-w-xs truncate">
                  {report.content_preview}
                </td>
                <td className="px-6 py-4 text-sm max-w-xs">
                  <div className="truncate">{report.reasons.join(', ')}</div>
                </td>
                <td className="px-6 py-4">
                  <span className="inline-flex items-center justify-center bg-gold/20 text-gold text-sm font-semibold px-2 py-1 rounded-full min-w-[2rem]">
                    {report.report_count}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <span className={`inline-block px-2 py-1 text-xs rounded-full ${
                    report.status === 'pending' ? 'bg-gold/20 text-gold' :
                    report.status === 'resolved' ? 'bg-forest/20 text-forest' :
                    'bg-slate/20 text-slate'
                  }`}>
                    {report.status}
                  </span>
                </td>
                <td className="px-6 py-4">
                  <div className="flex gap-2">
                    <button
                      onClick={() => handleApprove(report.content_type, report.content_id)}
                      className="px-3 py-1 text-xs bg-forest text-white rounded-md hover:bg-opacity-90 transition-colors"
                    >
                      Approve
                    </button>
                    <button
                      onClick={() => handleFlag(report.content_type, report.content_id)}
                      className="px-3 py-1 text-xs bg-gold text-white rounded-md hover:bg-opacity-90 transition-colors"
                    >
                      Flag
                    </button>
                    <button
                      onClick={() => confirmRemove(report.content_type, report.content_id)}
                      className="px-3 py-1 text-xs bg-red-600 text-white rounded-md hover:bg-opacity-90 transition-colors"
                    >
                      Remove
                    </button>
                  </div>
                </td>
              </tr>
            ))}
            {reports.length === 0 && (
              <tr>
                <td colSpan={6} className="px-6 py-8 text-center text-slate">
                  No reports found.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  )
}
