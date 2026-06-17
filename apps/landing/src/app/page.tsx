export default function Home() {
  return (
    <>
      <HeroSection />
      <FeaturesSection />
      <PlatformsSection />
      <CommunitySection />
    </>
  )
}

function HeroSection() {
  return (
    <section className="relative overflow-hidden bg-gradient-to-b from-forest-100 via-sage-100/60 to-ivory-50 px-4 pb-24 pt-16 sm:px-6 sm:pb-32 sm:pt-20 lg:px-8">
      <div className="absolute inset-0 overflow-hidden">
        <div className="absolute -right-40 -top-40 h-96 w-96 rounded-full bg-forest-200/30 blur-3xl" />
        <div className="absolute -bottom-32 -left-32 h-80 w-80 rounded-full bg-gold-200/20 blur-3xl" />
      </div>
      <div className="relative mx-auto max-w-4xl text-center">
        <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-forest-200 bg-ivory-50/80 px-4 py-1.5 text-xs font-medium text-forest-600 backdrop-blur-sm">
          <span className="flex h-2 w-2 rounded-full bg-sage-500" />
          Now available on iOS, Android &amp; Web
        </div>
        <h1 className="text-4xl font-extrabold tracking-tight text-forest-800 sm:text-5xl md:text-6xl lg:text-7xl">
          Track. <span className="text-sage-600">Understand.</span> Connect.
        </h1>
        <p className="mx-auto mt-6 max-w-2xl text-base leading-relaxed text-forest-600 sm:text-lg">
          Cyra empowers you to track your cycle with smart tools, gain AI-driven insights
          into your body, and join a safe, anonymous community of women on the same journey.
        </p>
        <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
          <a href="#" className="btn-primary w-full sm:w-auto">
            <svg className="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" aria-hidden="true">
              <path strokeLinecap="round" strokeLinejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5M16.5 12L12 16.5m0 0L7.5 12m4.5 4.5V3" />
            </svg>
            Download the App
          </a>
          <a href="#community" className="btn-secondary w-full sm:w-auto">
            <svg className="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" aria-hidden="true">
              <path strokeLinecap="round" strokeLinejoin="round" d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z" />
            </svg>
            Join the Community
          </a>
        </div>
      </div>
    </section>
  )
}

function FeaturesSection() {
  const features = [
    {
      title: 'Cycle Tracking',
      description:
        'Log your period, track symptoms, and monitor your cycle with an intuitive smart calendar. Spot patterns and predict your next cycle with confidence.',
      icon: (
        <svg className="h-7 w-7" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" aria-hidden="true">
          <path strokeLinecap="round" strokeLinejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
        </svg>
      ),
    },
    {
      title: 'AI Insights',
      description:
        'Receive personalized health predictions and insights powered by AI. Understand your body&apos;s unique rhythms and get tailored recommendations.',
      icon: (
        <svg className="h-7 w-7" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" aria-hidden="true">
          <path strokeLinecap="round" strokeLinejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.455 2.456L21.75 6l-1.036.259a3.375 3.375 0 00-2.455 2.456zM16.894 20.567L16.5 21.75l-.394-1.183a2.25 2.25 0 00-1.423-1.423L13.5 18.75l1.183-.394a2.25 2.25 0 001.423-1.423l.394-1.183.394 1.183a2.25 2.25 0 001.423 1.423l1.183.394-1.183.394a2.25 2.25 0 00-1.423 1.423z" />
        </svg>
      ),
    },
    {
      title: 'Anonymous Community',
      description:
        'Connect with women worldwide in a safe, anonymous space. Share experiences, ask questions, and find support without revealing your identity.',
      icon: (
        <svg className="h-7 w-7" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" aria-hidden="true">
          <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
        </svg>
      ),
    },
  ]

  return (
    <section id="features" className="bg-ivory-50 px-4 py-20 sm:px-6 sm:py-28 lg:px-8">
      <div className="mx-auto max-w-7xl">
        <div className="mx-auto max-w-2xl text-center">
          <h2 className="section-heading">Everything you need to thrive</h2>
          <p className="section-subheading">
            Cyra combines smart tracking, AI-powered insights, and a supportive community
            into one beautiful experience.
          </p>
        </div>
        <div className="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
          {features.map((feature) => (
            <div
              key={feature.title}
              className="group rounded-2xl border border-forest-100 bg-white p-8 shadow-sm transition-all hover:shadow-md hover:border-forest-200"
            >
              <div className="mb-5 flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-forest-100 to-sage-100 text-forest-600 group-hover:from-forest-500 group-hover:to-sage-500 group-hover:text-white transition-all duration-300">
                {feature.icon}
              </div>
              <h3 className="text-lg font-semibold text-forest-800">{feature.title}</h3>
              <p className="mt-3 text-sm leading-relaxed text-forest-600">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

function PlatformsSection() {
  const platforms = [
    {
      name: 'iOS',
      icon: (
        <svg className="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
          <rect x="4" y="1" width="16" height="22" rx="3" />
          <circle cx="12" cy="19" r="1" fill="currentColor" />
        </svg>
      ),
      status: 'available',
      badge: 'Available now',
    },
    {
      name: 'Android',
      icon: (
        <svg className="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
          <path d="M3 9v6m18-6v6M9 3l-3 4.5m9-4.5l3 4.5M7 21h10a2 2 0 002-2v-6a2 2 0 00-2-2H7a2 2 0 00-2 2v6a2 2 0 002 2z" />
        </svg>
      ),
      status: 'available',
      badge: 'Available now',
    },
    {
      name: 'Web',
      icon: (
        <svg className="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
          <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z" />
          <path d="M2 12h20M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z" />
        </svg>
      ),
      status: 'coming',
      badge: 'Coming soon',
    },
  ]

  return (
    <section id="platforms" className="bg-gradient-to-b from-ivory-50 to-forest-50 px-4 py-20 sm:px-6 sm:py-28 lg:px-8">
      <div className="mx-auto max-w-7xl">
        <div className="mx-auto max-w-2xl text-center">
          <h2 className="section-heading">Available Everywhere</h2>
          <p className="section-subheading">
            Take Cyra with you wherever you go. Your data syncs seamlessly across all your devices.
          </p>
        </div>
        <div className="mt-16 grid gap-6 sm:grid-cols-3">
          {platforms.map((platform) => (
            <div
              key={platform.name}
              className={`relative rounded-2xl border p-8 text-center shadow-sm transition-all ${
                platform.status === 'available'
                  ? 'border-forest-200 bg-white hover:shadow-md'
                  : 'border-forest-100/50 bg-white/60 backdrop-blur-sm'
              }`}
            >
              {platform.status === 'coming' && (
                <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                  <span className="inline-flex items-center rounded-full border border-gold-300 bg-gold-100 px-3 py-0.5 text-xs font-medium text-gold-700">
                    {platform.badge}
                  </span>
                </div>
              )}
              {platform.status === 'available' && (
                <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                  <span className="inline-flex items-center rounded-full border border-sage-300 bg-sage-100 px-3 py-0.5 text-xs font-medium text-sage-700">
                    {platform.badge}
                  </span>
                </div>
              )}
              <div className={`mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-2xl ${
                platform.status === 'available'
                  ? 'bg-gradient-to-br from-forest-100 to-sage-100 text-forest-600'
                  : 'bg-forest-50 text-forest-400'
              }`}>
                {platform.icon}
              </div>
              <h3 className={`text-lg font-semibold ${
                platform.status === 'available' ? 'text-forest-800' : 'text-forest-500'
              }`}>
                {platform.name}
              </h3>
              <p className={`mt-2 text-sm ${
                platform.status === 'available' ? 'text-forest-600' : 'text-forest-400'
              }`}>
                {platform.status === 'available'
                  ? 'Download from the app store'
                  : 'Coming to your browser soon'}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

function CommunitySection() {
  const testimonials = [
    {
      quote: 'Cyra&apos;s anonymous community helped me feel less alone in my journey. I can ask anything without fear of judgment.',
      author: 'Anonymous Member',
      role: 'Joined 6 months ago',
    },
    {
      quote: 'The AI insights are incredible. Cyra predicted my cycle changes before I even noticed. It truly understands my body.',
      author: 'Anonymous Member',
      role: 'Joined 1 year ago',
    },
    {
      quote: 'I finally found a space where I can talk openly about women&apos;s health. The community is so supportive and knowledgeable.',
      author: 'Anonymous Member',
      role: 'Joined 3 months ago',
    },
  ]

  return (
    <section id="community" className="bg-forest-800 px-4 py-20 sm:px-6 sm:py-28 lg:px-8">
      <div className="mx-auto max-w-7xl">
        <div className="mx-auto max-w-2xl text-center">
          <h2 className="text-3xl font-bold tracking-tight text-ivory-50 sm:text-4xl">
            A Safe Space for Every Journey
          </h2>
          <p className="mt-4 text-lg leading-8 text-forest-200">
            Join thousands of women who share, learn, and grow together in a judgment-free
            anonymous community.
          </p>
        </div>
        <div className="mt-16 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {testimonials.map((item, i) => (
            <div
              key={i}
              className="rounded-2xl border border-forest-600/50 bg-forest-700/50 p-6 backdrop-blur-sm transition-all hover:bg-forest-700/70"
            >
              <svg className="mb-4 h-8 w-8 text-gold-400/60" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M4.583 17.321C3.553 16.227 3 15 3 13.011c0-3.5 2.457-6.637 6.03-8.188l.893 1.378c-3.335 1.804-3.987 4.145-4.247 5.621.537-.278 1.24-.375 1.929-.311C9.591 11.69 11 13.154 11 15c0 1.933-1.567 3.5-3.5 3.5-1.271 0-2.404-.655-2.917-1.179zm10 0C13.553 16.227 13 15 13 13.011c0-3.5 2.457-6.637 6.03-8.188l.893 1.378c-3.335 1.804-3.987 4.145-4.247 5.621.537-.278 1.24-.375 1.929-.311C19.591 11.69 21 13.154 21 15c0 1.933-1.567 3.5-3.5 3.5-1.271 0-2.404-.655-2.917-1.179z" />
              </svg>
              <p className="text-sm leading-relaxed text-forest-100">
                &ldquo;{item.quote}&rdquo;
              </p>
              <div className="mt-6 border-t border-forest-600/30 pt-4">
                <p className="text-sm font-medium text-ivory-100">{item.author}</p>
                <p className="text-xs text-forest-300">{item.role}</p>
              </div>
            </div>
          ))}
        </div>
        <div className="mt-12 text-center">
          <a href="#" className="btn-primary bg-gold-500 text-forest-900 hover:bg-gold-600 focus-visible:outline-gold-500">
            <svg className="mr-2 h-5 w-5" fill="none" viewBox="0 0 24 24" strokeWidth="1.5" stroke="currentColor" aria-hidden="true">
              <path strokeLinecap="round" strokeLinejoin="round" d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z" />
            </svg>
            Join Our Community
          </a>
        </div>
      </div>
    </section>
  )
}
