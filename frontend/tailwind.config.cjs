/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}'
  ],
  safelist: [
    // 强制生成所有healing色系的渐变类
    'from-healing-500',
    'to-healing-600',
    'bg-healing-500',
    'bg-healing-600',
    'bg-healing-50',
    'bg-healing-100',
    'text-healing-500',
    'text-healing-600',
    'text-healing-800',
    'border-healing-500',
    'hover:bg-healing-600',
    'shadow-healing-500/10',
    'shadow-healing-500/20',
    // 强制生成所有clay色系的渐变类
    'from-clay-500',
    'to-clay-600',
    'bg-clay-500',
    'bg-clay-600',
    'bg-clay-50',
    'bg-clay-100',
    'text-clay-500',
    'text-clay-600',
    'shadow-clay-500/20',
    //强制生成rock色系
    'text-rock-600',
    'text-rock-800',
    'text-rock-900',
    // 强制生成cream色系
    'bg-cream-50',
    'bg-cream-100',
    'bg-cream-200',
    'border-cream-200'
  ],
  theme: {
    extend: {
      colors: {
        // healing (主色 - 青瓷绿)
        healing: {
          50: '#F0F7F4',
          100: '#E1EFE9',
          200: '#C2DFCE',
          400: '#8CAE9D',
          500: '#6B9080',
          600: '#557366',
          800: '#557366'
        },
        // cream (背景色 - 米汤白/奶油白)
        cream: {
          50: '#FBF9F7',
          100: '#F6F4F1',
          200: '#EBE6E0',
          300: '#E0DCD6'
        },
        // clay (强调色 - 落日陶土)
        clay: {
          50: '#FDF4F1',
          100: '#F9E5E1',
          200: '#F3D1C9',
          500: '#E07A5F',
          600: '#B3614C',
          700: '#8B4C3A'
        },
        // rock (文字色 - 岩石暖灰)
        rock: {
          400: '#A7A7B3', // 修正更浅的灰色
          500: '#8F8F9D',
          600: '#7B7B8D',
          800: '#4A4E69',
          900: '#22223B'
        }
      },
      animation: {
        'fade-in': 'fadeIn 0.5s ease-out',
        'float': 'float 3s ease-in-out infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0', transform: 'translateY(10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        }
      },
      boxShadow: {
        pg: '0 8px 24px rgba(74, 78, 105, 0.08)' // 调整为 rock 色系的柔和投影
      }
    }
  },
  plugins: []
}
