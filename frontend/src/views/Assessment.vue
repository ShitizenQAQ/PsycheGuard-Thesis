<template>
  <div class="min-h-screen bg-cream-100 flex flex-col relative overflow-hidden">
    <div class="absolute top-1/4 left-0 w-64 h-64 bg-healing-200 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob"></div>
    <div class="absolute top-1/3 right-0 w-64 h-64 bg-clay-200 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob animation-delay-2000"></div>

    <div class="bg-white/60 backdrop-blur-md px-6 py-4 flex justify-between items-center shadow-sm border-b border-white/50 z-10 sticky top-0">
      <div class="flex items-center space-x-3">
        <img :src="avatarUrl" class="w-10 h-10 rounded-full border-2 border-white shadow-sm" :alt="userName" />
        <div>
          <p class="font-bold text-rock-800">{{ userName }}</p>
          <p class="text-xs text-rock-500">正在进行 {{ currentScaleName || '请选择量表' }} 测评</p>
        </div>
      </div>
      <button class="px-3 py-1.5 rounded-lg border border-cream-200 bg-white text-rock-600 hover:bg-cream-50 hover:text-healing-600 transition-colors" @click="handleLogout">退出</button>
    </div>

    <div class="flex-1 flex flex-col items-center justify-center p-6 max-w-5xl mx-auto w-full relative z-0">
      <div v-if="viewMode === 'SCALE_LIST'" class="w-full max-w-5xl fade-up">
        <div class="text-center mb-12">
          <h2 class="text-3xl font-bold text-rock-800 mb-3">心理测评中心</h2>
          <p class="text-rock-500">探索内心，发现更好的自己</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div 
            v-for="scale in scales" 
            :key="scale.id"
            class="group bg-white rounded-[2rem] p-6 shadow-sm border border-cream-200 hover:border-healing-200 hover:shadow-healing-500/20 transition-all duration-300 hover:-translate-y-1"
          >
            <div class="w-14 h-14 rounded-2xl bg-healing-50 mb-6 flex items-center justify-center text-healing-600 group-hover:bg-healing-500 group-hover:text-white transition-colors">
              <span class="font-bold text-xl">{{ scale.name.charAt(0) }}</span>
            </div>
            
            <h3 class="text-xl font-bold text-rock-800 mb-2">{{ scale.name }}</h3>
            <p class="text-sm text-rock-500 mb-6 line-clamp-2">{{ scale.description || '专业心理评估量表，助您了解当前状态。' }}</p>
            
            <button 
              @click="startClientAssessment(scale.id)"
              class="w-full py-3 rounded-xl bg-white border-2 border-cream-200 text-rock-600 font-bold group-hover:bg-healing-500 group-hover:border-healing-500 group-hover:text-white transition-all shadow-sm"
            >
              开始测评
            </button>
          </div>
        </div>
      </div>

      <div v-else-if="viewMode === 'LIST'" class="w-full">
        <div class="mb-6">
          <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white/60 p-5 flex items-center justify-between">
            <div>
              <h3 class="text-lg font-bold text-rock-800">选择评估对象</h3>
              <p class="text-sm text-rock-500 mt-1">请从下方列表查看所有需要评估的来访者</p>
            </div>
            <div class="flex items-center gap-3 text-sm text-rock-600">
              <span class="px-2 py-1 rounded-full bg-cream-100 border border-cream-200">来访者总数：{{ prisonerList.length }}</span>
              <span class="px-2 py-1 rounded-full bg-cream-100 border border-cream-200">真实：{{ realCount }}，模拟：{{ simCount }}</span>
            </div>
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="p in prisonerList" :key="p.id" class="glass-card group relative p-6 rounded-[2rem] border border-white/60 bg-white/60 shadow-sm transition-all hover:-translate-y-1 hover:shadow-healing-500/10">
            <div class="flex items-center gap-4">
              <img :src="`https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(p.name)}`" class="w-14 h-14 rounded-full border-4 border-white shadow-sm bg-cream-100" :alt="p.name" />
               <div>
                <div class="text-lg font-bold text-rock-800">{{ p.name }}</div>
                <div class="text-xs font-mono text-rock-400 bg-white px-2 py-0.5 rounded border border-gray-100">ID: {{ p.prisonerId }}</div>
              </div>
            </div>
            <div class="mt-4 flex items-center justify-between">
              <span class="text-xs px-2 py-1 rounded-full font-bold" :class="p.simulated ? 'bg-amber-100 text-amber-700' : (p.status === 'Pending' ? 'bg-healing-50 text-healing-600 border border-healing-100' : 'bg-gray-100 text-gray-500')">{{ p.simulated ? '模拟数据' : (p.status === 'Pending' ? '待评估' : '已归档') }}</span>
              <button class="px-4 py-2 text-sm font-bold rounded-xl text-white transition-all shadow-lg" :disabled="p.simulated" :class="p.simulated ? 'bg-gray-300 cursor-not-allowed shadow-none' : 'bg-healing-500 hover:bg-healing-600 shadow-healing-500/20 hover:shadow-healing-500/30 hover:scale-105'" @click="startAssessment(p)">开始评估</button>
            </div>
          </div>
        </div>
      </div>
      <div v-else-if="viewMode === 'QUESTION'" class="w-full">
        <div v-if="loading" class="text-center py-20">
          <div class="w-12 h-12 border-4 border-healing-200 border-t-healing-500 rounded-full animate-spin mx-auto mb-4"></div>
          <p class="text-rock-500">正在准备测评量表...</p>
        </div>

        <div v-else-if="questions.length > 0" class="w-full">
          <div class="mb-8 px-4">
            <div class="flex justify-between text-sm font-medium text-rock-500 mb-2">
              <span>当前进度 {{ currentQuestionIndex + 1 }} / {{ questions.length }}</span>
              <span>{{ Math.round(((currentQuestionIndex + 1) / questions.length) * 100) }}%</span>
            </div>
            <div class="h-2 w-full bg-cream-200 rounded-full overflow-hidden">
              <div class="h-full bg-healing-500 transition-all duration-500 ease-out" :style="{ width: `${((currentQuestionIndex + 1) / questions.length) * 100}%` }"></div>
            </div>
          </div>

          <div class="bg-white/70 backdrop-blur-xl border border-white/60 p-0 rounded-[2rem] shadow-xl shadow-healing-500/5 min-h-[400px] flex flex-col relative transition-all duration-300">
            <div v-if="role === 'ROLE_COUNSELOR'" class="bg-white/50 border-b border-cream-200 p-6 rounded-t-[2rem] flex items-center justify-between">
              <div>
                <button class="bg-white border border-cream-200 shadow-sm px-4 py-2 rounded-xl text-rock-600 font-medium text-sm hover:bg-healing-50 hover:text-healing-600 hover:border-healing-200 transition-all flex items-center gap-2" @click="backToList">← 返回列表</button>
              </div>
              <div class="flex items-center gap-4">
                <img :src="profileAvatarUrl" class="w-14 h-14 rounded-full border-2 border-white shadow-sm" :alt="targetNamePlain" />
                <div>
                  <div class="text-xl font-bold text-rock-800">{{ targetNamePlain }}</div>
                  <div class="inline-flex items-center text-xs text-rock-500 bg-white border border-cream-200 px-2 py-0.5 rounded-full mt-1">ID: {{ targetUserId }}</div>
                  <div class="text-xs text-rock-400 mt-1">正在进行 {{ currentScaleName || '请选择量表' }} 评估</div>
                </div>
              </div>
              <div class="flex items-center gap-4">
                <div class="text-sm text-rock-600">👨‍⚕️ 咨询师: {{ assessorName }}</div>
                <el-select v-model="currentScaleId" placeholder="选择量表" style="width: 220px" @change="loadQuestions">
                  <el-option v-for="s in scales" :key="s.id" :label="s.name" :value="s.id" />
                </el-select>
              </div>
            </div>
            <!-- 修改来访者视角的顶部，不需要选择量表了，因为已经选了 -->
            <div v-else class="bg-slate-50 border-b border-slate-200 p-6 rounded-t-3xl flex justify-between items-center">
               <button class="text-rock-400 hover:text-rock-600 flex items-center gap-1 text-sm transition-colors" @click="backToScaleList">
                 <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                 返回选择
               </button>
               <div class="text-sm text-slate-700 font-bold bg-white px-3 py-1 rounded-lg shadow-sm">{{ currentScaleName }}</div>
            </div>

            <div class="p-8 md:p-12 flex-1 flex flex-col justify-center">
              <span class="inline-block bg-healing-100 text-healing-600 text-xs font-bold px-3 py-1 rounded-full mb-4 w-fit border border-healing-200">
                {{ currentQuestion.dimension || dimensionLabel }}
              </span>

              <h2 class="text-2xl md:text-3xl font-bold text-rock-800 mb-10 leading-snug mt-6">
                {{ currentQuestion.content.split('(')[0] }}
                <span class="block text-sm font-normal text-rock-400 mt-2">
                  {{ currentQuestion.content.match(/\((.*?)\)/)?.[1] || '' }}
                </span>
              </h2>

              <div class="text-xs bg-cream-50 text-rock-500 border border-cream-200 rounded-xl p-3 mb-6">
                评分参考：请依据真实情况进行客观评分。
              </div>

              <div class="grid grid-cols-3 gap-3">
                <button
                  v-for="opt in ratingOptions"
                  :key="opt.score"
                  @click="handleAnswer(currentQuestion.id, opt.score)"
                  :class="[
                    'w-full text-center py-3 px-2 rounded-xl border text-sm font-bold transition-all duration-200',
                    answers[currentQuestion.id] === opt.score
                      ? 'bg-healing-500 text-white border-healing-500 shadow-md shadow-healing-500/20 transform scale-[1.02]'
                      : 'bg-white border-cream-200 text-rock-600 hover:border-healing-300 hover:bg-healing-50 hover:text-healing-600'
                  ]"
                >
                  {{ opt.label }}
                </button>
              </div>

              <div class="mt-8 flex justify-between items-center pt-6 border-t border-slate-100">
                <button v-if="currentQuestionIndex > 0" @click="currentQuestionIndex--" class="text-rock-400 hover:text-rock-600 font-medium px-4 py-2 hover:bg-cream-100 rounded-lg transition-colors">上一题</button>
                <div v-else></div>
                <button v-if="isLastQuestion" @click="submitAssessment" :disabled="submitLoading" :class="{ 'opacity-50 cursor-not-allowed': submitLoading }" class="px-8 py-3 bg-gradient-to-r from-healing-500 to-healing-600 text-white font-bold rounded-xl shadow-lg shadow-healing-500/30 hover:shadow-healing-500/50 transform hover:scale-105 transition-all">{{ submitLoading ? '正在提交...' : '提交评估' }}</button>
                <button v-else @click="nextQuestion" class="px-8 py-3 bg-rock-800 text-white font-bold rounded-xl shadow-lg shadow-rock-800/20 hover:bg-rock-900 hover:scale-105 transition-all" :disabled="answers[currentQuestion.id] === undefined" :class="{ 'opacity-50 cursor-not-allowed': answers[currentQuestion.id] === undefined }">下一题 →</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-else-if="viewMode === 'DONE'" class="w-full">
        <div class="glass-card p-8 rounded-3xl shadow-xl flex flex-col items-center text-center">
          <div class="mb-4">
            <CheckCircle :size="48" class="text-emerald-600" />
          </div>
          <h2 class="text-xl font-bold text-rock-800 mb-2">测评已完成</h2>
          <p class="text-rock-600 mb-6">您的状态报告已生成</p>
          <div class="flex items-center gap-3">
             <button class="px-4 py-2 rounded-xl border border-cream-200 text-rock-600 bg-white hover:bg-cream-50" @click="backToScaleList">返回测评中心</button>
            <button class="px-4 py-2 rounded-xl bg-healing-500 text-white hover:bg-healing-600 shadow-lg shadow-healing-500/20" @click="viewReport">查看详情报告</button>
          </div>
        </div>
      </div>

      <div v-else class="py-20 flex justify-center">
        <el-empty description="暂无测评数据，请稍后再试" :image-size="200">
             <el-button type="primary" class="!bg-healing-500 !border-healing-500" @click="loadQuestions" v-if="viewMode === 'QUESTION'">重新加载</el-button>
        </el-empty>
      </div>
    </div>
  </div>
</template>

<style scoped>
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}
.animate-blob { animation: blob 7s infinite; }
.animation-delay-2000 { animation-delay: 2s; }

/* === 🚑 紧急修复：手动定义治愈系主题色 === */
.bg-cream-100 { background-color: #F6F4F1 !important; }
.bg-cream-50 { background-color: #FBF9F7 !important; }
.bg-cream-200 { background-color: #EBE6E0 !important; }

.bg-healing-500 { background-color: #6B9080 !important; }
.bg-healing-600 { background-color: #557366 !important; }
.bg-healing-200 { background-color: #C2DFCE !important; }
.bg-healing-100 { background-color: #E1EFE9 !important; }
.bg-healing-50 { background-color: #F0F7F4 !important; }
.text-healing-600 { color: #557366 !important; }
.border-healing-100 { border-color: #E1EFE9 !important; }
.border-healing-200 { border-color: #C2DFCE !important; }
.border-healing-500 { border-color: #6B9080 !important; }

.bg-clay-200 { background-color: #F3D1C9 !important; }
.text-clay-500 { color: #E07A5F !important; }

.text-rock-800 { color: #4A4E69 !important; }
.text-rock-600 { color: #7B7B8D !important; }
.text-rock-500 { color: #8F8F9D !important; }
.text-rock-400 { color: #A7A7B3 !important; }
.bg-rock-800 { background-color: #4A4E69 !important; }
.bg-rock-900 { background-color: #22223B !important; }

.border-cream-200 { border-color: #EBE6E0 !important; }

.shadow-healing-500\/10 { box-shadow: 0 4px 6px -1px rgba(107, 144, 128, 0.1), 0 2px 4px -1px rgba(107, 144, 128, 0.06) !important; }
.shadow-healing-500\/20 { box-shadow: 0 10px 15px -3px rgba(107, 144, 128, 0.2), 0 4px 6px -2px rgba(107, 144, 128, 0.05) !important; }
.shadow-healing-500\/30 { box-shadow: 0 20px 25px -5px rgba(107, 144, 128, 0.3) !important; }

.fade-up { animation: fadeUp 0.6s ease-out both; }
@keyframes fadeUp { 
  from { opacity: 0; transform: translateY(20px); } 
  to { opacity: 1; transform: translateY(0); } 
}

/* 覆盖 Element Select 以匹配主题 */
:deep(.el-input__wrapper) {
  background-color: white !important;
  border-radius: 12px !important;
  box-shadow: 0 0 0 1px #EBE6E0 !important; /* cream-200 */
}
:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #6B9080 !important; /* healing-500 */
}
:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px #6B9080 !important; /* healing-500 */
}
</style>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useUserStore } from '@/stores/user'
import axios from 'axios'
import { useRouter, useRoute, onBeforeRouteLeave } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { CheckCircle } from 'lucide-vue-next'

type Option = { label: string; score: number }
type Question = { id: number; content: string; options: Option[]; dimension?: string }

const router = useRouter()
const route = useRoute()
const userStore = useUserStore();
userStore.load()
const userName = computed(() => userStore.user?.realName || userStore.user?.username || '测试用户')
const avatarUrl = computed(() => `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(userStore.user?.username || 'user')}`)
const loading = ref(true)
const questions = ref<Question[]>([])
const answers = ref<Record<number, number>>({})
const currentQuestionIndex = ref(0)
const submitLoading = ref(false)
const scales = ref<Array<{ id: number; name: string; description?: string }>>([])
const currentScaleId = ref<number | null>(null)
const currentScaleName = computed(() => {
  const s = scales.value.find(s => s.id === currentScaleId.value)
  return s?.name || ''
})
const targetUserId = ref<number | null>(null)
const targetUserName = ref<string | null>(null)
const role = computed(() => userStore.user?.role || JSON.parse(localStorage.getItem('pg_user') || 'null')?.role || 'ROLE_CLIENT')
const assessorName = computed(() => userStore.user?.realName || userStore.user?.username || 'Admin')
const targetNamePlain = computed(() => (targetUserName.value || '').split('(')[0].trim() || '来访者')
const profileAvatarUrl = computed(() => `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(targetNamePlain.value || 'patient')}`)
const ratingOptions = [
  { score: 0, label: '0分 - 不符合 (No)' },
  { score: 1, label: '1分 - 部分符合 (Maybe)' },
  { score: 2, label: '2分 - 完全符合 (Yes)' }
]
const viewMode = ref<'LIST' | 'QUESTION' | 'DONE' | 'SCALE_LIST'>('LIST')
const lastResultId = ref<number | null>(null)
const lastRiskLevel = ref<string>('')
const lastRiskLabel = computed(() => lastRiskLevel.value === 'HIGH' ? '重点关注' : (lastRiskLevel.value === 'MEDIUM' ? '一般关注' : '安心状态'))
type PrisonerCard = { id: number; name: string; prisonerId: string; status: 'Pending' | 'Archived'; simulated?: boolean }
const prisonerList = ref<PrisonerCard[]>([])
const assessedIds = ref<number[]>(JSON.parse(localStorage.getItem('assessed_ids') || '[]'))
const realCount = computed(() => prisonerList.value.filter(p => !p.simulated).length)
const simCount = computed(() => prisonerList.value.filter(p => p.simulated).length)

// === P0 Improvement: Auto-Save Logic ===
const STORAGE_KEY_PREFIX = 'pg_assessment_progress_'
const storageKey = computed(() => {
    // Unique key per user and scale
    const uid = userStore.user?.id || 'guest'
    const sid = currentScaleId.value || 'unknown'
    const tid = targetUserId.value || uid // If assessing someone else
    return `${STORAGE_KEY_PREFIX}${uid}_${tid}_${sid}`
})

// Load saved progress
function loadProgress() {
    if (!storageKey.value) return
    const saved = localStorage.getItem(storageKey.value)
    if (saved) {
        try {
            const parsed = JSON.parse(saved)
            if (parsed.answers && Object.keys(parsed.answers).length > 0) {
                answers.value = parsed.answers || {}
                currentQuestionIndex.value = parsed.currentIndex || 0
                ElMessage.info('已为您恢复上次未完成的进度')
            }
        } catch(e) { console.error('Failed to load progress', e) }
    }
}

// Watch changes and save
watch([answers, currentQuestionIndex], () => {
    if (viewMode.value === 'QUESTION' && currentScaleId.value) {
        localStorage.setItem(storageKey.value, JSON.stringify({
            answers: answers.value,
            currentIndex: currentQuestionIndex.value,
            timestamp: Date.now()
        }))
    }
}, { deep: true })

function clearProgress() {
    if (storageKey.value) localStorage.removeItem(storageKey.value)
}

async function fetchPrisoners() {
  try {
    const res = await axios.get('/api/users', { params: { role: 'ROLE_CLIENT' } })
    const base = (res.data || []).map((u: any) => ({
      id: u.id,
      name: u.realName || u.username,
      prisonerId: String(u.id),
      status: assessedIds.value.includes(u.id) ? 'Archived' : 'Pending'
    }))
    prisonerList.value = base
  } catch (e: any) {
    console.error('Failed to fetch prisoners', e)
    ElMessage.error('加载来访者数据失败')
  }
}

const currentQuestion = computed(() => questions.value[currentQuestionIndex.value])
const isLastQuestion = computed(() => currentQuestionIndex.value === questions.value.length - 1)
const dimensionLabel = computed(() => {
  const c = currentQuestion.value?.content || ''
  const m = c.match(/维度:\s*([^，\s)]+)/)
  return m?.[1] || '综合'
})

// === P1 Improvement: Exit Confirmation ===
const hasUnsavedChanges = computed(() => {
    return viewMode.value === 'QUESTION' && Object.keys(answers.value).length > 0 && !lastResultId.value
})

const confirmExit = async () => {
    if (!hasUnsavedChanges.value) return true
    try {
        await ElMessageBox.confirm(
            '当前测评仍在进行中，确定要离开吗？虽然系统会自动保存进度，但建议您完成当前测评。',
            '中断测评确认',
            {
                confirmButtonText: '确定离开',
                cancelButtonText: '继续测评',
                type: 'warning'
            }
        )
        return true
    } catch {
        return false
    }
}

onBeforeRouteLeave(async (to, from, next) => {
    if (await confirmExit()) {
        next()
    } else {
        next(false)
    }
})

onMounted(async () => {
  try {
    const { data } = await axios.get('/api/scales')
    scales.value = (data || []).map((s: any) => ({ 
      id: s.id, 
      name: s.name,
      // 如果后端没有返回 description，这里可以给个默认值或者根据 id 判断
      description: s.description || (s.name.includes('PCL') ? '用于评估个体心理状态的专业量表（修订版）' : '综合心理健康症状自评量表')
    }))
  } catch {}

  if (role.value === 'ROLE_CLIENT') {
    targetUserId.value = userStore.user?.id || null
    targetUserName.value = userStore.user?.realName || userStore.user?.username || null
    loading.value = false
    viewMode.value = 'SCALE_LIST' 
  } else {
    // Counselor
    const qTargetId = route.query.targetId
    if (qTargetId) {
      targetUserId.value = Number(qTargetId)
      targetUserName.value = String(route.query.targetName || '未知对象')
      viewMode.value = 'QUESTION'
      await ensureScaleThenLoad()
    } else {
      loading.value = false
      viewMode.value = 'LIST'
      fetchPrisoners()
    }
  }
})

async function loadQuestions() {
  loading.value = true
  try {
    let res
    if (currentScaleId.value) {
      res = await axios.get(`/api/scales/${currentScaleId.value}/questions`)
    } else {
      res = await axios.get('/api/questions')
    }
    questions.value = res.data
    // Load progress after questions are loaded
    loadProgress()
  } catch (error: any) {
    ElMessage.error('加载题目失败: ' + (error.response?.data?.message || error.message))
  } finally {
    loading.value = false
  }
}

async function ensureScaleThenLoad() {
  if (!currentScaleId.value) {
    if (scales.value.length) currentScaleId.value = scales.value[0].id
    else {
      ElMessage.warning('尚未配置量表，请先在量表管理中创建')
      return
    }
  }
  await loadQuestions()
}

async function startAssessment(p: PrisonerCard) {
  if (p.simulated) {
    ElMessage.warning('模拟数据不可发起评估，请选择真实来访者')
    return
  }
  targetUserId.value = p.id
  targetUserName.value = `${p.name} (${p.prisonerId})`
  viewMode.value = 'QUESTION'
  await ensureScaleThenLoad()
}

async function startClientAssessment(scaleId: number) {
  currentScaleId.value = scaleId
  viewMode.value = 'QUESTION'
  answers.value = {}
  currentQuestionIndex.value = 0
  await loadQuestions()
}

async function backToList() {
  if (await confirmExit()) {
      if (route.query.targetId) {
        router.push('/users')
      } else {
        questions.value = []
        answers.value = {}
        currentQuestionIndex.value = 0
        viewMode.value = 'LIST'
        fetchPrisoners()
      }
  }
}

async function backToScaleList() {
  if (await confirmExit()) {
      viewMode.value = 'SCALE_LIST'
      currentScaleId.value = null
      questions.value = []
      answers.value = {}
  }
}

const handleAnswer = (questionId: number, score: number) => {
  answers.value[questionId] = score
}

const nextQuestion = () => {
  if (answers.value[currentQuestion.value.id] !== undefined) {
    currentQuestionIndex.value++
  }
}

const submitAssessment = async () => {
  if (submitLoading.value) return
  if (Object.keys(answers.value).length < questions.value.length) {
    ElMessage.warning('请先完成所有题目')
    return
  }
  try {
    submitLoading.value = true
    const prisonerIdStr = localStorage.getItem('user_id')
    const currentUserId = prisonerIdStr ? parseInt(prisonerIdStr) : (userStore.user?.id || 0)
    if (role.value === 'ROLE_COUNSELOR') {
      if (!targetUserId.value) {
        ElMessage.warning('请先选择评估对象')
        return
      }
    }
    const userId = role.value === 'ROLE_COUNSELOR' ? (targetUserId.value as number) : currentUserId
  if (!currentScaleId.value) { ElMessage.warning('请先选择量表'); return }
  const payload = { userId, scaleId: currentScaleId.value, answers: answers.value }
  const res = await axios.post('/api/assessments', payload)
  lastResultId.value = res.data?.id
  
  // Clear saved progress on success
  clearProgress()

  try {
    const detail = await axios.get(`/api/assessments/${lastResultId.value}`)
    lastRiskLevel.value = detail.data?.riskLevel || ''
  } catch {}
  ElMessage.success('评估已完成')
  if (role.value === 'ROLE_COUNSELOR' && targetUserId.value) {
    if (!assessedIds.value.includes(targetUserId.value)) {
      assessedIds.value = [...assessedIds.value, targetUserId.value]
      localStorage.setItem('assessed_ids', JSON.stringify(assessedIds.value))
    }
  }
  viewMode.value = 'DONE'
  if (role.value === 'ROLE_CLIENT') {
    localStorage.setItem('assessment_done', 'true')
  }
} catch (error: any) {
    ElMessage.error('提交失败: ' + (error.response?.data?.message || '服务器内部错误'))
  } finally {
    submitLoading.value = false
  }
}

function backAfterDone() {
  if (role.value === 'ROLE_COUNSELOR') {
    viewMode.value = 'LIST'
    targetUserId.value = null
    targetUserName.value = null
    answers.value = {}
    currentQuestionIndex.value = 0
    questions.value = []
    fetchPrisoners()
  } else {
    router.replace('/test')
    viewMode.value = 'SCALE_LIST' // Add this for client to go back to list
  }
}

function viewReport() {
  if (lastResultId.value != null) router.push(`/result/${lastResultId.value}`)
}

function handleLogout() {
  localStorage.clear()
  router.push('/login')
}
</script>
 
