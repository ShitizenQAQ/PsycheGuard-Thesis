<template>
  <div class="min-h-screen bg-cream-100 font-sans pb-20">
    <!-- 顶部导航栏 -->
    <div class="bg-white/90 backdrop-blur-xl sticky top-0 z-50 border-b border-cream-200 px-6 py-4 flex justify-between items-center shadow-sm transition-all duration-300">
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[#6B9080] to-[#557366] flex items-center justify-center text-white font-bold shadow-lg shadow-[#6B9080]/30">PG</div>
        <span class="text-rock-800 font-bold text-lg tracking-tight">PsycheGuard</span>
      </div>
      <div class="flex items-center gap-4">
        <span class="text-rock-500 text-sm hidden md:block font-medium tracking-wide">{{ currentTime }}</span>
        <div class="h-6 w-[1px] bg-cream-300 mx-1 hidden md:block"></div>
        
        <!-- 个人中心入口 (已恢复) -->
        <button 
          @click="openProfileDialog" 
          class="w-10 h-10 rounded-2xl overflow-hidden border-2 border-white shadow-sm hover:border-healing-400 hover:shadow-md transition-all cursor-pointer group"
          title="个人中心"
        >
          <img :src="avatarUrl" class="w-full h-full object-cover group-hover:scale-110 transition-transform" alt="Avatar"/>
        </button>

        <button @click="logout" class="text-rock-400 hover:text-rock-800 transition-colors text-sm font-bold flex items-center gap-2 px-3 py-1.5 rounded-lg hover:bg-cream-100">
          <span>退出</span>
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
        </button>
      </div>
    </div>

    <div class="max-w-5xl mx-auto px-6 pt-10 space-y-16 fade-up">
      
      <!-- 头部欢迎区 -->
      <div class="relative">
        <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-8">
          <div class="flex items-center gap-6">
            <div class="relative group">
              <img :src="avatarUrl" class="w-24 h-24 rounded-[2.5rem] border-4 border-white shadow-2xl bg-healing-50 transition-transform duration-500 group-hover:rotate-3" alt="Avatar"/>
              <div class="absolute -bottom-1 -right-1 w-7 h-7 bg-healing-500 rounded-full border-4 border-white flex items-center justify-center">
                <div class="w-2 h-2 bg-white rounded-full animate-pulse"></div>
              </div>
            </div>
            <div>
              <h1 class="text-4xl font-black text-rock-800 mb-2 tracking-tight">
                早安，{{ realName }}
                <span v-if="needsNicknameSetup" @click="openProfileDialog" class="inline-flex items-center gap-1 ml-2 text-sm font-medium text-healing-500 cursor-pointer hover:text-healing-600 transition-colors bg-healing-50 px-2 py-0.5 rounded-full" title="点击设置您的昵称">
                  ✏️ 设置昵称
                </span>
              </h1>
              <div class="flex items-center gap-2 text-rock-500 font-medium bg-white/60 px-3 py-1 rounded-full w-fit backdrop-blur-sm border border-white/50">
                <span>✨</span>
                <span>{{ needsNicknameSetup ? '点击右侧设置您的专属昵称~' : '愿你今天拥有好心情' }}</span>
              </div>
            </div>
          </div>
          
          <div class="flex flex-col sm:flex-row gap-4 w-full md:w-auto">
             <button 
              @click="viewHistory"
              class="group relative overflow-hidden bg-white text-rock-600 px-6 py-4 rounded-[1.5rem] shadow-sm border border-cream-200 hover:border-healing-200 hover:shadow-xl hover:shadow-healing-500/10 transition-all duration-300 w-full sm:w-auto flex items-center gap-4"
            >
               <div class="w-12 h-12 bg-cream-50 rounded-2xl flex items-center justify-center text-rock-400 group-hover:text-[#557366] group-hover:bg-healing-50 transition-colors">
                 <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path></svg>
               </div>
               <div class="text-left">
                 <span class="text-[10px] opacity-50 uppercase tracking-widest font-black block mb-0.5 text-rock-400">History</span>
                 <span class="font-bold text-rock-700 text-lg">历史记录</span>
               </div>
            </button>

            <button 
              @click="startAssessment"
              class="cta-button group relative overflow-hidden text-white px-8 py-4 rounded-[1.5rem] shadow-xl hover:-translate-y-1 transition-all duration-300 w-full sm:w-auto text-left"
            >
              <div class="absolute inset-0 bg-gradient-to-r from-white/0 via-white/20 to-white/0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700"></div>
              <div class="relative z-10 flex items-center justify-between gap-8">
                <div class="flex flex-col">
                  <span class="text-[10px] opacity-80 uppercase tracking-widest font-black mb-1">New Task</span>
                  <span class="text-xl font-bold whitespace-nowrap">开始今日测评</span>
                </div>
                <div class="w-12 h-12 bg-white/20 rounded-2xl flex items-center justify-center backdrop-blur-sm group-hover:bg-white group-hover:text-[#557366] transition-all duration-300">
                  <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                </div>
              </div>
            </button>
          </div>
        </div>
      </div>

      <!-- 情绪趋势图表 -->
      <div class="bg-white/80 backdrop-blur-xl rounded-[2.5rem] p-8 shadow-sm border border-white/60 relative overflow-hidden group hover:shadow-md transition-shadow duration-500">
         <div class="flex justify-between items-start mb-8 relative z-10">
           <div>
             <h2 class="text-xl font-bold text-rock-800 flex items-center gap-2">
                <span>📊</span> 我的情绪变化趋势
             </h2>
             <p class="text-rock-400 text-xs mt-2 ml-1 font-medium tracking-wide">Emotional Trends (Last 7 Days)</p>
           </div>
           <div class="px-3 py-1 bg-healing-50 rounded-lg border border-healing-100 text-xs font-bold text-healing-600">
             状态平稳
           </div>
         </div>
         <div ref="chartRef" class="w-full h-72 relative z-10"></div>
         
         <div class="absolute top-0 right-0 w-96 h-96 bg-gradient-to-br from-healing-50 to-transparent rounded-full blur-3xl opacity-60 pointer-events-none -translate-y-1/2 translate-x-1/3"></div>
      </div>

      <!-- 舒缓阅读区 -->
      <div id="reading-corner" class="pb-10">
        <div class="flex items-center justify-between mb-8 px-2">
          <h2 class="text-2xl font-bold text-rock-800 flex items-center gap-3">
            <span class="text-3xl">🌿</span>
            <span>舒缓阅读区</span>
          </h2>
          <span class="text-xs font-bold text-rock-400 bg-white px-3 py-1 rounded-full border border-cream-200">Daily Wisdom</span>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div 
            v-for="article in articles" 
            :key="article.id"
            class="group bg-white rounded-[2rem] p-3 border border-white/60 shadow-sm hover:shadow-xl hover:shadow-healing-500/10 hover:-translate-y-1 transition-all duration-500 cursor-pointer flex flex-col h-full" 
            @click="openArticle(article)"
          >
            <div 
              class="h-48 w-full rounded-[1.5rem] mb-5 overflow-hidden relative"
              :class="article.bgClass"
            >
               <div class="absolute top-4 right-4 w-10 h-10 bg-white/20 backdrop-blur-md rounded-full flex items-center justify-center text-white border border-white/30">
                 <span class="text-lg">{{ article.icon }}</span>
               </div>
               <div class="absolute bottom-0 left-0 w-full p-6 text-white">
                 <h3 class="font-bold text-xl leading-tight drop-shadow-md group-hover:scale-105 transition-transform origin-bottom-left duration-500">{{ article.title }}</h3>
               </div>
            </div>
            
            <div class="px-3 pb-4 flex-1 flex flex-col justify-between">
              <p class="text-rock-500 text-sm leading-relaxed line-clamp-3 mb-4 font-medium">{{ article.summary }}</p>
              <div class="flex items-center gap-2 text-xs font-bold text-healing-600 group-hover:underline decoration-2 underline-offset-4 decoration-healing-300">
                <span>阅读全文</span>
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path></svg>
              </div>
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
      class="healing-dialog !rounded-[2.5rem] overflow-hidden !p-0 !bg-white !shadow-2xl"
    >
      <div v-if="currentArticle" class="relative bg-white min-h-[500px] flex flex-col">
        <div class="relative h-40 w-full flex-shrink-0" :class="currentArticle.bgClass">
           <div class="absolute top-0 w-full flex justify-between items-center p-6 text-white/90">
              <span class="text-xs font-bold bg-white/20 backdrop-blur-md px-3 py-1 rounded-full border border-white/20">Mindfulness</span>
              <button @click="dialogVisible = false" class="w-8 h-8 rounded-full bg-black/10 backdrop-blur-md flex items-center justify-center hover:bg-black/20 transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
              </button>
           </div>
           
           <div class="absolute -bottom-8 left-8 w-20 h-20 rounded-[1.5rem] bg-white shadow-xl flex items-center justify-center text-4xl border-4 border-white">
              {{ currentArticle.icon }}
           </div>
        </div>

        <div class="px-8 pt-12 pb-10 flex-1 overflow-y-auto max-h-[60vh] custom-scrollbar">
          <h2 class="text-2xl font-black text-rock-800 mb-6 leading-tight">{{ currentArticle.title }}</h2>
          
          <div class="prose prose-stone text-rock-600 leading-loose space-y-6 text-justify">
             <div v-html="currentArticle.content"></div>
          </div>
          
          <div class="mt-10 pt-6 border-t border-cream-200 text-center">
             <p class="text-xs font-bold text-healing-500 uppercase tracking-widest">PsycheGuard · Caring for you</p>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 个人中心对话框 (已恢复) -->
    <el-dialog
      v-model="profileDialogVisible"
      title="个人中心"
      width="480px"
      align-center
      destroy-on-close
      class="profile-dialog !rounded-[2rem]"
    >
      <el-tabs v-model="activeProfileTab" class="profile-tabs">
        <el-tab-pane label="基本信息" name="info">
          <div class="flex flex-col items-center py-6">
            <div class="relative mb-6">
              <img :src="avatarUrl" class="w-24 h-24 rounded-full border-4 border-healing-100 shadow-lg" alt="Avatar"/>
              <div class="absolute bottom-0 right-0 w-8 h-8 bg-healing-500 rounded-full border-2 border-white flex items-center justify-center text-white text-xs">✓</div>
            </div>
            
            <div class="w-full max-w-xs space-y-4">
              <div>
                <label class="text-sm font-bold text-rock-600 mb-2 block font-sans">账号</label>
                <el-input :model-value="user.username" disabled class="!rounded-xl" />
              </div>
              <div>
                <label class="text-sm font-bold text-rock-600 mb-2 block font-sans">真实姓名 / 昵称</label>
                <el-input v-model="profileForm.realName" placeholder="请输入您的昵称" class="!rounded-xl" />
              </div>
              <el-button 
                type="primary" 
                class="w-full !rounded-xl !bg-healing-500 !border-healing-500 hover:!bg-healing-600 mt-4 !h-11 font-bold shadow-lg shadow-healing-500/20"
                @click="saveProfile"
                :loading="profileSaving"
              >
                保存修改
              </el-button>
            </div>
          </div>
        </el-tab-pane>

        <el-tab-pane label="安全设置" name="security">
          <div class="py-6 px-4">
            <h3 class="text-lg font-bold text-rock-800 mb-6 flex items-center gap-2">
              <span>🔐</span> 修改密码
            </h3>
            <div class="space-y-4">
              <div>
                <label class="text-sm font-bold text-rock-600 mb-2 block font-sans">旧密码</label>
                <el-input v-model="passwordForm.oldPassword" type="password" show-password placeholder="请输入当前密码" class="!rounded-xl" />
              </div>
              <div>
                <label class="text-sm font-bold text-rock-600 mb-2 block font-sans">新密码</label>
                <el-input v-model="passwordForm.newPassword" type="password" show-password placeholder="至少6位" class="!rounded-xl" />
              </div>
              <div>
                <label class="text-sm font-bold text-rock-600 mb-2 block font-sans">确认新密码</label>
                <el-input v-model="passwordForm.confirmPassword" type="password" show-password placeholder="再次输入新密码" class="!rounded-xl" />
              </div>
              <el-button 
                type="primary" 
                class="w-full !rounded-xl !bg-healing-500 !border-healing-500 hover:!bg-healing-600 mt-4 !h-11 font-bold shadow-lg shadow-healing-500/20"
                @click="changePassword"
                :loading="passwordSaving"
              >
                确认修改
              </el-button>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const router = useRouter()
const chartRef = ref<HTMLDivElement | null>(null)

// 模拟用户信息
const user = JSON.parse(localStorage.getItem('pg_user') || '{}')
const rawName = user.realName || user.username || '朋友'

// 智能显示名称：如果是 Case-xxxx 或 visitor_xx 编号，显示温暖代称
const displayName = computed(() => {
  if (rawName.startsWith('Case-') || rawName.startsWith('visitor')) {
    return '新朋友'
  }
  return rawName
})

// 是否需要引导修改昵称（编号用户需要引导）
const needsNicknameSetup = computed(() => rawName.startsWith('Case-') || rawName.startsWith('visitor'))

// 兼容旧代码，realName 现在指向 displayName
const realName = displayName

const avatarUrl = `https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(rawName)}&backgroundColor=e1efe9`
const currentTime = ref(new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }))

// --- 文章数据 (使用 CSS 渐变代替图片) ---
interface Article {
  id: number;
  title: string;
  summary: string;
  bgClass: string; // CSS Gradient Class
  icon: string;    // Emoji Icon
  content: string;
}

const articles = ref<Article[]>([
  {
    id: 1,
    title: '如何缓解考前焦虑?',
    summary: '面对重要考试时，适度的紧张有助于发挥，但过度焦虑需要调节。本文介绍三种实用的心理调节技巧。',
    bgClass: 'bg-gradient-to-br from-[#8CAE9D] to-[#557366]',
    icon: '📚',
    content: `
      <p>面对重要考试或评估时，感到紧张是完全正常的生理反应。适度的压力甚至能帮助我们集中注意力。</p>
      <div class="bg-healing-50 border-l-4 border-healing-500 p-4 rounded-r-xl my-4">
        <strong class="text-healing-700 block mb-1 font-bold">1. 接纳焦虑情绪</strong>
        <span class="text-sm italic">不要试图强行压抑焦虑，而是告诉自己：“我现在有点紧张，这代表我很看重这次机会。”这种认知重评能有效降低心理负担。</span>
      </div>
      <p><strong>2. 身体扫描法</strong><br/>闭上眼睛，从脚趾开始，慢慢向上感受身体的每一个部位。如果发现哪里紧绷（通常是肩膀或下巴），试着在呼气时放松它。</p>
      <p><strong>3. 积极的自我暗示</strong><br/>将“我可能会失败”的想法替换为“我已经做了充分的准备，我只需要展示我知道的东西”。</p>
    `
  },
  {
    id: 2,
    title: '深呼吸练习指南',
    summary: '通过简单的 4-7-8 呼吸法，要在三分钟内快速找回平静的自我，重获掌控感。',
    bgClass: 'bg-gradient-to-br from-[#E07A5F] to-[#7A3525]',
    icon: '🧘',
    content: `
      <p>呼吸是我们情绪的遥控器。当感到焦虑或恐慌时，我们的呼吸往往变得急促浅短。</p>
      <div class="bg-cream-100 p-6 rounded-2xl border border-cream-200 text-center my-4">
         <h4 class="font-bold text-rock-800 mb-4">💨 4-7-8 呼吸法</h4>
         <div class="flex justify-around items-center text-sm font-bold text-rock-500">
            <div>吸气<br/><span class="text-2xl text-healing-500">4s</span></div>
            <div>→</div>
            <div>屏息<br/><span class="text-2xl text-clay-500">7s</span></div>
            <div>→</div>
            <div>呼气<br/><span class="text-2xl text-rock-600">8s</span></div>
         </div>
      </div>
      <p>重复这个循环 4 次。你会发现心跳逐渐平缓，思维也变得更加清晰。这是启动副交感神经系统的最快方式。</p>
    `
  },
  {
    id: 3,
    title: '接纳不完美的自己',
    summary: '自我关怀的第一步，是停止内心的自我审判，开始拥抱每一个情绪，无论好坏。',
    bgClass: 'bg-gradient-to-br from-indigo-400 to-purple-500',
    icon: '❤️',
    content: `
      <p>我们往往对朋友很宽容，对自己却很苛刻。积极心理学研究表明，“自我关怀”比“高自尊”更能带来持久的心理健康。</p>
      <p><strong>拥抱阴影</strong><br/>每个人都有缺点和犯错的时候。试着把那个“做错事的自己”想象成一个小孩，你会责骂他，还是抱抱他？</p>
      <p><strong>记录小确幸</strong><br/>每天睡前，在心里或本子上记录三件今天发生的、让你感到哪怕一丝开心的小事。这能训练大脑捕捉积极信息的能力。</p>
      <p class="text-healing-600 font-black mt-4">请记住，你不需要变得完美才值得被爱。</p>
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

// === 个人中心逻辑 (已恢复) ===
const profileDialogVisible = ref(false)
const activeProfileTab = ref('info')
const profileSaving = ref(false)
const passwordSaving = ref(false)

const profileForm = reactive({
  realName: user.realName || ''
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

function openProfileDialog() {
  profileForm.realName = user.realName || ''
  passwordForm.oldPassword = ''
  passwordForm.newPassword = ''
  passwordForm.confirmPassword = ''
  activeProfileTab.value = 'info'
  profileDialogVisible.value = true
}

async function saveProfile() {
  if (!profileForm.realName.trim()) {
    ElMessage.warning('请输入昵称')
    return
  }
  profileSaving.value = true
  try {
    const { data } = await axios.put('/api/users/me', { realName: profileForm.realName })
    user.realName = data.realName
    localStorage.setItem('pg_user', JSON.stringify(user))
    // 注意：realName 是 computed 属性，会在页面刷新后自动更新
    ElMessage.success('个人信息已更新')
    profileDialogVisible.value = false
  } catch (e: any) {
    ElMessage.error(e.response?.data?.message || '保存失败')
  } finally {
    profileSaving.value = false
  }
}

async function changePassword() {
  if (!passwordForm.oldPassword) {
    ElMessage.warning('请输入旧密码')
    return
  }
  if (!passwordForm.newPassword || passwordForm.newPassword.length < 6) {
    ElMessage.warning('新密码至少需要6位')
    return
  }
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    ElMessage.warning('两次输入的新密码不一致')
    return
  }
  passwordSaving.value = true
  try {
    await axios.post('/api/users/me/password', {
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })
    ElMessage.success('密码修改成功')
    profileDialogVisible.value = false
  } catch (e: any) {
    ElMessage.error(e.response?.data?.message || '密码修改失败')
  } finally {
    passwordSaving.value = false
  }
}

onMounted(() => {
  if (chartRef.value) {
    const chart = echarts.init(chartRef.value)
    chart.setOption({
      grid: { top: 20, right: 20, bottom: 20, left: 30, containLabel: true },
      tooltip: {
        trigger: 'axis',
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#EBE6E0',
        textStyle: { color: '#4A4E69', fontWeight: 'bold' }
      },
      xAxis: {
        type: 'category',
        data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
        axisLine: { show: false }, 
        axisTick: { show: false }, 
        axisLabel: { color: '#A7A7B3', fontSize: 12, fontWeight: 'bold' }
      },
      yAxis: {
        type: 'value',
        splitLine: { lineStyle: { type: 'dashed', color: '#F0F0F0' } }, 
        axisLabel: { color: '#A7A7B3' }
      },
      series: [
        {
          name: 'Mood',
          data: [65, 72, 68, 85, 82, 90, 88], 
          type: 'line', 
          smooth: true, 
          symbol: 'none',
          lineStyle: { width: 5, color: '#6B9080', cap: 'round' },
          areaStyle: { 
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(107, 144, 128, 0.2)' }, 
              { offset: 1, color: 'rgba(107, 144, 128, 0)' }
            ]) 
          }
        }
      ]
    })
    window.addEventListener('resize', () => chart.resize())
  }
})
</script>

<style scoped>
/* === 色彩系统补丁 === */
.bg-cream-100 { background-color: #F9F7F5 !important; }
.bg-cream-50 { background-color: #FCFBFA !important; }
.bg-cream-300 { background-color: #E6E2DE !important; }

.text-rock-800 { color: #2D2D3F !important; }
.text-rock-700 { color: #4A4E69 !important; }
.text-rock-600 { color: #6C6F85 !important; }
.text-rock-500 { color: #9A9CAD !important; }
.text-rock-400 { color: #BCC0CC !important; }

.bg-healing-500 { background-color: #6B9080 !important; }
.bg-healing-600 { background-color: #557366 !important; }
.bg-healing-50 { background-color: #F0F7F4 !important; }
.text-healing-600 { color: #557366 !important; }
.text-healing-500 { color: #6B9080 !important; }
.text-clay-500 { color: #E07A5F !important; }
.text-healing-700 { color: #3A4D45 !important; }
.border-healing-500 { border-color: #6B9080 !important; }
.border-healing-200 { border-color: #C2DFCE !important; }

.cta-button {
  background: linear-gradient(135deg, #6B9080 0%, #4A6F62 100%);
}

.fade-up { animation: fadeUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) both; }
@keyframes fadeUp { 
  from { opacity: 0; transform: translateY(20px); } 
  to { opacity: 1; transform: translateY(0); } 
}

/* 滚动条美化 */
.custom-scrollbar::-webkit-scrollbar { width: 6px; }
.custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
.custom-scrollbar::-webkit-scrollbar-thumb { background-color: #EBE6E0; border-radius: 20px; }
.custom-scrollbar::-webkit-scrollbar-thumb:hover { background-color: #C2DFCE; }

/* 对话框圆角 */
:deep(.el-dialog) {
  border-radius: 2.5rem !important;
}
:deep(.el-tabs__item.is-active) {
  color: #6B9080 !important;
  font-weight: bold;
}
:deep(.el-tabs__active-bar) {
  background-color: #6B9080 !important;
}
:deep(.el-input__inner) {
  font-family: inherit;
}
</style>
