'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-ivory">
      <div className="bg-white rounded-lg shadow-lg p-8 max-w-md text-center">
        <h2 className="text-2xl font-bold text-charcoal mb-4">Something went wrong</h2>
        <p className="text-slate mb-6">{error.message}</p>
        <button
          onClick={reset}
          className="px-6 py-2 bg-forest text-white rounded-md hover:bg-opacity-90 transition-colors"
        >
          Try again
        </button>
      </div>
    </div>
  )
}
