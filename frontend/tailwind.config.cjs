/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}'
  ],
  theme: {
    extend: {
      colors: {
        pgblue: {
          50: '#eff6ff',
          100: '#dbeafe',
          500: '#0e7490',
          600: '#0ea5b7',
        }
      },
      boxShadow: {
        pg: '0 8px 24px rgba(15,23,42,0.06)'
      }
    }
  },
  plugins: []
}

