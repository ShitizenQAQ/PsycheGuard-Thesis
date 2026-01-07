<template>
  <div class="p-6 space-y-8 fade-up">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white/50 p-5">
      <div class="flex-1 max-w-lg relative">
        <input 
          v-model="search" 
          type="text" 
          placeholder="🔍 搜索姓名、编号..." 
          class="w-full pl-5 pr-4 py-3 rounded-xl border border-slate-200 focus:outline-none focus:ring-2 focus:ring-blue-500 bg-white/60 transition-all shadow-inner" 
        />
      </div>
      <div class="flex items-center gap-3 w-full md:w-auto">
        <select 
          v-model="risk" 
          class="px-4 py-3 rounded-xl border border-slate-200 bg-white/60 focus:outline-none focus:ring-2 focus:ring-blue-500 cursor-pointer shadow-sm w-full md:w-auto"
        >
          <option value="ALL">📋 全部状态</option>
          <option value="LOW">🟢 低风险</option>
          <option value="MEDIUM">🟡 中风险</option>
          <option value="HIGH">🔴 高风险</option>
        </select>
        <button 
          @click="newVisible=true" 
          class="px-6 py-3 rounded-xl bg-slate-900 text-white font-bold shadow-lg shadow-slate-900/20 hover:bg-slate-800 hover:scale-105 active:scale-95 transition-all w-full md:w-auto whitespace-nowrap flex items-center justify-center gap-2"
        >
          <span>+ 新建档案</span>
        </button>
      </div>
    </div>

    <div v-if="filtered.length === 0" class="flex flex-col items-center justify-center py-20 bg-white/40 backdrop-blur-sm rounded-3xl border border-white/50">
      <div class="text-6xl mb-4">👻</div>
      <p class="text-slate-500 font-medium">暂无符合条件的来访者</p>
    </div>

    <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      <div 
        v-for="u in filtered" 
        :key="u.id" 
        class="group relative bg-white/60 backdrop-blur-md rounded-[2rem] p-6 border border-white/60 shadow-sm transition-all duration-300 hover:-translate-y-2 hover:shadow-xl hover:bg-white/90"
      >
        <div class="absolute top-4 right-4 z-10 opacity-0 group-hover:opacity-100 transition-opacity duration-200">
          <el-dropdown v-if="isCounselor" trigger="click" @command="(cmd: string) => onCardCommand(cmd, u)">
            <button class="w-8 h-8 rounded-full bg-white shadow-md flex items-center justify-center text-slate-400 hover:text-blue-600 transition-colors">
              <MoreHorizontal :size="18" />
            </button>
            <template #dropdown>
              <el-dropdown-menu class="!rounded-xl !p-2">
                <el-dropdown-item command="edit">✏️ 编辑信息</el-dropdown-item>
                <el-dropdown-item command="profile">📂 查看档案</el-dropdown-item>
                <el-dropdown-item command="archive">{{ u.archived ? '📤 取消归档' : '📥 归档' }}</el-dropdown-item>
                <el-dropdown-item divided command="delete"><span class="text-rose-500">🗑️ 删除来访者</span></el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>

        <div class="flex flex-col items-center text-center mt-2">
          <div class="relative mb-5 group-hover:scale-110 transition-transform duration-300">
            <img :src="u.avatar" class="w-24 h-24 rounded-full border-4 border-white shadow-lg bg-slate-50 object-cover" :alt="u.realName" />
            
            <div 
              class="absolute bottom-1 right-1 w-7 h-7 rounded-full border-2 border-white flex items-center justify-center shadow-sm"
              :class="riskInfo(u.lastRiskLevel).bg"
            >
              <span class="text-[10px] font-black" :class="riskInfo(u.lastRiskLevel).color">
                {{ riskInfo(u.lastRiskLevel).labelShort }}
              </span>
            </div>
          </div>

          <h3 class="text-xl font-bold text-slate-800 mb-1 tracking-tight">{{ u.realName }}</h3>
          <div class="flex items-center gap-2 mb-4">
            <span class="text-xs font-mono text-slate-400 bg-slate-100 px-2 py-0.5 rounded-md border border-slate-200">ID: {{ u.prisonId }}</span>
            <span v-if="u.role === 'ROLE_COUNSELOR'" class="text-[10px] font-bold bg-blue-100 text-blue-600 px-1.5 py-0.5 rounded">咨询师</span>
          </div>

          <div class="flex flex-wrap justify-center gap-2 mb-6 w-full px-2">
            <span v-if="u.archived" class="text-xs px-3 py-1 rounded-full bg-slate-100 text-slate-500 border border-slate-200 font-medium">📥 已归档</span>
            <span v-else class="text-xs px-3 py-1 rounded-full bg-blue-50 text-blue-600 border border-blue-100 font-medium animate-pulse">⚡ 待评估</span>
            
            <span class="text-xs px-3 py-1 rounded-full font-bold border" :class="[riskInfo(u.lastRiskLevel).badge, riskInfo(u.lastRiskLevel).borderColor]">
              {{ riskInfo(u.lastRiskLevel).label }}
            </span>
          </div>

          <div class="grid grid-cols-2 gap-3 w-full mt-auto">
            <button 
              class="py-2.5 text-sm font-bold text-slate-600 bg-slate-50 hover:bg-slate-100 hover:text-slate-800 rounded-xl border border-slate-200 transition-colors"
              @click="viewProfile(u)"
            >
              查看档案
            </button>
            <button 
              v-if="u.role === 'ROLE_CLIENT'"
              class="py-2.5 text-sm font-bold text-white bg-gradient-to-r from-cyan-500 to-blue-500 hover:from-cyan-400 hover:to-blue-400 rounded-xl shadow-md shadow-blue-500/20 transition-all hover:scale-[1.02] active:scale-[0.98]"
              @click="startTest(u)"
            >
              发起测评
            </button>
            <button 
              v-else 
              disabled 
              class="py-2.5 text-sm font-bold text-slate-300 bg-slate-50 rounded-xl border border-slate-100 cursor-not-allowed"
            >
              不可测评
            </button>
          </div>
        </div>
      </div>
    </div>

    <el-dialog v-model="editVisible" title="✏️ 编辑用户信息" width="480px" class="!rounded-2xl">
      <el-form label-position="top" class="mt-2">
        <el-form-item label="真实姓名"><el-input v-model="editForm.realName" class="!rounded-lg" /></el-form-item>
        <el-form-item label="登录账号"><el-input v-model="editForm.username" /></el-form-item>
        <el-form-item label="用户编号"><el-input v-model="editForm.prisonId" /></el-form-item>
        <el-form-item label="系统角色">
          <el-select v-model="editForm.role" class="w-full">
            <el-option label="👨‍⚕️ 咨询师 (管理员)" value="ROLE_COUNSELOR" />
            <el-option label="👤 来访者 (受测者)" value="ROLE_CLIENT" />
          </el-select>
        </el-form-item>
        <el-form-item label="标签 (逗号分隔)">
          <el-input v-model="editTags" placeholder="例如：重点关注, 心理创伤" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="flex justify-end gap-3">
          <el-button @click="editVisible=false" class="!rounded-xl !h-10">取消</el-button>
          <el-button type="primary" @click="saveEdit" class="!rounded-xl !h-10 !px-6">保存修改</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="newVisible" title="✨ 新增用户档案" width="480px" class="!rounded-2xl">
      <el-form label-position="top" class="mt-2">
        <el-form-item label="真实姓名"><el-input v-model="newForm.realName" placeholder="例如：张三" /></el-form-item>
        <el-form-item label="登录账号"><el-input v-model="newForm.username" placeholder="建议使用拼音或编号" /></el-form-item>
        <el-form-item label="系统角色">
          <el-select v-model="newForm.role" class="w-full">
            <el-option label="👨‍⚕️ 咨询师 (管理员)" value="ROLE_COUNSELOR" />
            <el-option label="👤 来访者 (受测者)" value="ROLE_CLIENT" />
          </el-select>
        </el-form-item>
        <el-form-item label="初始密码">
          <el-input v-model="newForm.password" type="password" placeholder="默认: 123456" show-password />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="flex justify-end gap-3">
          <el-button @click="newVisible=false" class="!rounded-xl !h-10">取消</el-button>
          <el-button type="primary" @click="createNewUser" class="!rounded-xl !h-10 !px-6 !bg-slate-900 !border-slate-900">立即创建</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { MoreHorizontal } from 'lucide-vue-next'
import axios from 'axios'

type Role = 'ROLE_COUNSELOR' | 'ROLE_CLIENT'
type RiskLevel = 'LOW' | 'MEDIUM' | 'HIGH'

type UserData = {
  id: number
  username: string
  realName: string
  role: Role
  avatar?: string
  prisonId?: string
  lastRiskLevel?: RiskLevel
  archived?: boolean
}

const ALL_USERS = ref<UserData[]>([])
const search = ref('')
const risk = ref<'ALL' | RiskLevel>('ALL')
const router = useRouter()
const route = useRoute()
const isCounselor = computed(() => (localStorage.getItem('user_role') || '') === 'ROLE_COUNSELOR')

const filtered = computed(() => {
  const q = search.value.trim().toLowerCase()
  return ALL_USERS.value.filter(u => {
    const matchesText = !q || u.realName.toLowerCase().includes(q) || (u.prisonId || '').toLowerCase().includes(q) || u.username.toLowerCase().includes(q)
    const matchesRisk = risk.value === 'ALL' || (u.lastRiskLevel || 'LOW') === risk.value
    return matchesText && matchesRisk
  })
})

function riskInfo(level: RiskLevel | undefined) {
  const l: RiskLevel = level || 'LOW'
  if (l === 'HIGH') return { label: '高关注', labelShort: '高', color: 'text-rose-600', bg: 'bg-rose-50', badge: 'bg-rose-100 text-rose-700', borderColor: 'border-rose-200' }
  if (l === 'MEDIUM') return { label: '中关注', labelShort: '中', color: 'text-amber-600', bg: 'bg-amber-50', badge: 'bg-amber-100 text-amber-700', borderColor: 'border-amber-200' }
  return { label: '低关注', labelShort: '低', color: 'text-emerald-600', bg: 'bg-emerald-50', badge: 'bg-emerald-100 text-emerald-700', borderColor: 'border-emerald-200' }
}

function mapBackend(u: any): UserData {
  return {
    id: u.id,
    username: u.username,
    realName: u.realName || u.username,
    role: u.role as Role,
    avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(u.username)}`,
    prisonId: String(u.id),
    lastRiskLevel: (u.lastRiskLevel || 'LOW'),
    archived: false
  }
}

onMounted(async () => {
  try {
    const res = await axios.get('/api/users')
    ALL_USERS.value = (res.data || []).map(mapBackend)
    const assessed = JSON.parse(localStorage.getItem('assessed_ids') || '[]') as number[]
    if (Array.isArray(assessed) && assessed.length) {
      ALL_USERS.value = ALL_USERS.value.map(u => ({ ...u, archived: assessed.includes(u.id) || u.archived }))
    }
  } catch (e: any) {
    ElMessage.error('加载用户失败')
    ALL_USERS.value = []
  }
})

onMounted(() => {
  const q = (route.query?.risk as string || '').toUpperCase()
  if (q === 'HIGH' || q === 'MEDIUM' || q === 'LOW') {
    risk.value = q as any
  }
})

const newVisible = ref(false)
const newForm = ref<{ realName: string; username: string; role: Role; password?: string }>({ realName: '', username: '', role: 'ROLE_CLIENT', password: '' })

async function createNewUser() {
  try {
    const payload: any = {
      realName: newForm.value.realName,
      username: newForm.value.username,
      role: newForm.value.role,
      password: newForm.value.password || '123456'
    }
    const res = await axios.post('/api/users', payload)
    ElMessage.success('新建成功')
    newVisible.value = false
    newForm.value = { realName: '', username: '', role: 'ROLE_CLIENT', password: '' }
    const fresh = await axios.get('/api/users')
    ALL_USERS.value = (fresh.data || []).map(mapBackend)
  } catch (e: any) {
    ElMessage.error('新建失败')
  }
}

function viewProfile(u: UserData) {
  router.push('/history')
}

function startTest(u: UserData) {
  if (u.role !== 'ROLE_CLIENT') {
    ElMessage.warning('仅可对来访者发起测评')
    return
  }
  router.push({ path: '/test', query: { targetId: u.id, targetName: u.realName } })
}

const editVisible = ref(false)
const editForm = ref<UserData>({ id: 0, username: '', realName: '', role: 'ROLE_CLIENT', avatar: '', prisonId: '', lastRiskLevel: 'LOW' })
let editingId: number | null = null
const editTags = ref('')

function onCardCommand(cmd: string, u: UserData) {
  if (cmd === 'edit') {
    editingId = u.id
    editForm.value = { ...u }
    editTags.value = ''
    editVisible.value = true
  } else if (cmd === 'archive') {
    const idx = ALL_USERS.value.findIndex(x => x.id === u.id)
    if (idx >= 0) {
      ALL_USERS.value[idx] = { ...ALL_USERS.value[idx], archived: !ALL_USERS.value[idx].archived }
      ElMessage.success(ALL_USERS.value[idx].archived ? '已归档' : '已取消归档')
    }
  } else if (cmd === 'start') {
    startTest(u)
  } else if (cmd === 'profile') {
    viewProfile(u)
  } else if (cmd === 'delete') {
    ElMessageBox.confirm('确认删除该来访者吗？', '警告', { 
      confirmButtonText: '删除', 
      cancelButtonText: '取消', 
      type: 'warning' 
    }).then(async () => {
      try {
        await axios.delete(`/api/users/${u.id}`)
        ALL_USERS.value = ALL_USERS.value.filter(x => x.id !== u.id)
        ElMessage.success('已删除')
      } catch (e: any) {
        ElMessage.error('删除失败')
      }
    }).catch(() => {})
  }
}

async function saveEdit() {
  if (editingId == null) return
  try {
    const tags = editTags.value.split(',').map(s => s.trim()).filter(Boolean)
    const payload: any = { username: editForm.value.username, realName: editForm.value.realName, role: editForm.value.role, tags }
    await axios.put(`/api/users/${editingId}`, payload)
    const fresh = await axios.get('/api/users')
    ALL_USERS.value = (fresh.data || []).map(mapBackend)
    ElMessage.success('保存成功')
  } catch (e: any) {
    ElMessage.error('保存失败')
  }
  editVisible.value = false
}
</script>

<style scoped>
.fade-up { animation: fadeUp 0.5s ease-out both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

/* 覆盖 Element Dialog 样式 */
:deep(.el-dialog) {
  border-radius: 24px;
  overflow: hidden;
}
:deep(.el-dialog__header) {
  padding: 24px;
  margin: 0;
  border-bottom: 1px solid #f1f5f9;
}
:deep(.el-dialog__body) {
  padding: 24px;
}
:deep(.el-dialog__footer) {
  padding: 20px 24px;
  background: #f8fafc;
}
</style>
