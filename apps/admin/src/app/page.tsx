import { ClarityScript } from './clarity'

const trustItems = [
  'Private cycle, fertility, pregnancy, and symptom tracking',
  'Anonymous community with report queues and human moderation',
  'Local-first controls for export, deletion, reminders, and emergency privacy',
]

const supportItems = [
  ['Reports queue', 'Review posts and replies with repeated report grouping.'],
  ['Moderation actions', 'Approve, flag, remove, notify, and audit every decision.'],
  ['Ops readiness', 'Track exports, deletion jobs, backups, alerts, and rate-limit events.'],
]

export default function LandingPage() {
  return (
    <>
      <ClarityScript />
      <main className="min-h-screen bg-ivory">
        <header className="border-b border-forest/10 bg-white">
          <nav className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
            <a href="/" className="flex items-center gap-3">
              <img src="/cyra-app-icon.png" alt="" className="h-10 w-10 rounded-lg" />
              <span className="text-xl font-bold text-charcoal">Cyra</span>
            </a>
            <div className="flex items-center gap-5 text-sm">
              <a href="#product" className="text-slate hover:text-charcoal">Product</a>
              <a href="#trust" className="text-slate hover:text-charcoal">Trust</a>
              <a href="/login" className="rounded-md bg-forest px-4 py-2 font-medium text-white">Moderator login</a>
            </div>
          </nav>
        </header>

        <section className="relative overflow-hidden bg-white">
          <div className="mx-auto grid min-h-[680px] max-w-7xl grid-cols-1 items-center gap-12 px-6 py-16 lg:grid-cols-[0.95fr_1.05fr]">
            <div>
              <p className="text-sm font-semibold uppercase tracking-wide text-forest">Cyra women&apos;s health companion</p>
              <h1 className="mt-4 text-5xl font-bold leading-tight text-charcoal md:text-6xl">
                Private health tracking with community care behind it.
              </h1>
              <p className="mt-6 max-w-xl text-lg leading-8 text-slate">
                Cyra helps users understand cycles, symptoms, fertility signals, and pregnancy milestones while giving the team a real support and moderation console for safer community operations.
              </p>
              <div className="mt-8 flex flex-wrap gap-3">
                <a href="/login" className="rounded-md bg-forest px-5 py-3 text-sm font-semibold text-white">Open support console</a>
                <a href="#trust" className="rounded-md border border-sage px-5 py-3 text-sm font-semibold text-charcoal">Review trust model</a>
              </div>
            </div>
            <div className="relative">
              <div className="mx-auto max-w-md overflow-hidden rounded-[2rem] border border-gray-200 bg-charcoal p-3 shadow-2xl">
                <div className="rounded-[1.5rem] bg-ivory p-5">
                  <div className="mb-5 flex items-center justify-between">
                    <img src="/cyra-lockup.png" alt="Cyra" className="h-8 w-auto" />
                    <span className="rounded-full bg-sage/25 px-3 py-1 text-xs font-medium text-forest">Today</span>
                  </div>
                  <div className="rounded-lg bg-white p-5 shadow-sm">
                    <p className="text-sm text-slate">Cycle overview</p>
                    <p className="mt-2 text-3xl font-bold text-charcoal">Day 14</p>
                    <div className="mt-5 h-3 rounded-full bg-sage/30">
                      <div className="h-3 w-1/2 rounded-full bg-forest" />
                    </div>
                    <p className="mt-4 text-sm leading-6 text-slate">Predictions are estimates with uncertainty language and privacy-first controls.</p>
                  </div>
                  <div className="mt-4 grid grid-cols-2 gap-3">
                    <div className="rounded-lg bg-white p-4">
                      <p className="text-xs text-slate">Community</p>
                      <p className="mt-2 text-lg font-semibold text-charcoal">Moderated</p>
                    </div>
                    <div className="rounded-lg bg-white p-4">
                      <p className="text-xs text-slate">Data</p>
                      <p className="mt-2 text-lg font-semibold text-charcoal">User-owned</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <section id="product" className="border-y border-forest/10 bg-ivory px-6 py-16">
          <div className="mx-auto max-w-7xl">
            <h2 className="text-3xl font-bold text-charcoal">Built for the app and the team operating it</h2>
            <div className="mt-8 grid grid-cols-1 gap-4 md:grid-cols-3">
              {supportItems.map(([title, body]) => (
                <article key={title} className="rounded-lg bg-white p-6 shadow-sm">
                  <h3 className="font-semibold text-charcoal">{title}</h3>
                  <p className="mt-3 text-sm leading-6 text-slate">{body}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section id="trust" className="bg-white px-6 py-16">
          <div className="mx-auto grid max-w-7xl grid-cols-1 gap-10 lg:grid-cols-[0.8fr_1.2fr]">
            <div>
              <h2 className="text-3xl font-bold text-charcoal">Trust and safety are product features.</h2>
              <p className="mt-4 text-slate">The launch path now separates debug backend setup from release production credentials, removes premature Health Connect/HealthKit access, and keeps analytics away from sensitive moderation work.</p>
            </div>
            <ul className="grid grid-cols-1 gap-3">
              {trustItems.map((item) => (
                <li key={item} className="rounded-lg border border-sage/40 bg-ivory px-5 py-4 text-sm text-charcoal">
                  {item}
                </li>
              ))}
            </ul>
          </div>
        </section>
      </main>
    </>
  )
}
