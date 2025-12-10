<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow p-5 flex items-center justify-between">
      <div>
        <h3 class="text-lg font-bold text-slate-800">测评档案库</h3>
        <p class="text-sm text-slate-500 mt-1">按姓名与风险筛选历史评估记录</p>
      </div>
      <div class="flex flex-wrap items-center gap-3 min-w-0">
        <input v-model="keyword" type="text" placeholder="搜索犯人姓名..." class="w-64 max-w-full px-3 py-2 rounded-xl border border-slate-300 focus:outline-none focus:ring-2 focus:ring-cyan-500 bg-white" />
        <select v-model="risk" class="w-40 px-3 py-2 rounded-xl border border-slate-300 bg-white focus:outline-none focus:ring-2 focus:ring-cyan-500">
          <option value="ALL">全部风险</option>
          <option value="HIGH">高风险</option>
          <option value="MEDIUM">中风险</option>
          <option value="LOW">低风险</option>
        </select>
        <el-date-picker v-model="date" type="date" placeholder="选择日期" size="small" :editable="false" style="width: 160px" />
      </div>
    </div>

    <div class="glass-card p-1 rounded-3xl overflow-hidden shadow-lg border border-white/60">
<el-table :data="filtered" style="width: 100%" :header-cell-style="{ background: '#f8fafc', color: '#475569', fontWeight: '600', borderBottom: '1px solid #e2e8f0' }" :row-style="{ background: 'transparent' }">
        <el-table-column label="评估对象" min-width="200">
          <template #default="{ row }">
            <div class="flex items-center gap-3">
              <img :src="avatar(row.userRealName)" class="w-12 h-12 rounded-full border-2 border-white shadow-sm bg-slate-100" :alt="row.userRealName" />
              <div>
                <div class="font-bold text-slate-800 text-base">{{ row.userRealName }}</div>
                <div class="text-xs text-slate-400 font-mono mt-0.5 bg-slate-100 px-1.5 py-0.5 rounded inline-block">ID: {{ row.prisonerId }}</div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="评估日期" min-width="160">
          <template #default="{ row }">
            <div class="flex flex-col">
              <span class="text-slate-700 font-medium">{{ formatTime(row.createTime).split(' ')[0] }}</span>
              <span class="text-xs text-slate-400">{{ formatTime(row.createTime).split(' ')[1] }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="评估结果" width="180">
          <template #default="{ row }">
            <div class="flex flex-col gap-1">
              <div class="flex items-center gap-2">
                <span class="text-2xl font-black text-slate-700">{{ row.totalScore }}</span>
                <span class="text-xs text-slate-400 font-medium mt-1">分</span>
              </div>
              <div class="flex gap-2">
                <span :class="assessorClass(row.totalScore)" class="text-[10px] px-2 py-0.5 rounded-full border flex items-center gap-1">{{ assessorLabel(row.totalScore) }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="风险等级" width="140">
          <template #default="{ row }">
            <span :class="riskBadge(row.riskLevel)" class="text-xs px-3 py-1 rounded-full font-bold border border-white/20 shadow-sm">
              {{ riskLabel(row.riskLevel) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size="small" class="!rounded-lg !px-4 !font-medium !shadow-md hover:!shadow-lg transition-all" @click="viewDetail(row)">查看报告</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
  </template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'

type Risk = 'LOW' | 'MEDIUM' | 'HIGH'
type Item = { id: number; userRealName: string; createTime: string; totalScore: number; riskLevel: Risk; prisonerId: string; isMock?: boolean }
const router = useRouter()
const keyword = ref('')
const risk = ref<'ALL' | Risk>('ALL')
const date = ref<string | null>(null)
const list = ref<Item[]>([])

onMounted(async () => {
  try {
    const { data } = await axios.get<Item[]>('/api/assessments')
    const raw: any[] = Array.isArray(data) ? data : []
    const onlyPrisoners = raw.filter(x => String((x.userRole || x.role || 'PRISONER')).toUpperCase() === 'PRISONER')
    list.value = onlyPrisoners.map(x => ({ ...x, prisonerId: x.prisonerId || String(x.id) }))
  } catch (e: any) {
    ElMessage.error('无法连接到服务器')
    list.value = []
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
  return `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(name || 'user')}`
}

function riskBadge(r: Risk) {
  if (r === 'HIGH') return 'bg-rose-100 text-rose-700'
  if (r === 'MEDIUM') return 'bg-amber-100 text-amber-700'
  return 'bg-emerald-100 text-emerald-700'
}

function riskLabel(r: Risk) {
  if (r === 'HIGH') return '高风险'
  if (r === 'MEDIUM') return '中风险'
  return '低风险'
}

function viewDetail(row: Item) { router.push({ path: `/result/${row.id}`, query: { name: row.userRealName } }) }

function assessorLabel(score: number) {
  const s = Number(score || 0)
  return s < 5 ? '自评' : '他评'
}

function assessorClass(score: number) {
  const s = Number(score || 0)
  return s < 5 ? 'bg-slate-100 text-slate-600' : 'bg-blue-100 text-blue-700'
}
</script>

<style scoped>
.glass-card { 
  background-color: rgba(255, 255, 255, 0.7); 
  backdrop-filter: blur(12px); 
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.07); 
}
.fade-up { animation: fadeUp 0.5s ease-out both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
:deep(.el-table) {
  background-color: transparent !important;
  --el-table-bg-color: transparent !important;
  --el-table-tr-bg-color: transparent !important;
  --el-table-header-bg-color: transparent !important;
}
:deep(.el-table__inner-wrapper::before) { display: none; }
</style>
