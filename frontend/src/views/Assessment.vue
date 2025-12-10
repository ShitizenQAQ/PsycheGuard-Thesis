<template>
  <div class="min-h-screen bg-slate-100 flex flex-col relative overflow-hidden">
    <div class="absolute top-1/4 left-0 w-64 h-64 bg-cyan-300 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob"></div>
    <div class="absolute top-1/3 right-0 w-64 h-64 bg-blue-300 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-2000"></div>

    <div class="bg-white/80 backdrop-blur-md px-6 py-4 flex justify-between items-center shadow-sm z-10 sticky top-0">
      <div class="flex items-center space-x-3">
        <img :src="avatarUrl" class="w-10 h-10 rounded-full border-2 border-white shadow" :alt="userName" />
        <div>
          <p class="font-bold text-slate-800">{{ userName }}</p>
          <p class="text-xs text-slate-500">正在进行 {{ currentScaleName || '请选择量表' }} 测评</p>
        </div>
      </div>
      <button class="px-3 py-1.5 rounded-lg border border-slate-300 bg-white text-slate-700 hover:bg-slate-50" @click="handleLogout">退出</button>
    </div>

    <div class="flex-1 flex flex-col items-center justify-center p-6 max-w-5xl mx-auto w-full relative z-0">
      <div v-if="viewMode === 'LIST'" class="w-full">
        <div class="mb-6">
          <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow p-5 flex items-center justify-between">
            <div>
              <h3 class="text-lg font-bold text-slate-800">选择评估对象</h3>
              <p class="text-sm text-slate-500 mt-1">请从下方在押人员列表中选择一位发起评估</p>
            </div>
            <div class="flex items-center gap-3 text-sm text-slate-600">
              <span class="px-2 py-1 rounded-full bg-slate-100">在押人员总数：{{ prisonerList.length }}</span>
              <span class="px-2 py-1 rounded-full bg-slate-100">真实：{{ realCount }}，模拟：{{ simCount }}</span>
            </div>
          </div>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="p in prisonerList" :key="p.id" class="glass-card group relative p-6 rounded-2xl border border-white shadow-pg">
            <div class="flex items-center gap-4">
              <img :src="`https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(p.name)}`" class="w-14 h-14 rounded-full border-4 border-white shadow-md bg-slate-100" :alt="p.name" />
              <div>
                <div class="text-lg font-bold text-slate-800">{{ p.name }}</div>
                <div class="text-xs font-mono text-slate-500 bg-slate-100 px-2 py-0.5 rounded">ID: {{ p.prisonerId }}</div>
              </div>
            </div>
            <div class="mt-4 flex items-center justify-between">
              <span class="text-xs px-2 py-1 rounded-full" :class="p.simulated ? 'bg-amber-100 text-amber-700' : (p.status === 'Pending' ? 'bg-slate-100 text-slate-600' : 'bg-emerald-100 text-emerald-700')">{{ p.simulated ? '模拟数据' : (p.status === 'Pending' ? '待评估' : '已归档') }}</span>
              <button class="px-3 py-1.5 text-sm rounded-lg bg-slate-800 text-white hover:bg-slate-700" :disabled="p.simulated" :class="{ 'opacity-50 cursor-not-allowed': p.simulated }" @click="startAssessment(p)">开始评估</button>
            </div>
          </div>
        </div>
      </div>
      <div v-else-if="viewMode === 'QUESTION'" class="w-full">
        <div v-if="loading" class="text-center">
          <div class="w-12 h-12 border-4 border-cyan-200 border-t-cyan-600 rounded-full animate-spin mx-auto mb-4"></div>
          <p class="text-slate-500">正在加载试题库...</p>
        </div>

        <div v-else-if="questions.length > 0" class="w-full">
          <div class="mb-8">
            <div class="flex justify-between text-sm font-medium text-slate-500 mb-2">
              <span>当前进度 {{ currentQuestionIndex + 1 }} / {{ questions.length }}</span>
              <span>{{ Math.round(((currentQuestionIndex + 1) / questions.length) * 100) }}%</span>
            </div>
            <div class="h-2 w-full bg-slate-200 rounded-full overflow-hidden">
              <div class="h-full bg-cyan-500 transition-all duration-500 ease-out" :style="{ width: `${((currentQuestionIndex + 1) / questions.length) * 100}%` }"></div>
            </div>
          </div>

          <div class="glass-card p-0 rounded-3xl shadow-xl min-h-[400px] flex flex-col relative transition-all duration-300">
            <div v-if="role === 'DOCTOR'" class="bg-slate-50 border-b border-slate-200 p-6 rounded-t-3xl flex items-center justify-between">
              <div>
                <button class="bg-white border border-slate-300 shadow-sm px-4 py-2 rounded-lg text-slate-700 font-medium text-sm hover:bg-slate-50 hover:text-cyan-600 hover:border-cyan-300 transition-all flex items-center gap-2" @click="backToList">← 返回列表</button>
              </div>
              <div class="flex items-center gap-4">
                <img :src="profileAvatarUrl" class="w-14 h-14 rounded-full border-2 border-white shadow" :alt="targetNamePlain" />
                <div>
                  <div class="text-xl font-bold text-slate-800">{{ targetNamePlain }}</div>
                  <div class="inline-flex items-center text-xs text-slate-600 bg-slate-100 px-2 py-0.5 rounded-full mt-1">ID: {{ targetUserId }}</div>
                  <div class="text-xs text-slate-500 mt-1">正在进行 {{ currentScaleName || '请选择量表' }} 评估</div>
                </div>
              </div>
              <div class="flex items-center gap-4">
                <div class="text-sm text-slate-700">👨‍⚕️ 主评医生: {{ assessorName }}</div>
                <el-select v-model="currentScaleId" placeholder="选择量表" style="width: 220px" @change="loadQuestions">
                  <el-option v-for="s in scales" :key="s.id" :label="s.name" :value="s.id" />
                </el-select>
              </div>
            </div>
            <div v-else class="bg-slate-50 border-b border-slate-200 p-6 rounded-t-3xl">
              <div class="flex items-center justify-between">
                <div class="text-sm text-slate-700">📝 请根据您的真实情况作答</div>
                <el-select v-if="scales.length > 1" v-model="currentScaleId" placeholder="选择量表" style="width: 220px" @change="loadQuestions">
                  <el-option v-for="s in scales" :key="s.id" :label="s.name" :value="s.id" />
                </el-select>
              </div>
            </div>

            <div class="p-8 md:p-12 flex-1 flex flex-col justify-center">
              <span class="inline-block bg-cyan-100 text-cyan-700 text-xs font-bold px-3 py-1 rounded-full mb-4">
                {{ currentQuestion.dimension || dimensionLabel }}
              </span>

              <h2 class="text-2xl md:text-3xl font-bold text-slate-800 mb-10 leading-snug mt-6">
                {{ currentQuestion.content.split('(')[0] }}
                <span class="block text-sm font-normal text-slate-400 mt-2">
                  {{ currentQuestion.content.match(/\((.*?)\)/)?.[1] || '' }}
                </span>
              </h2>

              <div class="text-xs bg-slate-50 text-slate-600 border border-slate-200 rounded-xl p-3 mb-6">
                评分参考：请依据临床观察和访谈记录进行客观评分。
              </div>

              <div class="grid grid-cols-3 gap-3">
                <button
                  v-for="opt in ratingOptions"
                  :key="opt.score"
                  @click="handleAnswer(currentQuestion.id, opt.score)"
                  :class="[
                    'w-full text-center py-2 px-2 rounded-lg border text-xs font-medium transition-colors',
                    answers[currentQuestion.id] === opt.score
                      ? 'bg-blue-600 text-white border-blue-600'
                      : 'border-slate-300 text-slate-700 hover:border-blue-500'
                  ]"
                >
                  {{ opt.label }}
                </button>
              </div>

              <div class="mt-8 flex justify-between items-center pt-6 border-t border-slate-100">
                <button v-if="currentQuestionIndex > 0" @click="currentQuestionIndex--" class="text-slate-400 hover:text-slate-600 font-medium px-4 py-2">上一题</button>
                <div v-else></div>
                <button v-if="isLastQuestion" @click="submitAssessment" :disabled="submitLoading" :class="{ 'opacity-50 cursor-not-allowed': submitLoading }" class="px-8 py-3 bg-gradient-to-r from-cyan-600 to-blue-600 text-white font-bold rounded-xl shadow-lg shadow-cyan-500/30 hover:shadow-cyan-500/50 transform hover:scale-105 transition-all">{{ submitLoading ? '正在提交...' : '提交评估' }}</button>
                <button v-else @click="nextQuestion" class="px-6 py-2 bg-slate-800 text-white rounded-lg hover:bg-slate-700 transition-colors" :disabled="answers[currentQuestion.id] === undefined" :class="{ 'opacity-50 cursor-not-allowed': answers[currentQuestion.id] === undefined }">下一题</button>
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
          <h2 class="text-xl font-bold text-slate-800 mb-2">评估已完成 (Assessment Completed)</h2>
          <p class="text-slate-600 mb-6">评估结果：{{ lastRiskLabel }}</p>
          <div class="flex items-center gap-3">
            <button class="px-4 py-2 rounded-xl border border-slate-300 text-slate-700 bg-white hover:bg-slate-50" @click="backAfterDone">返回列表</button>
            <button class="px-4 py-2 rounded-xl bg-blue-600 text-white hover:bg-blue-700" @click="viewReport">查看详情报告</button>
            <button class="px-4 py-2 rounded-xl bg-slate-800 text-white hover:bg-slate-700" @click="handleLogout">退出</button>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-20">
        <p class="text-slate-400">暂无题目数据</p>
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
</style>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import axios from 'axios'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
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
const scales = ref<Array<{ id: number; name: string }>>([])
const currentScaleId = ref<number | null>(null)
const currentScaleName = computed(() => {
  const s = scales.value.find(s => s.id === currentScaleId.value)
  return s?.name || ''
})
const targetUserId = ref<number | null>(null)
const targetUserName = ref<string | null>(null)
const role = computed(() => userStore.user?.role || JSON.parse(localStorage.getItem('pg_user') || 'null')?.role || 'PRISONER')
const assessorName = computed(() => userStore.user?.realName || userStore.user?.username || 'Dr. Admin')
const targetNamePlain = computed(() => (targetUserName.value || '').split('(')[0].trim() || '在押人员')
const profileAvatarUrl = computed(() => `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(targetNamePlain.value || 'patient')}`)
const ratingOptions = [
  { score: 0, label: '0分 - 不符合 (No)' },
  { score: 1, label: '1分 - 部分符合 (Maybe)' },
  { score: 2, label: '2分 - 完全符合 (Yes)' }
]
const viewMode = ref<'LIST' | 'QUESTION' | 'DONE'>('LIST')
const lastResultId = ref<number | null>(null)
const lastRiskLevel = ref<string>('')
const lastRiskLabel = computed(() => lastRiskLevel.value === 'HIGH' ? '高风险' : (lastRiskLevel.value === 'MEDIUM' ? '中风险' : '低风险'))
type PrisonerCard = { id: number; name: string; prisonerId: string; status: 'Pending' | 'Archived'; simulated?: boolean }
const prisonerList = ref<PrisonerCard[]>([])
const assessedIds = ref<number[]>(JSON.parse(localStorage.getItem('assessed_ids') || '[]'))
const realCount = computed(() => prisonerList.value.filter(p => !p.simulated).length)
const simCount = computed(() => prisonerList.value.filter(p => p.simulated).length)

async function fetchPrisoners() {
  try {
    const res = await axios.get('/api/users', { params: { role: 'PRISONER' } })
    const base = (res.data || []).map((u: any) => ({
      id: u.id,
      name: u.realName || u.username,
      prisonerId: String(u.id),
      status: assessedIds.value.includes(u.id) ? 'Archived' : 'Pending'
    }))
    prisonerList.value = base
  } catch (e: any) {
    console.error('Failed to fetch prisoners', e)
    ElMessage.error('加载在押人员失败: ' + (e.response?.data?.message || e.message))
  }
}

const currentQuestion = computed(() => questions.value[currentQuestionIndex.value])
const isLastQuestion = computed(() => currentQuestionIndex.value === questions.value.length - 1)
const dimensionLabel = computed(() => {
  const c = currentQuestion.value?.content || ''
  const m = c.match(/维度:\s*([^，\s)]+)/)
  return m?.[1] || '综合'
})

onMounted(async () => {
  try {
    const { data } = await axios.get('/api/scales')
    scales.value = (data || []).map((s: any) => ({ id: s.id, name: s.name }))
    if (scales.value.length === 1) currentScaleId.value = scales.value[0].id
  } catch {}
  if (role.value === 'PRISONER') {
    targetUserId.value = userStore.user?.id || null
    targetUserName.value = userStore.user?.realName || userStore.user?.username || null
    if (localStorage.getItem('assessment_done') === 'true') {
      loading.value = false
      viewMode.value = 'DONE'
    } else {
      viewMode.value = 'QUESTION'
      await ensureScaleThenLoad()
    }
  } else {
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
    ElMessage.warning('模拟数据不可发起评估，请选择真实在押人员')
    return
  }
  targetUserId.value = p.id
  targetUserName.value = `${p.name} (${p.prisonerId})`
  viewMode.value = 'QUESTION'
  await ensureScaleThenLoad()
}

function backToList() {
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
    if (role.value === 'DOCTOR') {
      if (!targetUserId.value) {
        ElMessage.warning('请先选择评估对象')
        return
      }
    }
    const userId = role.value === 'DOCTOR' ? (targetUserId.value as number) : currentUserId
  if (!currentScaleId.value) { ElMessage.warning('请先选择量表'); return }
  const payload = { userId, scaleId: currentScaleId.value, answers: answers.value }
  const res = await axios.post('/api/assessments', payload)
  lastResultId.value = res.data?.id
  try {
    const detail = await axios.get(`/api/assessments/${lastResultId.value}`)
    lastRiskLevel.value = detail.data?.riskLevel || ''
  } catch {}
  ElMessage.success('评估已完成')
  if (role.value === 'DOCTOR' && targetUserId.value) {
    if (!assessedIds.value.includes(targetUserId.value)) {
      assessedIds.value = [...assessedIds.value, targetUserId.value]
      localStorage.setItem('assessed_ids', JSON.stringify(assessedIds.value))
    }
  }
  viewMode.value = 'DONE'
  if (role.value === 'PRISONER') {
    localStorage.setItem('assessment_done', 'true')
  }
} catch (error: any) {
    ElMessage.error('提交失败: ' + (error.response?.data?.message || '服务器内部错误'))
  } finally {
    submitLoading.value = false
  }
}

function backAfterDone() {
  if (role.value === 'DOCTOR') {
    viewMode.value = 'LIST'
    targetUserId.value = null
    targetUserName.value = null
    answers.value = {}
    currentQuestionIndex.value = 0
    questions.value = []
    fetchPrisoners()
  } else {
    router.replace('/test')
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
 
