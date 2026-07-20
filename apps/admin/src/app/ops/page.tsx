'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'

interface OpsSummary {
  exportsQueued: number
  deletionQueued: number
  latestBackups: Array<{
    environment: string
    backup_type: string
    status: string
    started_at: string
    completed_at?: string
  }>
  criticalEvents: Array<{
    severity: string
    source: string
    event_type: string
    created_at: string
  }>
}

export default function OpsPage() {
  const [summary, setSummary] = useState<OpsSummary | null>(null)
  const [error, setError] = useState<string | null>(null)

  async function load() {
    setError(null)
    const { data } = await supabase.auth.getSession()
    const token = data.session?.access_token
    if (!token) {
      setError('Admin session expired. Sign in again.')
      return
    }
    const response = await fetch('/api/ops/summary', {
      headers: { Authorization: `Bearer ${token}` },
    })
    const payload = await response.json()
    if (!response.ok) {
      setError(payload.error ?? 'Could not load operations summary.')
      return
    }
    setSummary(payload)
  }

  useEffect(() => {
    load()
  }, [])

  return (
    <div>
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold text-charcoal">Operations</h2>
          <p className="mt-1 text-sm text-slate">Data requests, deletion jobs, backups, and alerts.</p>
        </div>
        <button onClick={load} className="rounded-md bg-forest px-4 py-2 text-sm text-white">Refresh</button>
      </div>

      {error && <div className="mb-4 rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">{error}</div>}

      <div className="mb-8 grid grid-cols-1 gap-6 md:grid-cols-2">
        <div className="rounded-lg bg-white p-6 shadow">
          <p className="text-sm text-slate">Queued exports</p>
          <p className="mt-2 text-3xl font-bold text-charcoal">{summary?.exportsQueued ?? '-'}</p>
        </div>
        <div className="rounded-lg bg-white p-6 shadow">
          <p className="text-sm text-slate">Queued deletions</p>
          <p className="mt-2 text-3xl font-bold text-charcoal">{summary?.deletionQueued ?? '-'}</p>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-6 xl:grid-cols-2">
        <section className="rounded-lg bg-white shadow">
          <div className="border-b border-gray-100 px-6 py-4">
            <h3 className="font-semibold text-charcoal">Latest backups</h3>
          </div>
          <div className="divide-y divide-gray-100">
            {summary?.latestBackups?.length ? summary.latestBackups.map((backup, index) => (
              <div key={`${backup.started_at}-${index}`} className="px-6 py-4 text-sm">
                <div className="flex justify-between">
                  <span className="font-medium text-charcoal">{backup.environment} / {backup.backup_type}</span>
                  <span className="text-slate">{backup.status}</span>
                </div>
                <p className="mt-1 text-xs text-slate">{new Date(backup.started_at).toLocaleString()}</p>
              </div>
            )) : <p className="px-6 py-8 text-sm text-slate">No backup runs recorded.</p>}
          </div>
        </section>

        <section className="rounded-lg bg-white shadow">
          <div className="border-b border-gray-100 px-6 py-4">
            <h3 className="font-semibold text-charcoal">Recent alerts</h3>
          </div>
          <div className="divide-y divide-gray-100">
            {summary?.criticalEvents?.length ? summary.criticalEvents.map((event, index) => (
              <div key={`${event.created_at}-${index}`} className="px-6 py-4 text-sm">
                <div className="flex justify-between">
                  <span className="font-medium text-charcoal">{event.event_type}</span>
                  <span className="text-red-600">{event.severity}</span>
                </div>
                <p className="mt-1 text-xs text-slate">{event.source} · {new Date(event.created_at).toLocaleString()}</p>
              </div>
            )) : <p className="px-6 py-8 text-sm text-slate">No critical events recorded.</p>}
          </div>
        </section>
      </div>
    </div>
  )
}
