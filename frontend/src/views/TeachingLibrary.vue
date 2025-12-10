<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="flex flex-col md:flex-row md:items-center justify-between bg-white/80 backdrop-blur-md px-6 py-5 rounded-3xl shadow-sm border border-white/50 relative z-10">
      <div>
        <h1 class="text-2xl font-bold text-slate-800">经典案例教学库</h1>
        <p class="text-sm text-slate-500 mt-1">专家甄选典型案例 · 沉淀科研教学数据</p>
      </div>
      <div class="mt-4 md:mt-0 w-full md:w-auto">
        <el-input
          v-model="query"
          placeholder="🔍 搜索姓名、诊断或批注..."
          clearable
          class="w-full md:w-80 search-glass"
        />
      </div>
    </div>

    <div v-if="filtered.length === 0" class="flex flex-col items-center justify-center py-20 bg-white/40 backdrop-blur-sm rounded-3xl">
      <el-empty description="暂无符合条件的经典案例" />
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
      <div
        v-for="it in filtered"
        :key="it.id"
        class="group relative flex flex-col justify-between p-6 bg-white/60 backdrop-blur-md rounded-3xl shadow-sm border border-white/60 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl hover:bg-white/90"
      >
        <div>
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 rounded-full bg-slate-200 flex items-center justify-center text-lg shadow-inner">
                {{ it.userRealName ? it.userRealName[0] : 'U' }}
              </div>
              <div>
                <div class="font-bold text-slate-800 text-lg">{{ it.userRealName }}</div>
                <div class="text-xs text-slate-400">ID: {{ it.id }}</div>
              </div>
            </div>
            <span
              :class="it.riskLevel === 'HIGH' ? 'bg-rose-100 text-rose-700' : 'bg-emerald-100 text-emerald-700'"
              class="px-3 py-1 rounded-full text-xs font-bold tracking-wide"
            >
              {{ it.riskLevel === 'HIGH' ? '高风险' : '低风险' }}
            </span>
          </div>

          <div class="mb-4">
            <div class="text-xs text-slate-400 uppercase tracking-wider mb-1">PCL-R 总分</div>
            <div class="text-3xl font-black text-slate-700">{{ it.totalScore }} <span class="text-sm font-normal text-slate-400">/ 40</span></div>
          </div>

          <div class="bg-amber-50/80 p-3 rounded-xl border border-amber-100 mb-4">
            <div class="flex items-center gap-2 mb-1">
              <span class="text-amber-600">🎓</span>
              <span class="text-xs font-bold text-amber-700">专家批注</span>
            </div>
            <p class="text-sm text-slate-700 leading-relaxed line-clamp-3">
              {{ it.expertAnnotation || '暂无批注内容...' }}
            </p>
          </div>
        </div>

        <button
          class="w-full py-3 rounded-xl bg-slate-900 text-white font-medium hover:bg-slate-700 active:scale-[0.98] transition-all shadow-lg shadow-slate-900/20 flex items-center justify-center gap-2 group-hover:bg-blue-600 group-hover:shadow-blue-600/30"
          @click="openDetail(it)"
        >
          <span>查看完整案例</span>
          <span class="text-xs opacity-60">→</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, computed, onBeforeUnmount } from 'vue'
import axios from 'axios'
import { useRouter } from 'vue-router'

type Item = {
  id: number
  userRealName: string
  totalScore: number
  riskLevel: string
  expertAnnotation?: string
}

const items = ref<Item[]>([])
const router = useRouter()
const query = ref('')

const filtered = computed(() => {
  const q = query.value.trim().toLowerCase()
  if (!q) return items.value
  return items.value.filter(it => {
    const name = (it.userRealName || '').toLowerCase()
    const ann = (it.expertAnnotation || '').toLowerCase()
    return name.includes(q) || ann.includes(q)
  })
})

const fetchData = async () => {
  try {
    const { data } = await axios.get('/api/assessments/teaching-cases')
    items.value = Array.isArray(data) ? data : []
  } catch (error: any) {
    console.error(error)
  }
}

onMounted(() => {
  fetchData()
  window.addEventListener('pg_teaching_refresh', fetchData)
})

onBeforeUnmount(() => {
  window.removeEventListener('pg_teaching_refresh', fetchData)
})

function openDetail(it: Item) {
  router.push('/result/' + it.id)
}
</script>

<style scoped>
.fade-up { animation: fadeUp 0.5s ease-out both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

:deep(.search-glass .el-input__wrapper) {
  background-color: rgba(255, 255, 255, 0.6) !important;
  box-shadow: none !important;
  border: 1px solid rgba(255, 255, 255, 0.5);
  border-radius: 12px;
  padding: 8px 16px;
  transition: all 0.3s;
}
:deep(.search-glass .el-input__wrapper.is-focus) {
  background-color: #fff !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05) !important;
}

.line-clamp-3 { display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; }
</style>
