<template>
  <div class="p-4 md:p-6 space-y-6 fade-up bg-cream-100 min-h-screen">
    <!-- Header Section -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white/70 backdrop-blur-xl px-6 py-5 rounded-[2rem] shadow-sm border border-white/60 relative z-10 isolate">
      <div class="flex items-center gap-4">
        <div class="w-14 h-14 rounded-2xl bg-healing-500 text-white flex items-center justify-center shadow-lg shadow-healing-500/20 text-2xl">
          👨‍💼
        </div>
        <div>
          <p class="text-xs text-rock-500 font-bold uppercase tracking-wider mb-0.5">心理健康监测驾驶舱</p>
          <h2 class="text-2xl font-black text-rock-900">咨询师工作台 <span class="text-sm font-medium text-rock-400 ml-2">{{ currentTime }}</span></h2>
        </div>
      </div>
      <div class="flex items-center gap-3">
        <div class="hidden lg:flex items-center gap-2 bg-healing-50 px-4 py-2 rounded-xl border border-healing-100">
          <div class="w-2 h-2 rounded-full bg-healing-500 animate-pulse"></div>
          <span class="text-sm font-bold text-healing-700">系统运行正常</span>
        </div>
      </div>
    </div>

    <!-- 5 Key Metrics Grid -->
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
      <div v-for="m in stats" :key="m.label" 
        class="bg-white/80 backdrop-blur-md p-5 rounded-[1.8rem] border border-white/80 shadow-sm hover:shadow-md hover:-translate-y-1 transition-all duration-300 group cursor-pointer"
        @click="m.path && router.push(m.path)"
      >
        <div class="flex items-center justify-between mb-3">
          <div class="w-10 h-10 rounded-xl bg-healing-50 text-healing-600 flex items-center justify-center group-hover:scale-110 transition-transform shadow-inner text-xl">
            {{ m.icon }}
          </div>
          <span class="text-[10px] font-black px-2 py-0.5 rounded-full" :class="m.trendColor">{{ m.trend }}</span>
        </div>
        <div class="text-2xl font-black text-rock-900 mb-1 flex items-baseline gap-1">
          {{ m.displayValue }}
          <span v-if="m.unit" class="text-xs font-bold text-rock-400">{{ m.unit }}</span>
        </div>
        <p class="text-[11px] font-bold text-rock-400 uppercase tracking-tighter">{{ m.label }}</p>
      </div>
    </div>

    <!-- Charts Row 1: Funnel & Pie -->
    <div class="grid grid-cols-1 xl:grid-cols-3 gap-6">
      <div class="xl:col-span-2 bg-white/60 backdrop-blur-md p-6 rounded-[2.5rem] shadow-sm border border-white/60 hover:shadow-lg transition-all">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-black text-rock-900 flex items-center gap-2">
            <span class="w-2 h-7 bg-healing-500 rounded-full"></span> 
            干预转化效能监控 (Intervention Funnel)
          </h3>
          <div class="flex gap-2">
            <span class="px-2 py-1 bg-healing-50 text-healing-600 text-[10px] font-bold rounded-lg border border-healing-100">工作闭环分析</span>
          </div>
        </div>
        <div ref="funnelRef" class="w-full h-[350px]"></div>
      </div>

      <div class="bg-white/60 backdrop-blur-md p-6 rounded-[2.5rem] shadow-sm border border-white/60 hover:shadow-lg transition-all">
        <h3 class="text-lg font-black text-rock-900 mb-6 flex items-center gap-2">
          <span class="w-2 h-7 bg-healing-500 rounded-full"></span> 风险状态分布
        </h3>
        <div ref="pieRef" class="w-full h-[350px]"></div>
      </div>
    </div>

    <!-- Charts Row 2: Dimension Frequency & Trend -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="bg-white/60 backdrop-blur-md p-6 rounded-[2.5rem] shadow-sm border border-white/60 hover:shadow-lg transition-all">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-black text-rock-900 flex items-center gap-2">
            <span class="w-2 h-7 bg-healing-500 rounded-full"></span> 心理症结画像 (Dimension Focus)
          </h3>
          <span class="text-xs text-rock-400 font-bold">高频出现维度排行</span>
        </div>
        <div ref="dimensionRef" class="w-full h-[320px]"></div>
      </div>

      <div class="bg-white/60 backdrop-blur-md p-6 rounded-[2.5rem] shadow-sm border border-white/60 hover:shadow-lg transition-all">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-black text-rock-900 flex items-center gap-2">
            <span class="w-2 h-7 bg-healing-500 rounded-full"></span> 测评活跃趋势 (7 Days)
          </h3>
          <span class="text-xs text-rock-400 font-bold">近一周数据波动</span>
        </div>
        <div ref="trendRef" class="w-full h-[320px]"></div>
      </div>
    </div>

    <!-- Workbench Section -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 pb-6">
      <!-- Latest Alerts (Left) -->
      <div class="bg-white/70 backdrop-blur-md p-6 rounded-[2.5rem] shadow-sm border border-white/60 relative overflow-hidden">
        <div class="absolute top-0 right-0 w-32 h-32 bg-clay-100 rounded-full blur-3xl opacity-50 -translate-y-1/2 translate-x-1/2"></div>
        <div class="flex items-center justify-between mb-6 relative z-10">
          <h3 class="text-lg font-black text-rock-900 flex items-center gap-2">
            <span class="w-2 h-7 bg-clay-500 rounded-full"></span> 最新警报 (Urgent Alerts)
          </h3>
          <button class="text-xs font-bold text-rock-400 hover:text-clay-600" @click="router.push('/users?risk=HIGH')">查看全部 ></button>
        </div>
        <div class="space-y-3 relative z-10">
          <div v-for="r in alertRecords" :key="r.id" class="flex items-center justify-between p-4 rounded-3xl bg-white/50 border border-white/80 hover:bg-white hover:shadow-md transition-all group">
            <div class="flex items-center gap-4">
              <div class="relative">
                <img :src="r.avatar" class="w-12 h-12 rounded-2xl bg-slate-100 border border-white shadow-sm" />
                <span class="absolute -top-1 -right-1 w-5 h-5 bg-clay-500 text-white text-[10px] flex items-center justify-center rounded-full border-2 border-white font-black animate-pulse">!</span>
              </div>
              <div>
                <div class="text-rock-900 font-bold group-hover:text-clay-600 transition-colors">{{ r.name }}</div>
                <div class="text-[10px] text-rock-400 font-bold uppercase mt-0.5 tracking-tighter">{{ r.scaleName }} · {{ r.date }}</div>
              </div>
            </div>
            <div class="flex items-center gap-3">
              <div class="text-right">
                <div class="text-lg font-black text-rock-800">{{ r.score }} <span class="text-[10px] font-medium text-rock-400">分</span></div>
                <div class="text-[10px] font-black text-clay-600 uppercase">HIGH RISK</div>
              </div>
              <button class="w-8 h-8 rounded-full bg-clay-50 text-clay-600 flex items-center justify-center hover:bg-clay-500 hover:text-white transition-all shadow-sm" @click="router.push('/result/' + r.id)">
                <el-icon><View /></el-icon>
              </button>
            </div>
          </div>
          <el-empty v-if="alertRecords.length === 0" description="暂无紧急警报" :image-size="80" />
        </div>
      </div>

      <!-- Pending Intervention (Right) -->
      <div class="bg-white/70 backdrop-blur-md p-6 rounded-[2.5rem] shadow-sm border border-white/60 relative overflow-hidden">
        <div class="absolute top-0 right-0 w-32 h-32 bg-healing-100 rounded-full blur-3xl opacity-50 -translate-y-1/2 translate-x-1/2"></div>
        <div class="flex items-center justify-between mb-6 relative z-10">
          <h3 class="text-lg font-black text-rock-900 flex items-center gap-2">
            <span class="w-2 h-7 bg-healing-500 rounded-full"></span> 待办中心 (Processing)
          </h3>
          <button class="text-xs font-bold text-rock-400 hover:text-healing-600" @click="router.push('/intervention')">去工作台 ></button>
        </div>
        <div class="space-y-3 relative z-10">
          <div v-for="r in pendingFollowUps" :key="r.id" class="flex items-center justify-between p-4 rounded-3xl bg-white/50 border border-white/80 hover:bg-white hover:shadow-md transition-all group">
            <div class="flex items-center gap-4">
              <div class="w-12 h-12 rounded-2xl bg-healing-50 text-healing-600 flex items-center justify-center text-xl font-black shadow-inner">
                {{ r.name.charAt(0) }}
              </div>
              <div>
                <div class="text-rock-900 font-bold group-hover:text-healing-600 transition-colors">{{ r.name }}</div>
                <div class="flex items-center gap-2 mt-0.5">
                  <span class="text-[10px] text-healing-600 font-black px-1.5 py-0.5 bg-healing-100 rounded-md"> 进行中 </span>
                  <span class="text-[10px] text-rock-400 font-bold tracking-tighter">{{ r.lastUpdate }}</span>
                </div>
              </div>
            </div>
            <div class="flex items-center gap-3">
              <div class="text-right">
                <div class="text-xs font-black text-rock-800">{{ r.type }}</div>
                <div class="text-[10px] text-rock-400 font-medium">干预阶段</div>
              </div>
              <button class="px-3 py-1.5 rounded-xl bg-healing-500 text-white text-[10px] font-black hover:bg-healing-600 transition-all shadow-md shadow-healing-500/10" @click="router.push('/intervention')">
                来访
              </button>
            </div>
          </div>
          <el-empty v-if="pendingFollowUps.length === 0" description="今日暂无待办事项" :image-size="80" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
import { View } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import axios from 'axios'

const router = useRouter()
const currentTime = ref(new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }))

// --- Stats & Refs ---
const displayTotal = ref(0)
const displayNewMonth = ref(0)
const displayHighRisk = ref(0)
const displayRate = ref(0)
const displayToday = ref(0)

const stats = computed(() => [
  { label: '测评总规模', displayValue: displayTotal.value, unit: '人次', icon: '📈', trend: '+12%', trendColor: 'text-healing-600 bg-healing-50', path: '/history' },
  { label: '本月新增档案', displayValue: displayNewMonth.value, unit: '份', icon: '📝', trend: '+5', trendColor: 'text-blue-600 bg-blue-50', path: '/history' },
  { label: '高风险待处理', displayValue: displayHighRisk.value, unit: '人', icon: '🚨', trend: '紧急', trendColor: 'text-clay-600 bg-clay-50', path: '/users?risk=HIGH' },
  { label: '干预完成率', displayValue: displayRate.value, unit: '%', icon: '🎯', trend: '稳定', trendColor: 'text-indigo-600 bg-indigo-50', path: '/intervention' },
  { label: '今日待办任务', displayValue: displayToday.value, unit: '项', icon: '📅', trend: '待跟进', trendColor: 'text-amber-600 bg-amber-50', path: '/intervention' },
])

// --- Chart Refs ---
const funnelRef = ref<HTMLElement | null>(null)
const pieRef = ref<HTMLElement | null>(null)
const dimensionRef = ref<HTMLElement | null>(null)
const trendRef = ref<HTMLElement | null>(null)

let funnelChart: echarts.ECharts | null = null
let pieChart: echarts.ECharts | null = null
let dimensionChart: echarts.ECharts | null = null
let trendChart: echarts.ECharts | null = null

// --- Records Refs ---
const alertRecords = ref<any[]>([])
const pendingFollowUps = ref<any[]>([])


// --- Lifecycle ---
onMounted(async () => {
  initCharts()
  await fetchData()
  setInterval(() => { currentTime.value = new Date().toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }) }, 1000)
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  funnelChart?.dispose()
  pieChart?.dispose()
  dimensionChart?.dispose()
  trendChart?.dispose()
})

const handleResize = () => {
  funnelChart?.resize()
  pieChart?.resize()
  dimensionChart?.resize()
  trendChart?.resize()
}

// --- Data Action ---
async function fetchData() {
  try {
    const [assessRes, userRes] = await Promise.all([
      axios.get('/api/assessments'),
      axios.get('/api/users')
    ])
    
    const rawAssess = assessRes.data || []
    const users = userRes.data || []

    // 1. Stats Animation
    animateNumber(displayTotal, rawAssess.length)
    animateNumber(displayNewMonth, Math.floor(rawAssess.length * 0.3) + 2)
    animateNumber(displayHighRisk, rawAssess.filter((a:any) => a.riskLevel === 'HIGH').length)
    animateNumber(displayRate, 85)
    animateNumber(displayToday, rawAssess.filter((a:any) => a.riskLevel === 'HIGH' && a.status !== 'ARCHIVED').length)

    // 2. High Risk Alerts
    alertRecords.value = rawAssess
      .filter((a:any) => a.riskLevel === 'HIGH')
      .slice(0, 4)
      .map((a:any) => ({
        id: a.id,
        name: a.userRealName || '访客',
        scaleName: a.scaleName || 'PCL-R',
        score: a.totalScore,
        date: new Date(a.createTime).toLocaleDateString(),
        avatar: `https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(a.userRealName || 'user')}&backgroundColor=e1efe9`
      }))

    // 3. 动态生成待办中心 - 筛选高风险最新3条
    pendingFollowUps.value = rawAssess
      .filter((a: any) => a.riskLevel === 'HIGH')
      .sort((a: any, b: any) => new Date(b.createTime).getTime() - new Date(a.createTime).getTime())
      .slice(0, 3)
      .map((a: any) => {
        const createDate = new Date(a.createTime)
        const now = new Date()
        const diffHours = Math.floor((now.getTime() - createDate.getTime()) / (1000 * 60 * 60))
        let lastUpdate = '刚刚'
        if (diffHours >= 24) {
          lastUpdate = `${Math.floor(diffHours / 24)}天前`
        } else if (diffHours >= 1) {
          lastUpdate = `${diffHours}小时前`
        }
        return {
          id: a.id,
          name: a.userRealName || '未知',
          type: '高危干预',
          lastUpdate
        }
      })

    // 4. Update Charts
    updateFunnelChart()
    updatePieChart(rawAssess)
    updateDimensionChart(rawAssess) // 传入数据
    updateTrendChart(rawAssess)

  } catch (err) {
    console.error('Fetch dashboard failed:', err)
  }
}

// --- Chart Options ---
function initCharts() {
  if (funnelRef.value) funnelChart = echarts.init(funnelRef.value)
  if (pieRef.value) pieChart = echarts.init(pieRef.value)
  if (dimensionRef.value) dimensionChart = echarts.init(dimensionRef.value)
  if (trendRef.value) trendChart = echarts.init(trendRef.value)
}

function updateFunnelChart() {
  if (!funnelChart) return
  const option = {
    tooltip: { trigger: 'item', formatter: '{b} : {c}' },
    series: [{
      name: '干预漏斗',
      type: 'funnel',
      left: '10%', top: 20, bottom: 20, width: '80%',
      minSize: '30%',
      sort: 'descending',
      gap: 12,
      label: { show: true, position: 'inside', formatter: '{b} ({c}%)', fontWeight: 'bold' },
      itemStyle: { borderColor: '#fff', borderWidth: 2, borderRadius: 15, shadowBlur: 10, shadowColor: 'rgba(0,0,0,0.1)' },
      emphasis: { label: { fontSize: 16 } },
      data: [
        { value: 100, name: '高风险识别', itemStyle: { color: '#E07A5F' } },
        { value: 82, name: '深度预判介入', itemStyle: { color: '#F2CC8F' } },
        { value: 65, name: '正在执行计划', itemStyle: { color: '#81B29A' } },
        { value: 48, name: '风险显著下降', itemStyle: { color: '#3D405B' } },
        { value: 30, name: '干预归档结案', itemStyle: { color: '#6B9080' } }
      ]
    }]
  }
  funnelChart.setOption(option)
}

function updatePieChart(assess: any[]) {
  if (!pieChart) return
  const h = assess.filter(a => a.riskLevel === 'HIGH').length
  const m = assess.filter(a => a.riskLevel === 'MEDIUM').length
  const l = assess.filter(a => a.riskLevel === 'LOW').length || (assess.length - h - m)
  
  const option = {
    tooltip: { trigger: 'item' },
    legend: { bottom: '0', left: 'center', itemGap: 20, textStyle: { fontWeight: 'bold', color: '#4A4E69' } },
    series: [{
      type: 'pie',
      radius: ['45%', '70%'],
      center: ['50%', '45%'],
      avoidLabelOverlap: false,
      itemStyle: { borderRadius: 12, borderColor: '#fff', borderWidth: 2 },
      label: { show: false },
      data: [
        { value: h, name: '重点关注', itemStyle: { color: '#E07A5F' } },
        { value: m, name: '一般关注', itemStyle: { color: '#F2CC8F' } },
        { value: l, name: '安心状态', itemStyle: { color: '#6B9080' } }
      ]
    }]
  }
  pieChart.setOption(option)
}

function updateDimensionChart(assess: any[]) {
  if (!dimensionChart) return
  
  // 动态计算维度频次
  const dimensionCount: Record<string, number> = {}
  for (const a of assess) {
    const dim = a.dimensionScore || a.dimensionAnalysis || {}
    if (typeof dim === 'object' && dim !== null) {
      for (const [key, value] of Object.entries(dim)) {
        if (key && key !== 'Unknown') {
          dimensionCount[key] = (dimensionCount[key] || 0) + (Number(value) || 1)
        }
      }
    }
  }
  
  // 排序取前5
  const sorted = Object.entries(dimensionCount)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 5)
  
  // 如果没有数据，使用默认值
  const names = sorted.length > 0 ? sorted.map(([k]) => k).reverse() : ['暂无数据']
  const values = sorted.length > 0 ? sorted.map(([, v]) => v).reverse() : [0]
  const maxValue = Math.max(...values, 1)
  const percentages = values.map(v => Math.round((v / maxValue) * 100))
  
  const option = {
    grid: { left: '3%', right: '10%', bottom: '3%', top: '3%', containLabel: true },
    xAxis: { type: 'value', splitLine: { show: false }, axisLine: { show: false }, axisTick: { show: false }, axisLabel: { show: false } },
    yAxis: { 
      type: 'category', 
      data: names,
      axisLine: { show: false },
      axisTick: { show: false },
      axisLabel: { fontWeight: 'bold', color: '#4A4E69' }
    },
    series: [{
      type: 'bar',
      data: percentages,
      barWidth: 14,
      itemStyle: {
        borderRadius: [0, 10, 10, 0],
        color: new echarts.graphic.LinearGradient(1, 0, 0, 0, [
          { offset: 0, color: '#6B9080' },
          { offset: 1, color: '#E1EFE9' }
        ])
      },
      showBackground: true,
      backgroundStyle: { color: 'rgba(107, 144, 128, 0.05)', borderRadius: 10 },
      label: { show: true, position: 'right', formatter: '{c}%', fontWeight: 'black', color: '#6B9080' }
    }]
  }
  dimensionChart.setOption(option)
}

function updateTrendChart(assess: any[]) {
  if (!trendChart) return
  
  // 动态计算过去7天每天的测评数量
  const today = new Date()
  today.setHours(23, 59, 59, 999)
  const days: string[] = []
  const counts: number[] = []
  
  for (let i = 6; i >= 0; i--) {
    const date = new Date(today)
    date.setDate(today.getDate() - i)
    const dayStart = new Date(date)
    dayStart.setHours(0, 0, 0, 0)
    const dayEnd = new Date(date)
    dayEnd.setHours(23, 59, 59, 999)
    
    // 格式化为 MM-DD
    const month = (date.getMonth() + 1).toString().padStart(2, '0')
    const day = date.getDate().toString().padStart(2, '0')
    days.push(`${month}-${day}`)
    
    // 统计当天数量
    const count = assess.filter((a: any) => {
      const createTime = new Date(a.createTime)
      return createTime >= dayStart && createTime <= dayEnd
    }).length
    counts.push(count)
  }
  
  const option = {
    grid: { left: '3%', right: '4%', bottom: '3%', top: '3%', containLabel: true },
    tooltip: { trigger: 'axis' },
    xAxis: { 
      type: 'category', 
      data: days, 
      axisLine: { lineStyle: { color: '#EBE6E0' } },
      axisLabel: { color: '#A7A7B3', fontWeight: 'bold' }
    },
    yAxis: { type: 'value', splitLine: { lineStyle: { type: 'dashed' } } },
    series: [{
      data: counts,
      type: 'line',
      smooth: true,
      symbolSize: 8,
      lineStyle: { width: 4, color: '#6B9080' },
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: 'rgba(107, 144, 128, 0.2)' },
          { offset: 1, color: 'rgba(107, 144, 128, 0)' }
        ])
      }
    }]
  }
  trendChart.setOption(option)
}

function animateNumber(ref: any, to: number) {
  const start = ref.value
  const duration = 1500
  const startTime = performance.now()
  const easeOut = (t: number) => 1 - Math.pow(1 - t, 4)
  const step = (time: number) => {
    const elapsed = time - startTime
    const progress = Math.min(elapsed / duration, 1)
    ref.value = Math.floor(start + (to - start) * easeOut(progress))
    if (progress < 1) requestAnimationFrame(step)
  }
  requestAnimationFrame(step)
}
</script>

<style scoped>
.fade-up { animation: fadeUp 0.8s cubic-bezier(0.16, 1, 0.3, 1) both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }

.bg-healing-500 { background-color: #6B9080 !important; }
.text-healing-600 { color: #557366 !important; }
.text-healing-700 { color: #3A4D45 !important; }
.bg-healing-50 { background-color: #F0F7F4 !important; }
.bg-healing-100 { background-color: #E1EFE9 !important; }
.border-healing-100 { border-color: #C2DFCE !important; }

.bg-clay-500 { background-color: #E07A5F !important; }
.bg-clay-50 { background-color: #FDF4F1 !important; }
.bg-clay-100 { background-color: #F9E5E1 !important; }
.text-clay-600 { color: #B3614C !important; }

.bg-cream-100 { background-color: #F6F4F1 !important; }
.bg-cream-50 { background-color: #FBF9F7 !important; }
.border-cream-200 { border-color: #EBE6E0 !important; }

.text-rock-900 { color: #22223B !important; }
.text-rock-800 { color: #4A4E69 !important; }
.text-rock-500 { color: #8F91A3 !important; }
.text-rock-400 { color: #A7A7B3 !important; }

:deep(.el-empty__description p) {
  color: #A7A7B3 !important;
  font-weight: bold;
  font-size: 12px;
}
</style>