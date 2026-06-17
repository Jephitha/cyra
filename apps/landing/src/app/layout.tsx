import type { Metadata, Viewport } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Cyra — Holistic Women\'s Health Tracking',
  description: 'Track your cycle, understand your body, and connect with a supportive community.',
  openGraph: {
    title: 'Cyra — Holistic Women\'s Health Tracking',
    description: 'Track your cycle, understand your body, and connect with a supportive community.',
    type: 'website',
    siteName: 'Cyra',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Cyra — Holistic Women\'s Health Tracking',
    description: 'Track your cycle, understand your body, and connect with a supportive community.',
  },
}

export const viewport: Viewport = {
  width: 'device-width',
  initialScale: 1,
  themeColor: '#1a5433',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
      </head>
      <body className={inter.className}>
        <div className="flex min-h-screen flex-col">
          <header className="sticky top-0 z-50 border-b border-forest-100/60 bg-ivory-50/95 backdrop-blur-sm">
            <nav className="mx-auto flex max-w-7xl items-center justify-between px-4 py-4 sm:px-6 lg:px-8">
              <a href="/" className="flex items-center gap-2">
                <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-to-br from-forest-500 to-sage-500 text-sm font-bold text-white">C</span>
                <span className="text-xl font-bold text-forest-800">Cyra</span>
              </a>
              <div className="flex items-center gap-6">
                <a href="#features" className="text-sm font-medium text-forest-600 transition-colors hover:text-forest-800">Features</a>
                <a href="#platforms" className="text-sm font-medium text-forest-600 transition-colors hover:text-forest-800">Platforms</a>
                <a href="#community" className="text-sm font-medium text-forest-600 transition-colors hover:text-forest-800">Community</a>
                <a href="#" className="btn-primary text-xs px-4 py-2">Download</a>
              </div>
            </nav>
          </header>
          <main className="flex-1">{children}</main>
          <footer className="border-t border-forest-100 bg-forest-50/50">
            <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
              <div className="flex flex-col items-center justify-between gap-4 sm:flex-row">
                <div className="flex items-center gap-2">
                  <span className="flex h-6 w-6 items-center justify-center rounded-md bg-gradient-to-br from-forest-500 to-sage-500 text-xs font-bold text-white">C</span>
                  <span className="text-sm font-semibold text-forest-700">Cyra</span>
                </div>
                <div className="flex items-center gap-6">
                  <a href="#" className="text-xs text-forest-500 transition-colors hover:text-forest-700">About</a>
                  <a href="#" className="text-xs text-forest-500 transition-colors hover:text-forest-700">Privacy</a>
                  <a href="#" className="text-xs text-forest-500 transition-colors hover:text-forest-700">Terms</a>
                  <a href="#" className="text-xs text-forest-500 transition-colors hover:text-forest-700">Contact</a>
                </div>
                <p className="text-xs text-forest-400">&copy; 2025 Cyra. All rights reserved.</p>
              </div>
            </div>
          </footer>
        </div>
      </body>
    </html>
  )
}
