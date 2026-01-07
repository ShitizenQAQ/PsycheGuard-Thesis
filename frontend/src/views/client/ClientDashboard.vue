<template>
  <div class="min-h-screen bg-cream-100 font-sans pb-20">
    <!-- 顶部导航栏 (简化版) -->
    <div class="bg-white/80 backdrop-blur-md sticky top-0 z-50 border-b border-cream-200 px-6 py-4 flex justify-between items-center shadow-sm">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-healing-500 flex items-center justify-center text-white font-bold shadow-lg shadow-healing-500/20">PG</div>
        <span class="text-rock-800 font-bold text-lg tracking-tight">PsycheGuard</span>
      </div>
      <div class="flex items-center gap-4">
        <span class="text-rock-500 text-sm hidden md:block">{{ currentTime }}</span>
        <div class="h-8 w-[1px] bg-cream-300 mx-2 hidden md:block"></div>
        <button @click="logout" class="text-rock-500 hover:text-rock-800 transition-colors text-sm font-medium flex items-center gap-1">
          <span>退出</span>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
        </button>
      </div>
    </div>

    <div class="max-w-4xl mx-auto px-6 pt-10 space-y-12 fade-up">
      
      <!-- 头部欢迎区 -->
      <div class="relative">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
          <div class="flex items-center gap-5">
            <div class="relative">
              <img :src="avatarUrl" class="w-20 h-20 rounded-full border-4 border-white shadow-xl bg-healing-50" alt="Avatar"/>
              <div class="absolute bottom-0 right-0 w-6 h-6 bg-healing-500 rounded-full border-2 border-white"></div>
            </div>
            <div>
              <h1 class="text-3xl font-bold text-rock-800 mb-1">早安，{{ realName }}</h1>
              <p class="text-rock-500 font-medium">愿你今天拥有好心情 🌿</p>
            </div>
          </div>
          
          <!-- CTA Group -->
          <div class="flex flex-col sm:flex-row gap-4 w-full md:w-auto">
             <button 
              @click="viewHistory"
              class="group relative overflow-hidden bg-white text-rock-600 px-6 py-5 rounded-3xl shadow-lg border border-cream-200 hover:border-healing-200 hover:text-healing-600 transition-all duration-300 w-full sm:w-auto text-left flex items-center gap-4"
            >
               <div class="w-10 h-10 bg-cream-100 rounded-full flex items-center justify-center text-rock-500 group-hover:text-healing-600 group-hover:bg-healing-50 transition-colors">
                 <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
               </div>
               <div>
                 <span class="text-xs opacity-60 uppercase tracking-wider font-bold block mb-0.5">Records</span>
                 <span class="font-bold">历史记录</span>
               </div>
            </button>

            <button 
              @click="startAssessment"
              class="cta-button group relative overflow-hidden text-white px-8 py-5 rounded-3xl shadow-xl hover:-translate-y-1 transition-all duration-300 w-full sm:w-auto text-left md:text-center"
            >
              <div class="absolute inset-0 bg-white/20 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div class="relative z-10 flex items-center justify-between gap-6">
                <div class="flex flex-col">
                  <span class="text-xs opacity-80 uppercase tracking-wider font-bold mb-1">Pending Task</span>
                  <span class="text-xl font-bold whitespace-nowrap">开始今日测评</span>
                </div>
                <div class="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-sm group-hover:scale-110 transition-transform">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                </div>
              </div>
              <!-- 呼吸光斑 -->
              <div class="absolute -right-10 -top-10 w-32 h-32 bg-white/10 rounded-full blur-2xl animate-pulse"></div>
            </button>
          </div>
        </div>
      </div>

      <!-- 情绪趋势图表 -->
      <div class="bg-white rounded-[2rem] p-8 shadow-sm border border-cream-200 relative overflow-hidden">
         <div class="flex justify-between items-center mb-8">
           <div>
             <h2 class="text-xl font-bold text-rock-800">我的情绪变化趋势</h2>
             <p class="text-rock-400 text-xs mt-1">Emotional Trends (Last 7 Days)</p>
           </div>
           <div class="flex gap-2">
             <span class="w-3 h-3 rounded-full bg-healing-500"></span>
             <span class="text-xs text-rock-500">情绪指数</span>
           </div>
         </div>
         <div ref="chartRef" class="w-full h-64"></div>
         <!-- 装饰背景 -->
         <div class="absolute top-0 right-0 w-64 h-64 bg-healing-50 rounded-full mix-blend-multiply filter blur-3xl opacity-50 pointer-events-none -z-0"></div>
      </div>

      <!-- 舒缓阅读区 -->
      <div id="reading-corner">
        <h2 class="text-xl font-bold text-rock-800 mb-6 flex items-center gap-2">
          <span>🍵</span>
          <span>舒缓阅读区</span>
        </h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div 
            v-for="article in articles" 
            :key="article.id"
            class="group bg-white rounded-3xl p-2 border border-cream-200 hover:border-healing-200 transition-colors shadow-sm cursor-pointer" 
            @click="openArticle(article)"
          >
            <div class="bg-cream-100 rounded-[1.2rem] h-40 w-full mb-4 overflow-hidden relative">
               <img :src="article.cover" class="w-full h-full object-cover opacity-90 group-hover:scale-105 transition-transform duration-700" :alt="article.title"/>
            </div>
            <div class="px-3 pb-4">
              <h3 class="font-bold text-rock-800 text-lg mb-2 group-hover:text-healing-600 transition-colors">{{ article.title }}</h3>
              <p class="text-rock-500 text-sm line-clamp-2">{{ article.summary }}</p>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- 文章阅读弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      width="600px"
      align-center
      destroy-on-close
      :show-close="false"
      class="healing-dialog !rounded-[2rem] overflow-hidden !p-0"
    >
      <template #header="{ close, titleId, titleClass }">
        <div class="hidden"></div> <!-- Hide default header -->
      </template>
      
      <div v-if="currentArticle" class="relative bg-cream-50 min-h-[400px]">
        <!-- 关闭按钮 -->
        <button @click="dialogVisible = false" class="absolute top-4 right-4 z-20 w-8 h-8 rounded-full bg-white/50 backdrop-blur-md flex items-center justify-center text-rock-600 hover:bg-white transition-colors">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
        </button>

        <!-- 封面图 -->
        <div class="h-48 w-full overflow-hidden relative">
          <img :src="currentArticle.cover" class="w-full h-full object-cover" />
          <div class="absolute inset-0 bg-gradient-to-t from-cream-50 to-transparent opacity-80"></div>
        </div>

        <!-- 内容区 -->
        <div class="px-8 pb-10 -mt-10 relative z-10">
          <h2 class="text-2xl font-bold text-rock-800 mb-6 drop-shadow-sm">{{ currentArticle.title }}</h2>
          <div class="prose prose-stone text-rock-600 leading-relaxed space-y-4" v-html="currentArticle.content"></div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import { ElMessage } from 'element-plus'

const router = useRouter()
const chartRef = ref<HTMLDivElement | null>(null)

// 模拟用户信息
const user = JSON.parse(localStorage.getItem('pg_user') || '{}')
const realName = user.realName || user.username || '朋友'
const avatarUrl = `https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(realName)}&backgroundColor=e1efe9`
const currentTime = ref(new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }))

// 文章数据
interface Article {
  id: number;
  title: string;
  summary: string;
  cover: string;
  content: string;
}

const articles = ref<Article[]>([
  {
    id: 1,
    title: '如何缓解考前焦虑?',
    summary: '面对重要考试时，适度的紧张有助于发挥，但过度焦虑需要调节。本文介绍三种实用的心理调节技巧。',
    cover: 'https://picsum.photos/seed/calm/600/400',
    content: `
      <p>面对重要考试或评估时，感到紧张是完全正常的生理反应。适度的压力甚至能帮助我们集中注意力。</p>
      <p><strong>1. 接纳焦虑情绪</strong><br/>不要试图强行压抑焦虑，而是告诉自己：“我现在有点紧张，这代表我很看重这次机会。”这种认知重评能有效降低心理负担。</p>
      <p><strong>2. 身体扫描法</strong><br/>闭上眼睛，从脚趾开始，慢慢向上感受身体的每一个部位。如果发现哪里紧绷（通常是肩膀或下巴），试着在呼气时放松它。</p>
      <p><strong>3. 积极的自我暗示</strong><br/>将“我可能会失败”的想法替换为“我已经做了充分的准备，我只需要展示我知道的东西”。</p>
    `
  },
  {
    id: 2,
    title: '深呼吸练习指南',
    summary: '通过简单的 4-7-8 呼吸法，要在三分钟内快速找回平静的自我，重获掌控感。',
    cover: 'https://picsum.photos/seed/nature/600/400',
    content: `
      <p>呼吸是我们情绪的遥控器。当感到焦虑或恐慌时，我们的呼吸往往变得急促浅短。</p>
      <p><strong>4-7-8 呼吸法步骤：</strong></p>
      <ul style="list-style-type: disc; padding-left: 20px;">
        <li>用鼻子安静地吸气，在心里默数 <strong>4</strong> 秒。</li>
        <li>屏住呼吸，默数 <strong>7</strong> 秒。</li>
        <li>用嘴巴用力呼气（发出“呼”的声音），默数 <strong>8</strong> 秒。</li>
      </ul>
      <p>重复这个循环 4 次。你会发现心跳逐渐平缓，思维也变得更加清晰。这是启动副交感神经系统的最快方式。</p>
    `
  },
  {
    id: 3,
    title: '接纳不完美的自己',
    summary: '自我关怀的第一步，是停止内心的自我审判，开始拥抱每一个情绪，无论好坏。',
    cover: 'https://picsum.photos/seed/book/600/400',
    content: `
      <p>我们往往对朋友很宽容，对自己却很苛刻。积极心理学研究表明，“自我关怀”比“高自尊”更能带来持久的心理健康。</p>
      <p><strong>拥抱阴影</strong><br/>每个人都有缺点和犯错的时候。试着把那个“做错事的自己”想象成一个小孩，你会责骂他，还是抱抱他？</p>
      <p><strong>记录小确幸</strong><br/>每天睡前，在心里或本子上记录三件今天发生的、让你感到哪怕一丝开心的小事。这能训练大脑捕捉积极信息的能力。</p>
      <p>请记住，你不需要变得完美才值得被爱。</p>
    `
  }
])

const dialogVisible = ref(false)
const currentArticle = ref<Article | null>(null)

function openArticle(article: Article) {
  currentArticle.value = article
  dialogVisible.value = true
}

function startAssessment() {
  router.push('/test')
}

function viewHistory() {
  router.push('/history')
}

function logout() {
  localStorage.clear()
  router.replace('/login')
  ElMessage.success('已安全退出')
}

onMounted(() => {
  if (chartRef.value) {
    const chart = echarts.init(chartRef.value)
    chart.setOption({
      grid: { top: 20, right: 20, bottom: 20, left: 20, containLabel: true },
      xAxis: {
        type: 'category',
        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        axisLine: { show: false }, axisTick: { show: false }, axisLabel: { color: '#A7A7B3' }
      },
      yAxis: {
        type: 'value',
        splitLine: { lineStyle: { type: 'dashed', color: '#EBE6E0' } }, axisLabel: { color: '#A7A7B3' }
      },
      series: [
        {
          data: [20, 25, 22, 30, 28, 35, 32],
          type: 'line', smooth: true, symbol: 'circle', symbolSize: 8,
          itemStyle: { color: '#6B9080', borderColor: '#fff', borderWidth: 2 },
          lineStyle: { color: '#6B9080', width: 4, shadowColor: 'rgba(107, 144, 128, 0.3)', shadowBlur: 10 },
          areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [{ offset: 0, color: 'rgba(107, 144, 128, 0.4)' }, { offset: 1, color: 'rgba(107, 144, 128, 0)' }]) }
        }
      ]
    })
    window.addEventListener('resize', () => chart.resize())
  }
})
</script>

<style scoped>
/* CSS Patch for Morning Healing Theme */
.bg-cream-100 { background-color: #F6F4F1 !important; }
.bg-cream-200 { background-color: #EBE6E0 !important; }
.bg-cream-300 { background-color: #D8D3CD !important; }
.bg-cream-50 { background-color: #FBF9F7 !important; }

.text-rock-800 { color: #4A4E69 !important; }
.text-rock-600 { color: #7B7B8D !important; }
.text-rock-500 { color: #8F91A3 !important; }
.text-rock-400 { color: #A7A7B3 !important; }

.bg-healing-50 { background-color: #F0F7F4 !important; }
.bg-healing-500 { background-color: #6B9080 !important; }
.bg-healing-600 { background-color: #557366 !important; }

.text-healing-600 { color: #557366 !important; }
.border-healing-200 { border-color: #C2DFCE !important; }
.border-cream-200 { border-color: #EBE6E0 !important; }

.fade-up { animation: fadeUp 0.8s ease-out both; }

@keyframes fadeUp { 
  from { opacity: 0; transform: translateY(20px); } 
  to { opacity: 1; transform: translateY(0); } 
}

.cta-button {
  background: linear-gradient(135deg, #6B9080 0%, #557366 100%);
  box-shadow: 0 10px 30px -5px rgba(107, 144, 128, 0.4);
}
.cta-button:hover {
  box-shadow: 0 20px 40px -5px rgba(107, 144, 128, 0.5);
}

/* Dialog Styles */
:deep(.healing-dialog) {
  border-radius: 2rem !important;
  background-color: #FBF9F7 !important; /* cream-50 */
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15) !important;
}
:deep(.el-dialog__header) {
  display: none !important;
}
:deep(.el-dialog__body) {
  padding: 0 !important;
}
</style>
