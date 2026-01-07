<template>
  <div class="p-6 md:p-10 space-y-8 fade-up min-h-screen bg-cream-100">
    <!-- Header Area -->
    <div class="glass-card p-6 rounded-3xl flex flex-col md:flex-row items-center justify-between gap-6 shadow-pg hover:shadow-lg transition-shadow duration-300">
      <div class="text-center md:text-left">
        <h3 class="text-2xl font-bold text-rock-800 tracking-tight flex items-center gap-3 justify-center md:justify-start">
          <span class="w-2 h-8 rounded-full bg-healing-500"></span>
          {{ isCounselor ? '测评档案库' : '我的测评记录' }}
        </h3>
        <p class="text-rock-500 mt-2 font-medium">
          {{ isCounselor ? 'Archived Assessments & Records' : 'My Assessment History' }}
        </p>
      </div>
      
      <!-- Filters -->
      <div class="flex flex-wrap items-center justify-center gap-4 w-full md:w-auto">
        <div class="relative group">
          <input 
            v-model="keyword" 
            type="text" 
            placeholder="搜索姓名..." 
            class="w-64 pl-4 pr-10 py-3 rounded-2xl border-2 border-cream-200 bg-white/80 focus:outline-none focus:border-healing-500 focus:ring-4 focus:ring-healing-500/10 text-rock-800 placeholder-rock-400 transition-all shadow-sm"
          />
          <span class="absolute right-3 top-3.5 text-rock-400">
             <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
          </span>
        </div>

        <div class="relative">
          <select 
            v-model="risk" 
            class="appearance-none w-40 pl-4 pr-10 py-3 rounded-2xl border-2 border-cream-200 bg-white/80 focus:outline-none focus:border-healing-500 focus:ring-4 focus:ring-healing-500/10 text-rock-800 font-medium cursor-pointer transition-all shadow-sm"
          >
            <option value="ALL">全部状态</option>
            <option value="HIGH">重点关注</option>
            <option value="MEDIUM">一般关注</option>
            <option value="LOW">安心状态</option>
          </select>
          <span class="absolute right-3 top-3.5 text-rock-400 pointer-events-none">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
          </span>
        </div>
        
        <div class="date-picker-wrapper">
           <el-date-picker 
             v-model="date" 
             type="date" 
             placeholder="选择日期" 
             :editable="false" 
             class="!w-40 !h-[46px] !rounded-2xl !border-0 !shadow-none custom-date-picker"
             popper-class="healing-datepicker"
           />
        </div>
      </div>
    </div>

    <!-- Table Card -->
    <div class="glass-card p-1 rounded-[2rem] overflow-hidden shadow-xl border border-white/60 relative">
      <div class="absolute top-0 right-0 w-64 h-64 bg-healing-100 rounded-full mix-blend-multiply filter blur-3xl opacity-30 pointer-events-none"></div>

      <el-table 
        :data="filtered" 
        style="width: 100%" 
        :header-cell-style="{ background: 'rgba(246, 244, 241, 0.5)', color: '#4A4E69', fontWeight: '600', padding: '20px', fontSize: '14px', borderBottom: '1px solid rgba(107, 144, 128, 0.1)' }" 
        :row-style="{ background: 'transparent' }"
        :cell-style="{ padding: '16px 20px' }"
      >
        <el-table-column label="来访者" min-width="200">
          <template #default="{ row }">
            <div class="flex items-center gap-4 group cursor-default">
              <div class="relative">
                <img 
                  :src="avatar(row.userRealName)" 
                  class="w-14 h-14 rounded-2xl border-2 border-white shadow-md group-hover:scale-105 transition-transform duration-300 bg-cream-50" 
                  :alt="row.userRealName" 
                />
                <div class="absolute -bottom-1 -right-1 w-4 h-4 rounded-full border-2 border-white shadow-sm" :class="riskDotInfo(row.riskLevel).color"></div>
              </div>
              <div>
                <div class="font-bold text-rock-800 text-lg group-hover:text-healing-600 transition-colors">{{ row.userRealName }}</div>
                <div class="text-xs text-rock-400 font-mono mt-1 bg-white/60 px-2 py-0.5 rounded-md inline-block border border-cream-200">ID:{{ row.prisonerId }}</div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="评估时间" min-width="160">
          <template #default="{ row }">
             <div class="flex items-center gap-2">
                 <div class="p-2 rounded-xl bg-healing-50 text-healing-500">
                   <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                 </div>
                 <div class="flex flex-col">
                  <span class="text-rock-700 font-bold font-mono">{{ formatTime(row.createTime).split(' ')[0] }}</span>
                  <span class="text-xs text-rock-400">{{ formatTime(row.createTime).split(' ')[1] }}</span>
                </div>
             </div>
          </template>
        </el-table-column>

        <el-table-column label="评估结果" width="180">
          <template #default="{ row }">
            <div class="flex flex-col gap-1">
              <div class="flex items-baseline gap-1">
                <span class="text-3xl font-black text-rock-800 tracking-tighter">{{ row.totalScore }}</span>
                <span class="text-xs text-rock-400 font-medium">分</span>
              </div>
              <div class="flex gap-2">
                <span :class="assessorClass(row.totalScore)" class="text-[10px] px-2 py-0.5 rounded-full border flex items-center gap-1 font-bold">{{ assessorLabel(row.totalScore) }}</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="关注状态" width="140">
          <template #default="{ row }">
            <span :class="riskBadge(row.riskLevel)" class="text-xs px-3 py-1.5 rounded-full font-bold border border-white/40 shadow-sm inline-flex items-center gap-1.5">
              <span class="w-1.5 h-1.5 rounded-full bg-current opacity-60"></span>
              {{ riskLabel(row.riskLevel) }}
            </span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              class="!rounded-xl !h-10 !px-5 !bg-healing-500 !border-healing-500 !shadow-lg !shadow-healing-500/20 hover:!bg-healing-600 hover:!shadow-healing-500/30 hover:!-translate-y-0.5 transition-all duration-300"
              @click="viewDetail(row)"
            >
              详情
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- Empty State -->
      <div v-if="filtered.length === 0" class="py-20 text-center">
        <div class="w-24 h-24 bg-cream-50 rounded-full flex items-center justify-center mx-auto mb-4 border-4 border-white shadow-inner">
           <svg class="w-10 h-10 text-rock-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
        </div>
        <p class="text-rock-400 font-medium">暂时没有找到符合条件的记录...</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

type Risk = 'LOW' | 'MEDIUM' | 'HIGH'
type Item = { id: number; userRealName: string; createTime: string; totalScore: number; riskLevel: Risk; prisonerId: string }

const router = useRouter()
const userStore = useUserStore()
const list = ref<Item[]>([])
const keyword = ref('')
const risk = ref<'ALL' | Risk>('ALL')
const date = ref<string | null>(null)

// 判断角色
const isCounselor = computed(() => userStore.isCounselor)

onMounted(async () => {
  userStore.load()
  try {
    const { data } = await axios.get<Item[]>('/api/assessments')
    list.value = (data || []).map(x => ({ ...x, prisonerId: x.prisonerId || String(x.id) }))
  } catch (err) {
    console.error('Failed to fetch assessments:', err)
  }
})

const filtered = computed(() => {
  const k = keyword.value.trim().toLowerCase()
  const d = date.value
  return list.value.filter(i => {
    const matchText = !k || (i.userRealName || '').toLowerCase().includes(k)
    const matchRisk = risk.value === 'ALL' || i.riskLevel === risk.value
    let matchDate = true
    if (d) {
      const itemDate = new Date(i.createTime).toISOString().split('T')[0]
      matchDate = itemDate === d
    }
    return matchText && matchRisk && matchDate
  })
})

function formatTime(t: string) {
  try {
    const d = new Date(t)
    const y = d.getFullYear()
    const m = String(d.getMonth() + 1).padStart(2, '0')
    const day = String(d.getDate()).padStart(2, '0')
    const hh = String(d.getHours()).padStart(2, '0')
    const mm = String(d.getMinutes()).padStart(2, '0')
    return `${y}-${m}-${day} ${hh}:${mm}`
  } catch { return t }
}

function avatar(name: string) {
  return `https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(name || 'user')}&backgroundColor=e1efe9`
}

function riskBadge(r: Risk) {
  if (r === 'HIGH') return 'bg-clay-100 text-clay-600 border-clay-200'
  if (r === 'MEDIUM') return 'bg-cream-200 text-rock-600 border-cream-300'
  return 'bg-healing-100 text-healing-600 border-healing-200'
}

function riskDotInfo(r: Risk) {
  if (r === 'HIGH') return { color: 'bg-clay-500' }
  if (r === 'MEDIUM') return { color: 'bg-cream-400' }
  return { color: 'bg-healing-500' }
}

function riskLabel(r: Risk) {
  if (r === 'HIGH') return '重点关注'
  if (r === 'MEDIUM') return '一般关注'
  return '安心状态'
}

function viewDetail(row: Item) {
  router.push({ path: `/result/${row.id}`, query: { name: row.userRealName } })
}

function assessorLabel(score: number) {
  const s = Number(score || 0)
  return s < 5 ? '常规记录' : '深度分析'
}

function assessorClass(score: number) {
  const s = Number(score || 0)
  return s < 5 ? 'bg-cream-100 text-rock-500 border-cream-200' : 'bg-healing-50 text-healing-600 border-healing-200'
}
</script>

<style scoped>
.glass-card { 
  background-color: rgba(255, 255, 255, 0.7); 
  backdrop-filter: blur(20px); 
  -webkit-backdrop-filter: blur(20px);
  box-shadow: 0 8px 32px rgba(107, 144, 128, 0.08); 
  border-radius: 2rem !important;
}
.shadow-pg { box-shadow: 0 8px 24px rgba(74, 78, 105, 0.06); }
.fade-up { animation: fadeUp 0.6s ease-out both; }

@keyframes fadeUp { 
  from { opacity: 0; transform: translateY(20px); } 
  to { opacity: 1; transform: translateY(0); } 
}

.bg-cream-50 { background-color: #FBF9F7 !important; }
.bg-cream-100 { background-color: #F6F4F1 !important; }
.bg-cream-200 { background-color: #EBE6E0 !important; }

.text-rock-800 { color: #4A4E69 !important; }
.text-rock-700 { color: #5C5F77 !important; }
.text-rock-500 { color: #8F91A3 !important; }
.text-rock-400 { color: #A7A7B3 !important; }
.text-rock-300 { color: #C4C5D0 !important; }

.bg-healing-50 { background-color: #F0F7F4 !important; }
.bg-healing-100 { background-color: #E1EFE9 !important; }
.bg-healing-500 { background-color: #6B9080 !important; }
.bg-healing-600 { background-color: #557366 !important; }
.text-healing-600 { color: #557366 !important; }
.border-healing-200 { border-color: #C2DFCE !important; }

.bg-clay-100 { background-color: #FBECE8 !important; }
.bg-clay-500 { background-color: #E07A5F !important; }
.text-clay-600 { color: #B3614C !important; }
.border-clay-200 { border-color: #F0BCAE !important; }

:deep(.el-table) {
  background-color: transparent !important;
  --el-table-bg-color: transparent !important;
  --el-table-tr-bg-color: transparent !important;
  --el-table-header-bg-color: transparent !important;
  --el-table-row-hover-bg-color: #F0F7F4 !important;
}
:deep(.el-table__inner-wrapper::before) { display: none; }

:deep(.el-input__wrapper) {
  background-color: rgba(255,255,255,0.8) !important;
  border-radius: 12px !important;
  box-shadow: none !important;
  border: 2px solid #EBE6E0 !important;
}
</style>
