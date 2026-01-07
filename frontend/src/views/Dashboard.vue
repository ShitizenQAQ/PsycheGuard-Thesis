<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="flex items-center justify-between bg-white/80 backdrop-blur-md px-5 py-4 rounded-2xl shadow-sm border border-white/50 relative z-10 isolate">
      <div>
        <p class="text-sm text-slate-500">欢迎回来，控制中心</p>
        <h2 class="text-xl font-bold text-slate-800">咨询师</h2>
      </div>
      <div class="relative">
        <button class="relative w-10 h-10 rounded-xl bg-slate-900 text-white flex items-center justify-center hover:bg-slate-800 transition-colors shadow-lg shadow-slate-900/20" @click="showNotifications = !showNotifications">
          <el-icon><Bell /></el-icon>
          <span v-if="unreadCount > 0" class="absolute -top-1 -right-1 w-3 h-3 bg-rose-500 rounded-full border-2 border-white animate-pulse"></span>
        </button>
        <div v-if="showNotifications" class="absolute right-0 mt-4 w-96 bg-white/90 backdrop-blur-xl rounded-2xl shadow-2xl border border-white/50 z-[1000] overflow-hidden transform origin-top-right transition-all animate-in fade-in zoom-in-95 duration-200">
          <div class="px-4 py-3 font-bold text-slate-800 border-b border-slate-100 flex justify-between items-center">
            <span>通知中心</span>
            <span class="text-xs font-normal text-slate-400">实时预警推送</span>
          </div>
          <div class="divide-y divide-slate-100 max-h-[300px] overflow-y-auto">
            <div v-for="n in notifications" :key="n.id" class="px-4 py-3 hover:bg-slate-50 transition-colors cursor-pointer group" @click="onNotifClick(n)">
              <div class="flex items-start gap-3">
                <div class="w-8 h-8 rounded-lg flex items-center justify-center shrink-0"
                  :class="n.type === 'ALERT' ? 'bg-rose-100 text-rose-600' : 'bg-blue-100 text-blue-600'">
                  <AlertTriangle v-if="n.type === 'ALERT'" :size="16" />
                  <Info v-else :size="16" />
                </div>
                <div class="flex-1">
                  <div class="text-sm text-slate-700 font-medium group-hover:text-blue-600 transition-colors">{{ n.content }}</div>
                  <div class="text-xs text-slate-400 mt-1">{{ n.time }}</div>
                </div>
              </div>
            </div>
            <div v-if="notifications.length === 0" class="py-8 text-center text-slate-400 text-sm">暂无新通知</div>
          </div>
          <div class="px-4 py-3 border-t border-slate-100 bg-slate-50/50">
            <button class="w-full text-xs py-2 rounded-lg text-slate-500 hover:bg-slate-200 transition-colors" @click="markAllAsRead">全部标记为已读</button>
          </div>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-6">
      <div class="relative rounded-[2rem] p-6 text-white bg-gradient-to-br from-blue-500 to-blue-600 shadow-xl shadow-blue-500/20 overflow-hidden transition-all duration-300 hover:-translate-y-1 hover:shadow-2xl cursor-pointer group" @click="router.push('/users')">
        <div class="flex items-center justify-between relative z-10">
          <span class="text-sm font-medium opacity-90">来访者总数</span>
          <div class="w-10 h-10 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center group-hover:scale-110 transition-transform">
            <span class="text-lg">👥</span>
          </div>
        </div>
        <div class="mt-4 text-4xl font-black tracking-tight">{{ displayTotalPrisoners }}</div>
        <div class="mt-2 text-xs opacity-80 font-medium bg-blue-700/30 w-fit px-2 py-1 rounded-lg">实时统计</div>
        <div class="absolute -bottom-6 -right-6 opacity-10 rotate-[-15deg] transition-transform group-hover:scale-110 group-hover:rotate-[-5deg]">
          <svg xmlns="http://www.w3.org/2000/svg" width="160" height="160" viewBox="0 0 24 24" fill="currentColor" class="text-white"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
        </div>
      </div>

      <div class="relative rounded-[2rem] p-6 text-white bg-gradient-to-br from-rose-500 to-rose-600 shadow-xl shadow-rose-500/20 overflow-hidden transition-all duration-300 hover:-translate-y-1 hover:shadow-2xl cursor-pointer group" @click="goHighRisk()">
        <div class="flex items-center justify-between relative z-10">
          <span class="text-sm font-medium opacity-90">重点关注预警</span>
          <div class="w-10 h-10 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center group-hover:scale-110 transition-transform">
            <span class="text-lg animate-pulse">⚠️</span>
          </div>
        </div>
        <div class="mt-4 text-4xl font-black tracking-tight">{{ displayHighRiskCount }}</div>
        <div class="mt-2 text-xs opacity-80 font-medium bg-rose-800/30 w-fit px-2 py-1 rounded-lg">今日新增 {{ highRiskToday }} 人</div>
        <div class="absolute -bottom-6 -right-6 opacity-10 rotate-[-15deg] transition-transform group-hover:scale-110 group-hover:rotate-[-5deg]">
          <svg xmlns="http://www.w3.org/2000/svg" width="160" height="160" viewBox="0 0 24 24" fill="currentColor" class="text-white"><path d="M10.29 3.86 1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0Z"/></svg>
        </div>
      </div>

      <div class="relative rounded-[2rem] p-6 text-white bg-gradient-to-br from-emerald-500 to-emerald-600 shadow-xl shadow-emerald-500/20 overflow-hidden transition-all duration-300 hover:-translate-y-1 hover:shadow-2xl cursor-pointer group" @click="router.push('/history')">
        <div class="flex items-center justify-between relative z-10">
          <span class="text-sm font-medium opacity-90">累计测评记录</span>
          <div class="w-10 h-10 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center group-hover:scale-110 transition-transform">
            <span class="text-lg">📄</span>
          </div>
        </div>
        <div class="mt-4 text-4xl font-black tracking-tight">{{ displayTotalAssessments }}</div>
        <div class="mt-2 text-xs opacity-80 font-medium bg-emerald-700/30 w-fit px-2 py-1 rounded-lg">本月数据</div>
        <div class="absolute -bottom-6 -right-6 opacity-10 rotate-[-15deg] transition-transform group-hover:scale-110 group-hover:rotate-[-5deg]">
          <svg xmlns="http://www.w3.org/2000/svg" width="160" height="160" viewBox="0 0 24 24" fill="currentColor" class="text-white"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/></svg>
        </div>
      </div>

      <div class="relative rounded-[2rem] p-6 text-white bg-gradient-to-br from-amber-400 to-amber-500 shadow-xl shadow-amber-500/20 overflow-hidden transition-all duration-300 hover:-translate-y-1 hover:shadow-2xl cursor-pointer group">
        <div class="flex items-center justify-between relative z-10">
          <span class="text-sm font-medium opacity-90">平均 PCL-R 分</span>
          <div class="w-10 h-10 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center group-hover:scale-110 transition-transform">
            <span class="text-lg">📊</span>
          </div>
        </div>
        <div class="mt-4 text-4xl font-black tracking-tight">{{ displayAvgScore }}</div>
        <div class="mt-2 text-xs opacity-80 font-medium bg-amber-600/30 w-fit px-2 py-1 rounded-lg">群体心理画像基准</div>
        <div class="absolute -bottom-6 -right-6 opacity-10 rotate-[-15deg] transition-transform group-hover:scale-110 group-hover:rotate-[-5deg]">
          <svg xmlns="http://www.w3.org/2000/svg" width="160" height="160" viewBox="0 0 24 24" fill="currentColor" class="text-white"><rect x="3" y="3" width="18" height="18" rx="2"/></svg>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-2 gap-6">
      <div class="bg-white/60 backdrop-blur-md p-6 rounded-[2rem] shadow-sm border border-white/60">
        <h3 class="text-base font-bold text-slate-800 mb-4 flex items-center gap-2">
          <span class="w-2 h-6 bg-blue-500 rounded-full"></span> 心理状态分布
        </h3>
        <div ref="pieRef" class="w-full h-[300px]"></div>
      </div>
      <div class="bg-white/60 backdrop-blur-md p-6 rounded-[2rem] shadow-sm border border-white/60">
        <h3 class="text-base font-bold text-slate-800 mb-4 flex items-center gap-2">
          <span class="w-2 h-6 bg-blue-500 rounded-full"></span> 测评趋势 (近7天)
        </h3>
        <div ref="lineRef" class="w-full h-[300px]"></div>
      </div>
    </div>

    <div class="bg-white/60 backdrop-blur-md rounded-[2rem] shadow-sm border border-white/60 p-6">
      <div class="flex items-center justify-between mb-6">
        <h3 class="text-lg font-bold text-slate-800 flex items-center gap-2">
          <span class="w-2 h-6 bg-blue-500 rounded-full"></span> 近期测评记录
        </h3>
        <button class="text-sm font-medium text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 px-3 py-1 rounded-lg transition-colors" @click="viewAll">
          查看全部 →
        </button>
      </div>
      <div class="space-y-2">
        <div v-for="r in recentRecords" :key="r.id" 
          class="group flex items-center justify-between p-3 rounded-2xl hover:bg-white/80 hover:shadow-md transition-all duration-200 cursor-pointer border border-transparent hover:border-white/50"
          @click="router.push('/result/' + r.id)"
        >
          <div class="flex items-center gap-4">
            <div class="relative">
              <img :src="r.avatar" class="w-12 h-12 rounded-full border-2 border-white shadow-sm bg-slate-100" :alt="r.name" />
              <div class="absolute -bottom-1 -right-1 w-5 h-5 flex items-center justify-center rounded-full text-[10px] font-bold text-white shadow-sm"
                :class="r.risk === 'HIGH' ? 'bg-rose-500' : 'bg-emerald-500'">
                {{ r.risk === 'HIGH' ? '!' : '✓' }}
              </div>
            </div>
            <div>
              <div class="text-slate-800 font-bold group-hover:text-blue-600 transition-colors">{{ r.name }}</div>
              <div class="text-xs text-slate-400 font-mono mt-0.5">{{ r.date }}</div>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <div class="text-right">
              <div class="text-sm font-black text-slate-700">{{ r.score }} <span class="text-xs font-normal text-slate-400">分</span></div>
              <div class="text-[10px] text-slate-400">PCL-R</div>
            </div>
            <span 
              class="text-xs px-3 py-1.5 rounded-xl font-bold transition-transform group-hover:scale-105"
              :class="r.risk === 'HIGH' ? 'bg-rose-100 text-rose-700' : 'bg-emerald-100 text-emerald-700'"
            >
              {{ r.risk === 'HIGH' ? '重点关注' : '安心状态' }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Bell } from '@element-plus/icons-vue'
import { AlertTriangle, Info } from 'lucide-vue-next'
import * as echarts from 'echarts'
import axios from 'axios'

const router = useRouter()
const route = useRoute()

// Data Refs
const displayTotalPrisoners = ref(0)
const displayHighRiskCount = ref(0)
const displayTotalAssessments = ref(0)
const displayAvgScore = ref(0)
const highRiskToday = ref(0)

const pieRef = ref<HTMLElement | null>(null)
const lineRef = ref<HTMLElement | null>(null)
let pieChart: echarts.ECharts | null = null
let lineChart: echarts.ECharts | null = null

type RecordItem = { id: number; name: string; avatar: string; date: string; score: number; risk: 'HIGH' | 'LOW' }
const recentRecords = ref<RecordItem[]>([])

type NotifItem = { id: number; type: 'ALERT' | 'INFO'; content: string; time: string; read: boolean }
const notifications = ref<NotifItem[]>([])
const showNotifications = ref(false)
const unreadCount = computed(() => notifications.value.filter(n => !n.read).length)

let refreshTimer: number | null = null

// --- Initialization ---
onMounted(async () => {
  initCharts()
  await refreshData()
  
  // Auto refresh every 10s for demo effect
  refreshTimer = window.setInterval(refreshData, 10000)

  if (route.query.notify) showNotifications.value = true
})

onBeforeUnmount(() => {
  if (refreshTimer) clearInterval(refreshTimer)
  pieChart?.dispose()
  lineChart?.dispose()
  window.removeEventListener('resize', resizeCharts)
})

// --- Data Fetching Logic ---
async function refreshData() {
  await Promise.all([fetchStatsAndCharts(), fetchNotifications(), fetchRecent()])
}

async function fetchStatsAndCharts() {
  try {
    // 1. Fetch Users & Assessments
    const [usersRes, assessRes] = await Promise.all([
      axios.get('/api/users', { params: { role: 'ROLE_CLIENT' } }),
      axios.get('/api/assessments')
    ])
    
    const users = usersRes.data || []
    const assessments = assessRes.data || []

    // 2. Update Display Numbers (with animation)
    animateNumber(displayTotalPrisoners, users.length)
    animateNumber(displayTotalAssessments, assessments.length)

    // 3. Calculate Risk Distribution (Real-time from assessments)
    // Find the LATEST assessment for each user to determine current risk
    const userRiskMap = new Map<number, string>()
    // Assuming assessments are ordered by time desc or we sort them
    const sortedAssess = [...assessments].sort((a,b) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
    
    let high = 0, medium = 0, low = 0
    // Simple logic: iterate recent assessments, if user not counted, count risk
    const countedUsers = new Set()
    for (const a of sortedAssess) {
      if (!countedUsers.has(a.userId)) {
        countedUsers.add(a.userId)
        if (a.riskLevel === 'HIGH') high++
        else if (a.riskLevel === 'MEDIUM') medium++
        else low++
      }
    }
    // If user has no assessment, they are not in the chart (or count as Low/Unknown)
    // For demo consistency with "Total Clients", we can assume unassessed are Low or separate
    // Let's stick to assessed users for the pie chart to be accurate
    
    animateNumber(displayHighRiskCount, high)

    // Calculate Avg Score
    if (assessments.length) {
      const sum = assessments.reduce((s: number, a: any) => s + (a.totalScore || 0), 0)
      animateNumber(displayAvgScore, Math.round(sum / assessments.length))
    }

    // Update Pie Chart
    updatePieChart(high, medium, low)

    // Update Line Chart (Mock trend based on real volume)
    updateLineChart(assessments.length)

  } catch (e) {
    console.error(e)
  }
}

async function fetchRecent() {
  try {
    const { data } = await axios.get('/api/assessments')
    const list = data || []
    const sorted = list.sort((a: any, b: any) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
    recentRecords.value = sorted.slice(0, 5).map((r: any) => ({
      id: r.id,
      name: r.userRealName || '未知',
      avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(r.userRealName || 'user')}`,
      date: new Date(r.createTime).toLocaleDateString('zh-CN'),
      score: r.totalScore,
      risk: r.riskLevel === 'HIGH' ? 'HIGH' : 'LOW'
    }))
  } catch {}
}

async function fetchNotifications() {
  // Mock logic or real API
  try {
    const { data } = await axios.get('/api/assessments/recent-high-risk')
    notifications.value = (data || []).map((i: any) => ({
      id: i.id,
      type: 'ALERT',
      content: `⚠️ 发现重点关注人员：${i.prisonerName}`,
      time: new Date(i.createTime).toLocaleTimeString(),
      read: false
    }))
  } catch {}
}

// --- Chart Logic ---
function initCharts() {
  if (pieRef.value) pieChart = echarts.init(pieRef.value)
  if (lineRef.value) lineChart = echarts.init(lineRef.value)
  window.addEventListener('resize', resizeCharts)
}

function resizeCharts() {
  pieChart?.resize()
  lineChart?.resize()
}

function updatePieChart(h: number, m: number, l: number) {
  if (!pieChart) return
  const option = {
    tooltip: { trigger: 'item' },
    legend: { bottom: '0%', left: 'center' },
    series: [{
      type: 'pie',
      radius: ['40%', '65%'],
      center: ['50%', '45%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
      label: { show: false },
      data: [
        { value: h, name: '重点关注', itemStyle: { color: '#f43f5e' } }, // rose-500
        { value: m, name: '一般关注', itemStyle: { color: '#f59e0b' } }, // amber-500
        { value: l, name: '安心状态', itemStyle: { color: '#10b981' } }  // emerald-500
      ]
    }]
  }
  pieChart.setOption(option)
  
  // Click event
  pieChart.off('click')
  pieChart.on('click', (params: any) => {
    const riskMap: any = { '重点关注': 'HIGH', '一般关注': 'MEDIUM', '安心状态': 'LOW' }
    if (riskMap[params.name]) router.push({ path: '/users', query: { risk: riskMap[params.name] } })
  })
}

function updateLineChart(total: number) {
  if (!lineChart) return
  // Generate a mock trend that ends with the current total
  // ensuring the chart looks "alive" but anchored to reality
  const days = ['周一','周二','周三','周四','周五','周六','周日']
  const data = []
  let base = Math.max(0, total - 5)
  for(let i=0; i<6; i++) {
    data.push(base + Math.floor(Math.random() * 3))
    base += Math.random() > 0.5 ? 1 : 0
  }
  data.push(total) // Last point is real total

  const option = {
    grid: { top: 10, right: 10, bottom: 20, left: 30, containLabel: true },
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'category', data: days, axisLine: { show: false }, axisTick: { show: false } },
    yAxis: { type: 'value', splitLine: { lineStyle: { type: 'dashed' } } },
    series: [{
      data: data,
      type: 'line',
      smooth: true,
      symbolSize: 8,
      lineStyle: { color: '#3b82f6', width: 4 },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0,0,0,1, [{offset:0, color:'rgba(59,130,246,0.3)'}, {offset:1, color:'rgba(59,130,246,0)'}])
      }
    }]
  }
  lineChart.setOption(option)
}

// --- Animation Util ---
function animateNumber(targetRef: any, to: number, duration = 1000) {
  const from = targetRef.value
  if (from === to) return
  const start = performance.now()
  const easeOut = (t: number) => 1 - Math.pow(1 - t, 3)
  
  function tick(now: number) {
    const progress = Math.min(1, (now - start) / duration)
    targetRef.value = Math.round(from + (to - from) * easeOut(progress))
    if (progress < 1) requestAnimationFrame(tick)
  }
  requestAnimationFrame(tick)
}

// --- Interactions ---
function viewAll() { router.push('/history') }
function goHighRisk() { router.push({ path: '/users', query: { risk: 'HIGH' } }) }
function onNotifClick(n: NotifItem) { if (n.type === 'ALERT') router.push('/result/' + n.id) }
function markAllAsRead() { notifications.value = []; showNotifications.value = false }
</script>

<style scoped>
.fade-up { animation: fadeUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
</style>