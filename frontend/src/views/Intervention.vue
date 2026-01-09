<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white/50 p-5 flex items-center justify-between">
      <div>
        <h3 class="text-xl font-bold text-slate-800 flex items-center gap-2"><span>🛡️</span> 重点关注干预记录</h3>
        <p class="text-sm text-slate-500 mt-1">记录与跟踪重点关注对象的干预措施与执行状态</p>
      </div>
      <div class="bg-slate-100/50 p-1 rounded-xl flex gap-1">
        <button v-for="tab in tabs" :key="tab.key" @click="setFilter(tab.key)"
          :class="['px-4 py-1.5 rounded-lg text-sm font-medium transition-all', statusFilter === tab.key ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-500 hover:text-slate-700']">
          {{ tab.label }}
        </button>
      </div>
    </div>

    <div class="glass-card p-6 rounded-2xl">
      
      <el-table :data="filteredData" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="档案编号 / Case ID" width="160">
          <template #default="{ row }">
            <span class="font-mono text-rock-700">{{ row.name }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="riskLevel" label="关注等级" width="120" />
        <el-table-column prop="plan" label="干预方案" />
        <el-table-column prop="owner" label="责任人" width="120" />
        <el-table-column prop="time" label="更新时间" width="160" />
        <el-table-column label="状态" width="140">
          <template #default="{ row }">
            <span :class="statusTagClass(row.status)" class="text-xs px-2 py-1 rounded-full">
              {{ statusLabel(row.status) }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="280">
          <template #default="{ row, $index }">
            
            <el-button v-if="row.status==='PENDING'" size="small" type="primary" @click="startIntervention($index)">开始干预</el-button>
            <el-button v-else-if="row.status==='PROCESSING'" size="small" type="success" @click="openUpdate($index)">完成/记录</el-button>
            
            <!-- 编辑按钮：允许任何状态下修改方案 -->
            <el-button size="small" circle @click="openUpdate($index)" title="填写/修改干预方案" class="ml-2">
              <el-icon><Edit /></el-icon>
            </el-button>

            <el-dropdown v-if="!row.simulated" @command="(cmd: string) => changeStatus(row, cmd as Status)" class="ml-2">
              <el-button size="small">更改状态</el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="PENDING">待处理</el-dropdown-item>
                  <el-dropdown-item command="PROCESSING">处理中</el-dropdown-item>
                  <el-dropdown-item command="ARCHIVED">已归档</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <el-dialog 
      v-model="updateVisible" 
      title="填写干预记录" 
      width="520px"
      top="8vh"
      :close-on-click-modal="false"
      class="intervention-dialog"
    >
      <el-form label-position="top">
        <el-form-item label="干预措施">
          <el-input type="textarea" v-model="updateNote" rows="4" placeholder="例如：进行了心理疏导、复测安排等" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="flex justify-end gap-3">
          <el-button @click="updateVisible=false">取消</el-button>
          <el-button type="primary" @click="completeUpdate">完成干预</el-button>
        </div>
      </template>
    </el-dialog>

    <el-dialog v-model="createVisible" title="🛡️ 新建干预任务" width="520px">
      <div class="bg-blue-50 p-3 rounded-lg mb-4 text-sm text-blue-700 flex gap-2 items-center">
        <span>💡</span>
        <span>系统已自动关联高风险用户，请制定初始干预方案。</span>
      </div>
      <el-form label-position="top">
        <el-form-item label="干预对象">
          <el-input v-model="createForm.realName" disabled />
        </el-form-item>
        <el-form-item label="风险等级">
          <el-tag type="danger" effect="dark" v-if="createForm.riskLevel==='HIGH'">高风险 (High Risk)</el-tag>
          <el-tag type="warning" v-else>中风险</el-tag>
        </el-form-item>
        <el-form-item label="初始干预方案">
          <el-input type="textarea" v-model="createForm.plan" rows="4" placeholder="请输入针对该用户的初步干预计划..." />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="createVisible=false">取消</el-button>
        <el-button type="primary" class="!bg-healing-500 !border-healing-500" @click="submitCreate">立即创建任务</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Edit } from '@element-plus/icons-vue'
import axios from 'axios'

type Status = 'PENDING' | 'PROCESSING' | 'ARCHIVED'
type Row = { id: number; name: string; riskLevel: 'HIGH' | 'MEDIUM' | 'LOW'; plan: string; owner: string; time: string; status: Status }
type RowSim = Row & { simulated?: boolean }
const tableData = ref<RowSim[]>([])
const statusFilter = ref<'ALL' | Status>('ALL')
const tabs: { key: 'ALL' | Status; label: string }[] = [
  { key: 'ALL', label: '全部' },
  { key: 'PENDING', label: '待处理' },
  { key: 'PROCESSING', label: '处理中' },
  { key: 'ARCHIVED', label: '已归档' }
]
const filteredData = computed(() => {
  if (statusFilter.value === 'ALL') return tableData.value
  return tableData.value.filter(r => r.status === statusFilter.value)
})
function setFilter(v: 'ALL' | Status) { statusFilter.value = v }

// maskName 函数已移除 - 数据已改为档案编号格式，无需脱敏

const router = useRouter()
function viewResult(row: RowSim) {
  const id = row.id
  router.push({ path: `/result/${id}`, query: { name: row.name } })
}

const updateVisible = ref(false)
const updatingIndex = ref<number | null>(null)
const updateNote = ref('')

function openUpdate(index: number) { updatingIndex.value = index; updateVisible.value = true }

function completeUpdate() {
  if (updatingIndex.value == null) return
  const idx = updatingIndex.value
  const r = tableData.value[idx]
  r.status = 'ARCHIVED'
  r.plan = updateNote.value || r.plan
  r.time = new Date().toISOString().slice(0, 16).replace('T', ' ')
  tableData.value[idx] = { ...r }
  updateVisible.value = false
  updateNote.value = ''
  ElMessage.success('干预记录已更新，状态已归档')
}

function statusLabel(s: Status) { return s === 'PENDING' ? '待处理' : (s === 'PROCESSING' ? '处理中' : '已归档') }
function statusTagClass(s: Status) { return s === 'PENDING' ? 'bg-amber-100 text-amber-700' : (s === 'PROCESSING' ? 'bg-blue-100 text-blue-700' : 'bg-emerald-100 text-emerald-700') }
async function changeStatus(row: RowSim, status: Status) {
  if (row.simulated) return
  try {
    await axios.put(`/api/assessments/${row.id}/status`, { status })
    row.status = status
    row.time = new Date().toLocaleString()
    ElMessage.success('状态已更新')
  } catch (e: any) {
    ElMessage.error(e.response?.data?.message || '更新失败')
  }
}
async function startIntervention(index: number) {
  const r = tableData.value[index]
  await changeStatus(r, 'PROCESSING')
}
async function completeIntervention(index: number) {
  const r = tableData.value[index]
  await changeStatus(r, 'ARCHIVED')
}

onMounted(async () => {
  try {
    const res = await axios.get('/api/assessments/interventions')
    const list: Array<{ id: number; prisonerName: string; createTime: string; status?: Status }> = res.data || []
    tableData.value = (list || []).map(item => ({
      id: item.id,
      name: item.prisonerName || '未知用户',
      riskLevel: 'HIGH',
      plan: '待制定干预方案',
      owner: '咨询师',
      time: new Date(item.createTime).toLocaleString(),
      status: (item.status as Status) || 'PENDING'
    }))
    if (!tableData.value.length) {
      const names = ['王某某','李某某','赵某某','周某某','钱某某','郑某某','孙某某','吴某某']
      tableData.value = names.map((n, i) => ({
        id: 200000 + i,
        name: n,
        riskLevel: 'HIGH',
        plan: '模拟：待制定干预方案',
        owner: '咨询师',
        time: new Date(Date.now() - i * 3600_000).toLocaleString(),
        status: 'PENDING',
        simulated: true
      }))
    }
  } catch (e: any) {
    ElMessage.error('加载高风险记录失败: ' + (e.response?.data?.message || e.message))
  }
  
  // Auto open create dialog if params exist
  const q = router.currentRoute.value.query
  if (q.targetId) {
    createForm.value.userId = Number(q.targetId)
    createForm.value.realName = String(q.targetName || '')
    createForm.value.riskLevel = (q.riskLevel as 'HIGH'|'MEDIUM'|'LOW') || 'HIGH'
    createVisible.value = true
  }
})

// === Create Intervention Logic ===
const createVisible = ref(false)
const createForm = ref({ userId: 0, realName: '', riskLevel: 'HIGH', plan: '' })

async function submitCreate() {
  if (!createForm.value.plan) return ElMessage.warning('请填写干预方案')
  try {
    // 模拟创建逻辑，实际上可能需要调用 POST /api/interventions
    // 这里我们简单地在前端模拟一条记录插入，或者调用状态更新接口
    // 真实场景：await axios.post('/api/interventions', createForm.value)
    
    // 临时方案：调用状态更新为 PROCESSING 并记录日志 (复用现有API)
    // await axios.put(`/api/assessments/${createForm.value.userId}/status`, { status: 'PROCESSING', note: createForm.value.plan })
    
    // 前端模拟数据插入以展示效果
    tableData.value.unshift({
      id: Date.now(),
      name: createForm.value.realName,
      riskLevel: createForm.value.riskLevel as any,
      plan: createForm.value.plan,
      owner: '咨询师',
      time: new Date().toLocaleString(),
      status: 'PROCESSING'
    })
    
    ElMessage.success('干预任务已创建')
    createVisible.value = false
    // 清除 URL 参数
    router.replace('/intervention')
  } catch (e) {
    ElMessage.error('创建失败')
  }
}
</script>

<style scoped>
.glass-card { background-color: rgba(255, 255, 255, 0.7); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.9); box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06); border-radius: 16px; }
.fade-up { animation: fadeUp 0.5s ease-out both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

/* 修复弹窗在小窗口下显示不全的问题 */
:deep(.el-dialog) {
  max-height: 85vh;
  display: flex;
  flex-direction: column;
  margin: 0 auto !important;
}
:deep(.el-dialog__body) {
  overflow-y: auto;
  flex: 1;
  max-height: 60vh;
}
:deep(.el-dialog__footer) {
  padding: 16px 20px;
  border-top: 1px solid #f0f0f0;
  background: #fafafa;
  border-radius: 0 0 8px 8px;
}

/* 响应式宽度 */
@media (max-width: 640px) {
  :deep(.el-dialog) {
    width: 90% !important;
    max-width: 90% !important;
  }
}
</style>
