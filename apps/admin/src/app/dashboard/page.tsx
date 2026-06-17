import { supabaseAdmin } from '@/lib/supabase-admin'

async function getDashboardStats() {
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const { count: pendingReports } = await supabaseAdmin
    .from('community_reports')
    .select('*', { count: 'exact', head: true })
    .eq('status', 'pending')

  const { count: flaggedPosts } = await supabaseAdmin
    .from('community_posts')
    .select('*', { count: 'exact', head: true })
    .eq('moderation_status', 'flagged')

  const { count: moderatedToday } = await supabaseAdmin
    .from('community_posts')
    .select('*', { count: 'exact', head: true })
    .gte('created_at', today.toISOString())
    .neq('moderation_status', 'none')

  const { data: recentReports } = await supabaseAdmin
    .from('community_reports')
    .select('*')
    .order('created_at', { ascending: false })
    .limit(10)

  return { pendingReports, flaggedPosts, moderatedToday, recentReports }
}

async function getContentPreview(contentType: string, contentId: string) {
  if (contentType === 'post') {
    const { data } = await supabaseAdmin
      .from('community_posts')
      .select('content')
      .eq('id', contentId)
      .single()
    return data?.content || '(deleted)'
  }
  if (contentType === 'reply') {
    const { data } = await supabaseAdmin
      .from('community_replies')
      .select('content')
      .eq('id', contentId)
      .single()
    return data?.content || '(deleted)'
  }
  return '(unknown)'
}

export default async function DashboardPage() {
  const stats = await getDashboardStats()

  const reportsWithContent = await Promise.all(
    (stats.recentReports || []).map(async (report) => ({
      ...report,
      content_preview: await getContentPreview(report.content_type, report.content_id),
    }))
  )

  const cards = [
    { label: 'Pending Reports', value: stats.pendingReports ?? 0, color: 'bg-gold' },
    { label: 'Flagged Posts', value: stats.flaggedPosts ?? 0, color: 'bg-sage' },
    { label: 'Moderated Today', value: stats.moderatedToday ?? 0, color: 'bg-forest' },
  ]

  return (
    <div>
      <h2 className="text-2xl font-bold text-charcoal mb-6">Dashboard</h2>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        {cards.map((card) => (
          <div key={card.label} className="bg-white rounded-lg shadow p-6">
            <p className="text-slate text-sm mb-1">{card.label}</p>
            <p className="text-3xl font-bold text-charcoal">{card.value}</p>
          </div>
        ))}
      </div>

      <div className="bg-white rounded-lg shadow">
        <div className="px-6 py-4 border-b border-gray-100">
          <h3 className="text-lg font-semibold text-charcoal">Recent Reports</h3>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-ivory">
              <tr>
                <th className="text-left px-6 py-3 text-sm font-medium text-slate">Type</th>
                <th className="text-left px-6 py-3 text-sm font-medium text-slate">Content Preview</th>
                <th className="text-left px-6 py-3 text-sm font-medium text-slate">Reason</th>
                <th className="text-left px-6 py-3 text-sm font-medium text-slate">Status</th>
                <th className="text-left px-6 py-3 text-sm font-medium text-slate">Reported</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {reportsWithContent.map((report) => (
                <tr key={report.id} className="hover:bg-ivory/50">
                  <td className="px-6 py-4 text-sm capitalize">{report.content_type}</td>
                  <td className="px-6 py-4 text-sm text-slate max-w-xs truncate">
                    {report.content_preview.substring(0, 100)}
                  </td>
                  <td className="px-6 py-4 text-sm">{report.reason}</td>
                  <td className="px-6 py-4">
                    <span className={`inline-block px-2 py-1 text-xs rounded-full ${
                      report.status === 'pending' ? 'bg-gold/20 text-gold' :
                      report.status === 'resolved' ? 'bg-forest/20 text-forest' :
                      'bg-slate/20 text-slate'
                    }`}>
                      {report.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-sm text-slate">
                    {new Date(report.created_at).toLocaleDateString()}
                  </td>
                </tr>
              ))}
              {reportsWithContent.length === 0 && (
                <tr>
                  <td colSpan={5} className="px-6 py-8 text-center text-slate">
                    No reports yet.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
