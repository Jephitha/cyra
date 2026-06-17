/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        forest: '#2D6A4F',
        sage: '#A3B18A',
        ivory: '#FFF8F0',
        gold: '#D4A373',
        charcoal: '#1A1A2E',
        slate: '#6B7280',
      },
    },
  },
  plugins: [],
}
