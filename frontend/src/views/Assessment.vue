<!-- Last Updated: 2026-01-09 17:03 - Architecture Refactor -->
<template>
  <div class="min-h-screen bg-cream-100 flex flex-col relative overflow-hidden">
    <!-- 背景动画装饰 -->
    <div class="absolute top-1/4 left-0 w-64 h-64 bg-healing-200 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob"></div>
    <div class="absolute top-1/3 right-0 w-64 h-64 bg-clay-200 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob animation-delay-2000"></div>

    <!-- 🌟 全局统一 Header -->
    <div class="header-nav bg-white/90 backdrop-blur-xl px-6 py-4 flex justify-between items-center shadow-sm border-b border-cream-200 z-[100] sticky top-0 transition-all duration-300">
      <div class="flex items-center gap-4">
        <!-- 主返回按钮 -->
        <el-button 
          circle 
          class="!border-cream-200 !text-rock-400 hover:!text-healing-600 hover:!border-healing-200 !w-10 !h-10 hover:!bg-healing-50 transition-all group shadow-sm"
          @click="goHome"
          title="返回主页"
        >
          <template #icon>
            <svg class="w-5 h-5 group-hover:-translate-x-0.5 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
          </template>
        </el-button>

        <div class="flex items-center gap-3">
          <img :src="avatarUrl" class="w-10 h-10 rounded-full border-2 border-white shadow-sm" :alt="userName" />
          <div class="hidden xs:block">
            <p class="font-bold text-rock-800 text-sm leading-tight">{{ userName }}</p>
            <p class="text-[10px] text-rock-400 font-bold uppercase tracking-wider mt-0.5">
              {{ currentScaleName ? `正在测量: ${currentScaleName}` : '心理测评中心' }}
            </p>
          </div>
        </div>
      </div>
      
      <div class="flex items-center gap-3">
        <!-- 咨询师角色：显示历史档案入口 -->
        <button 
          v-if="userStore.isCounselor" 
          @click="$router.push('/history')"
          class="px-5 py-2 rounded-xl flex items-center gap-2 text-sm font-bold text-rock-600 bg-white border border-cream-200 hover:border-healing-400 hover:text-healing-600 transition-all shadow-sm"
        >
          <History :size="16" />
          <span class="hidden md:inline">历史记录</span>
        </button>
        <!-- 来访者角色：显示在线状态 -->
        <div v-else class="hidden xs:flex items-center gap-2 px-3 py-1.5 bg-healing-50 rounded-lg text-healing-600 text-xs font-bold border border-healing-100">
          <span class="w-2 h-2 rounded-full bg-healing-500 animate-pulse"></span>
          <span>系统在线</span>
        </div>
      </div>
    </div>

    <!-- 主内容区 -->
    <div class="flex-1 flex flex-col items-center justify-center p-6 max-w-5xl mx-auto w-full relative z-0">
      
      <!-- 模式 1: 量表列表 -->
      <ScaleSelection 
        v-if="viewMode === 'SCALE_LIST'"
        :scales="scales"
        @select="startClientAssessment"
        @back="goHome"
      />

      <!-- 模式 2: 来访者清单 (咨询师初始界面 - 暂保留在父组件逻辑或简化为列表显示) -->
      <!-- 咨询师选人逻辑稍微特殊，这里我们将其简化为直接复用 ScaleSelection 或自定义列表，为了架构统一，这里假设咨询师已选定人或直接通过 history 进入，
           或者我们保留一个简单的列表视图作为 'LIST' 模式。由于 Prompt 重点是拆分 Questionnaire，这里保留原有的 LIST 模式逻辑，但不封装成大组件以避免过度工程化(或者可以封装一个 simple list) 
           为了符合 instruction 的 '降低复杂度'，我们将 prisonerList 相关的逻辑也尽量简化，
           但鉴于 prisonerList 渲染逻辑简单，直接保留在本文件或封装成 PrisonerSelection.vue 均可。
           这里为了严格遵守 '子组件化'，我们假设 'LIST' 视图逻辑较少，直接在此保留，或者如果太长就封装。
           **决定：直接渲染 Prisoner List 部分，因为这部分不复杂。**
      -->
      <div v-else-if="viewMode === 'LIST'" class="w-full">
        <div class="mb-8">
           <h2 class="text-2xl font-bold text-rock-800 mb-2">待评估列表</h2>
           <p class="text-rock-500 text-sm">请选择评估对象开始临床访谈录入</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="p in prisonerList" :key="p.id" class="group bg-white p-6 rounded-[2rem] border border-cream-200 shadow-sm transition-all hover:shadow-xl hover:shadow-healing-500/5">
            <div class="flex items-center gap-4 mb-6">
              <img :src="`https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(p.name)}&backgroundColor=e1efe9`" class="w-14 h-14 rounded-2xl border-2 border-cream-50 bg-cream-50" :alt="p.name" />
               <div>
                  <div class="text-lg font-bold text-rock-800">{{ p.name }}</div>
                  <div class="text-[10px] font-mono text-rock-400 bg-cream-50 px-2 rounded mt-1">ID: {{ p.prisonerId }}</div>
               </div>
            </div>
            <button class="w-full py-3 text-sm font-bold rounded-xl text-white bg-rock-800 hover:bg-rock-900 transition-all" @click="startAssessment(p)">开始录入</button>
          </div>
        </div>
      </div>

      <!-- 模式 3: 答题中 (使用子组件) -->
      <QuestionCard 
        v-else-if="viewMode === 'QUESTION'"
        :loading="loading"
        :question="currentQuestion"
        :options="currentQuestionOptions"
        :index="currentQuestionIndex"
        :total="questions.length"
        :answer="answers[currentQuestion?.id]"
        :scale-name="currentScaleName"
        :submit-loading="submitLoading"
        :highlight-missing="highlightMissing"
        :role-info="{
           role: role,
           targetName: targetNamePlain,
           targetId: targetUserId,
           avatar: profileAvatarUrl
        }"
        :scale-list="scales"
        :current-scale-id="currentScaleId"
        @answer="handleAnswer"
        @next="nextQuestion"
        @prev="currentQuestionIndex--"
        @submit="submitAssessment"
        @back-list="backToList"
        @back-scale-list="backToScaleList"
        @change-scale="handleSwitchScale"
        @back-home="goHome"
      />

      <!-- 模式 4: 完成/结果页 (使用子组件) -->
      <AssessmentResult 
        v-else-if="viewMode === 'DONE'"
        :risk-level="lastRiskLevel"
        @back="backAfterDone"
        @view-report="viewReport"
        @contact="contactCounselor"
      />

      <!-- 容错模式 -->
      <div v-else class="py-20 text-center">
         <el-empty description="无法识别当前的视图模式" :image-size="200">
            <el-button type="primary" class="!bg-healing-500 !border-healing-500" @click="goHome">强制返回首页</el-button>
         </el-empty>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useUserStore } from '@/stores/user'
import axios from 'axios'
import { useRouter, useRoute, onBeforeRouteLeave } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { History } from 'lucide-vue-next'

// 子组件
import ScaleSelection from '@/components/assessment/ScaleSelection.vue'
import QuestionCard from '@/components/assessment/QuestionCard.vue'
import AssessmentResult from '@/components/assessment/AssessmentResult.vue'

type Option = { label: string; score: number }
type Question = { id: number; content: string; options: Option[]; dimension?: string }

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
userStore.load()

// 用户信息
const userName = computed(() => userStore.user?.realName || userStore.user?.username || '测试用户')
const avatarUrl = computed(() => `https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(userStore.user?.username || 'user')}&backgroundColor=e1efe9`)
const role = computed(() => userStore.isCounselor ? 'ROLE_COUNSELOR' : 'ROLE_CLIENT')

// 状态
const loading = ref(true)
const questions = ref<Question[]>([])
const answers = ref<Record<number, number>>({})
const currentQuestionIndex = ref(0)
const submitLoading = ref(false)
const highlightMissing = ref(false)
const scales = ref<Array<{ id: number; name: string; description?: string }>>([])
const currentScaleId = ref<number | null>(null)
const viewMode = ref<'LIST' | 'QUESTION' | 'DONE' | 'SCALE_LIST'>(
  userStore.isCounselor ? 'LIST' : 'SCALE_LIST'
)

// 测评对象信息 (咨询师模式)
const targetUserId = ref<number | null>(null)
const targetUserName = ref<string | null>(null)
const targetNamePlain = computed(() => (targetUserName.value || '').split('(')[0].trim() || '来访者')
const profileAvatarUrl = computed(() => `https://api.dicebear.com/7.x/notionists/svg?seed=${encodeURIComponent(targetNamePlain.value || 'patient')}&backgroundColor=e1efe9`)

// 结果状态
const lastResultId = ref<number | null>(null)
const lastRiskLevel = ref<string>('')

// 咨询师专用列表数据
type PrisonerCard = { id: number; name: string; prisonerId: string; status: 'Pending' | 'Archived'; simulated?: boolean }
const prisonerList = ref<PrisonerCard[]>([])
// eslint-disable-next-line @typescript-eslint/no-unused-vars
const assessedIds = ref<number[]>(JSON.parse(localStorage.getItem('assessed_ids') || '[]'))

// 计算属性
const currentScaleName = computed(() => scales.value.find(s => s.id === currentScaleId.value)?.name || '')
const currentQuestion = computed(() => questions.value[currentQuestionIndex.value])
// 动态获取当前题目的选项（优先使用数据库配置，回退到默认选项）
const currentQuestionOptions = computed(() => {
  const q = currentQuestion.value
  if (q?.options && Array.isArray(q.options) && q.options.length > 0) {
    return q.options
  }
  return [
    { score: 0, label: '0分 - 不符合 (No)' },
    { score: 1, label: '1分 - 部分符合 (Maybe)' },
    { score: 2, label: '2分 - 完全符合 (Yes)' }
  ]
})

// === 自动保存逻辑 ===
const STORAGE_KEY_PREFIX = 'pg_assessment_progress_'
const storageKey = computed(() => {
    const uid = userStore.user?.id || 'guest'
    const sid = currentScaleId.value || 'unknown'
    const tid = targetUserId.value || uid
    return `${STORAGE_KEY_PREFIX}${uid}_${tid}_${sid}`
})

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

// === 导航守卫 ===
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

// === 初始化 ===
onMounted(async () => {
  try {
    const scaleType = role.value === 'ROLE_CLIENT' ? 'SELF' : 'OBSERVER'
    const { data } = await axios.get('/api/scales', { params: { type: scaleType } })
    scales.value = (data || []).map((s: any) => ({ 
      id: s.id, 
      name: s.name,
      description: s.description
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

// === 业务逻辑方法 ===
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
    ElMessage.error('加载来访者数据失败')
  }
}

async function loadQuestions() {
  loading.value = true
  try {
    const url = currentScaleId.value ? `/api/scales/${currentScaleId.value}/questions` : '/api/questions'
    const res = await axios.get(url)
    questions.value = res.data
    // Load progress after questions are loaded
    loadProgress()
  } catch (error: any) {
    ElMessage.error('加载题目失败')
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

// 切换量表
async function handleSwitchScale(id: number) {
    if (id === currentScaleId.value) return
    currentScaleId.value = id
    answers.value = {}
    currentQuestionIndex.value = 0
    await loadQuestions()
}

async function startAssessment(p: PrisonerCard) {
  if (p.simulated) {
    ElMessage.warning('模拟数据不可发起评估')
    return
  }
  targetUserId.value = p.id
  targetUserName.value = `${p.name} (${p.prisonerId})`
  viewMode.value = 'QUESTION'
  await ensureScaleThenLoad()
}

async function startClientAssessment(scaleId: number) {
  try {
    await ElMessageBox.confirm(
      '本测评结果仅供心理健康状态参考，不能替代专业医疗机构的临床诊断。\n\n' +
      '测评结果将严格保密，仅限授权咨询师查看。\n\n' +
      '如果您在答题过程中感到严重不适，请立即停止测评并寻求专业帮助。',
      '测评知情同意书',
      {
        confirmButtonText: '我已阅读并同意',
        cancelButtonText: '取消',
        type: 'info',
        customClass: 'informed-consent-dialog',
        confirmButtonClass: '!bg-healing-500 !border-healing-500',
        center: true
      }
    )
    
    currentScaleId.value = scaleId
    await loadQuestions()
    if (questions.value.length === 0) {
        ElMessage.warning('该量表尚未配置题目，请选择其他量表')
        return
    }
    answers.value = {}
    currentQuestionIndex.value = 0
    viewMode.value = 'QUESTION'
  } catch {
    // cancel
  }
}

async function backToList() {
  if (await confirmExit()) {
      if (route.query.targetId) {
        router.push('/users')
      } else {
        resetState()
        viewMode.value = 'LIST'
        fetchPrisoners()
      }
  }
}

async function backToScaleList() {
  if (await confirmExit()) {
      viewMode.value = 'SCALE_LIST'
      resetState()
  }
}

async function goHome() {
  if (await confirmExit()) {
    router.push(role.value === 'ROLE_COUNSELOR' ? '/dashboard' : '/client-dashboard')
  }
}

function resetState() {
    currentScaleId.value = null
    questions.value = []
    answers.value = {}
    currentQuestionIndex.value = 0
}

const handleAnswer = (questionId: number, score: number) => {
  answers.value[questionId] = score
  // 自动下一题体验优化：如果是单选且非最后一题，可考虑延迟跳转，但考虑用户修改，这里仅选中
}

const nextQuestion = () => {
  if (answers.value[currentQuestion.value.id] !== undefined) {
    currentQuestionIndex.value++
  }
}

const submitAssessment = async () => {
  if (submitLoading.value) return

  // ===== 防漏答拦截算法 =====
  // 遍历答题字典，收集所有未作答题目
  const unansweredQuestions = questions.value
    .map((q, idx) => ({ question: q, index: idx }))
    .filter(item => answers.value[item.question.id] === undefined)

  if (unansweredQuestions.length > 0) {
    const firstMissing = unansweredQuestions[0]
    // 自动跳转到第一道漏答题目
    currentQuestionIndex.value = firstMissing.index
    // 触发高亮闪烁动画（2秒后自动消除）
    highlightMissing.value = true
    setTimeout(() => { highlightMissing.value = false }, 2000)

    ElMessage.warning({
      message: `还有 ${unansweredQuestions.length} 道题目未作答，已为您定位到第 ${firstMissing.index + 1} 题`,
      duration: 3000
    })
    return  // 阻止网络请求发出，防止脏数据污染后端算分引擎
  }
  // ===== 防漏答拦截结束 =====

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
  
    clearProgress()

    try {
        const detail = await axios.get(`/api/assessments/${lastResultId.value}`)
        lastRiskLevel.value = detail.data?.riskLevel || ''
    } catch {}
    
    ElMessage.success('评估已完成')
    if (role.value === 'ROLE_COUNSELOR' && targetUserId.value) {
        if (!assessedIds.value.includes(targetUserId.value)) {
            assessedIds.value.push(targetUserId.value)
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
    resetState()
    fetchPrisoners()
  } else {
    // client
    viewMode.value = 'SCALE_LIST'
    resetState()
  }
}

function viewReport() {
  if (lastResultId.value != null) router.push(`/result/${lastResultId.value}`)
}

function contactCounselor() {
  ElMessage.info({
    message: '正在为您连接在线咨询师，请稍候...',
    duration: 2000
  })
  setTimeout(() => {
    router.push('/users')
  }, 2000)
}
</script>

<style scoped>
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}
.animate-blob { animation: blob 7s infinite; }
.animation-delay-2000 { animation-delay: 2s; }

/* 覆盖 Element Select 以匹配主题 */
:deep(.el-input__wrapper) {
  background-color: white !important;
  border-radius: 12px !important;
  box-shadow: 0 0 0 1px #EBE6E0 !important;
}
:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #6B9080 !important;
}
:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px #6B9080 !important;
}
</style>
 
