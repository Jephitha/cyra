'use client'

import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabase'
import './globals.css'

const navigation = [
  { name: 'Dashboard', href: '/dashboard' },
  { name: 'Reports', href: '/reports' },
  { name: 'Posts', href: '/posts' },
  { name: 'Replies', href: '/replies' },
  { name: 'Operations', href: '/ops' },
]

const publicRoutes = new Set(['/'])

export default function RootLayout({ children }: { children: React.ReactNode }) {
  const [authenticated, setAuthenticated] = useState<boolean | null>(null)

  useEffect(() => {
    if (publicRoutes.has(window.location.pathname)) {
      setAuthenticated(false)
      return
    }
    supabase.auth.getSession().then(({ data: { session } }) => {
      setAuthenticated(!!session)
      if (!session && window.location.pathname !== '/login') {
        window.location.href = '/login'
      }
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setAuthenticated(!!session)
      if (!session && window.location.pathname !== '/login') {
        window.location.href = '/login'
      }
    })

    return () => subscription.unsubscribe()
  }, [])

  if (authenticated === null) {
    return (
      <html lang="en">
        <head>
          <link rel="preconnect" href="https://fonts.googleapis.com" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
          <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
        </head>
        <body>
          <div className="min-h-screen flex items-center justify-center bg-ivory">
            <div className="animate-spin h-8 w-8 border-4 border-forest border-t-transparent rounded-full" />
          </div>
        </body>
      </html>
    )
  }

  if (!authenticated) {
    return (
      <html lang="en">
        <head>
          <link rel="preconnect" href="https://fonts.googleapis.com" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
          <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
        </head>
        <body>{children}</body>
      </html>
    )
  }

  return (
    <html lang="en">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
      </head>
      <body>
        <div className="flex min-h-screen">
          <aside className="w-64 bg-charcoal text-white flex flex-col">
            <div className="p-6 border-b border-gray-700">
              <h1 className="text-xl font-bold text-gold">Cyra Admin</h1>
            </div>
            <nav className="flex-1 p-4 space-y-1">
              {navigation.map((item) => (
                <a
                  key={item.name}
                  href={item.href}
                  className="block px-4 py-2 rounded-md hover:bg-gray-700 transition-colors"
                >
                  {item.name}
                </a>
              ))}
            </nav>
            <div className="p-4 border-t border-gray-700">
              <button
                onClick={async () => {
                  await supabase.auth.signOut()
                  window.location.href = '/login'
                }}
                className="w-full px-4 py-2 text-sm text-slate hover:text-white transition-colors"
              >
                Sign Out
              </button>
            </div>
          </aside>
          <main className="flex-1 p-8">{children}</main>
        </div>
      </body>
    </html>
  )
}
