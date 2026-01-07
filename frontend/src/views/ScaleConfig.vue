<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white/50 p-5 flex items-center justify-between">
      <div>
        <h3 class="text-xl font-bold text-rock-800 flex items-center gap-2"><span>⚙️</span> 心理量表配置中心</h3>
        <p class="text-sm text-rock-500 mt-1">创建与维护心理测评量表及题库</p>
      </div>
      <div>
        <el-button type="primary" size="large" class="!rounded-xl shadow-lg shadow-healing-500/20 !bg-healing-500 !border-healing-500 hover:!bg-healing-600" @click="handleAddScale">+ 新建量表</el-button>
      </div>
    </div>

    <div class="glass-card p-4 rounded-3xl overflow-hidden shadow-lg border border-white/60 min-h-[500px]">
      <el-collapse v-model="activeName" accordion @change="handleCollapseChange">
        <el-collapse-item v-for="(scale, index) in scales" :key="scale.id" :name="scale.id">
          <template #title>
            <div class="flex items-center justify-between w-full pr-4">
              <div class="flex items-center gap-3">
                <el-switch 
                  v-if="scale.id !== -1" 
                  v-model="scale.isEnabled" 
                  style="--el-switch-on-color: #6B9080"
                  active-text="启用" 
                  inactive-text="停用" 
                  inline-prompt 
                  @change="(val) => toggleScale(scale, val)" 
                  @click.stop 
                />
                <span class="font-bold text-rock-700 text-lg transition-opacity" :class="{ 'opacity-50': !scale.isEnabled }">{{ scale.name || '未命名量表' }}</span>
                <el-tag v-if="scale.isStandard" size="small" type="warning" effect="dark" class="!bg-amber-500 !border-amber-600">
                  <span class="flex items-center gap-1">
                    <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path>
                    </svg>
                    标准量表
                  </span>
                </el-tag>
                <el-tag size="small" effect="plain" type="info" round>{{ scale.items }} 题</el-tag>
                <el-tag v-if="scale.id === -1" type="warning" size="small" effect="dark">新建中</el-tag>
              </div>
              <div class="text-xs text-rock-400 truncate max-w-[300px]">{{ scale.description }}</div>
            </div>
          </template>

          <div class="p-6 bg-white/40 rounded-2xl mt-2 border border-white/50">
            <!-- Scale Basic Info Form -->
            <el-form :model="scale" label-position="top" class="mb-6 border-b border-cream-200 pb-6">
              <el-row :gutter="20">
                <el-col :span="8">
                  <el-form-item label="量表名称">
                    <el-input v-model="scale.name" placeholder="请输入量表名称" class="!rounded-xl" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="简介描述">
                    <el-input v-model="scale.description" placeholder="请输入简介" class="!rounded-xl" />
                  </el-form-item>
                </el-col>
                <el-col :span="6">
                  <el-form-item label="危险阈值">
                    <el-input-number 
                      v-model="scale.dangerThreshold" 
                      :min="0" 
                      :max="999" 
                      placeholder="默认 6" 
                      class="w-full !rounded-xl" 
                      controls-position="right"
                    />
                  </el-form-item>
                  <p class="text-xs text-rock-400 -mt-3">≥此分数视为高风险</p>
                </el-col>
                <el-col :span="6">
                  <el-form-item label="量表满分">
                    <el-input-number 
                      v-model="scale.maxScore" 
                      :min="0" 
                      :max="999" 
                      placeholder="可选" 
                      class="w-full !rounded-xl" 
                      controls-position="right"
                    />
                  </el-form-item>
                  <p class="text-xs text-rock-400 -mt-3">用于前端展示</p>
                </el-col>
                <el-col :span="4" class="flex items-end pb-1 gap-2">
                  <el-button type="primary" class="!bg-healing-500 !border-healing-500 !rounded-xl" @click="saveScale(scale)">保存配置</el-button>
                  <el-button v-if="scale.id !== -1" type="danger" plain class="!rounded-xl !bg-red-50 !border-red-200 !text-red-500 hover:!bg-red-100" @click="deleteScale(scale)">删除</el-button>
                  <el-button v-else @click="cancelCreate(index)" class="!rounded-xl">取消</el-button>
                </el-col>
              </el-row>
            </el-form>

            <!-- Questions Manager (Only show if scale is saved) -->
            <div v-if="scale.id !== -1">
              <div class="flex items-center justify-between mb-4">
                <h4 class="font-bold text-rock-600 flex items-center gap-2">📄 题目列表</h4>
                <el-button type="primary" size="small" class="!bg-healing-500 !border-healing-500 !rounded-lg" @click="openCreateQuestion(scale)">+ 新增题目</el-button>
              </div>

              <el-table :data="scale.questions || []" style="width: 100%" size="small" :header-cell-style="{ background: 'transparent', color: '#7B7B8D' }" :row-style="{ background: 'transparent' }">
                <el-table-column prop="id" label="ID" width="60" />
                <el-table-column label="维度" width="100">
                  <template #default="{ row }">
                    <el-tag v-if="extractDimension(row.content)" size="small" effect="light" class="!bg-healing-50 !border-healing-100 !text-healing-600">{{ extractDimension(row.content) }}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="content" label="题干" min-width="200">
                  <template #default="{ row }">
                      <span class="text-rock-800 font-medium">{{ row.content.replace(/维度:\s*[^，\s)]+/, '').trim() }}</span>
                  </template>
                </el-table-column>
                <el-table-column label="操作" width="120" align="right">
                  <template #default="{ row }">
                    <el-tooltip v-if="scale.isStandard" content="标准量表不允许修改题目" placement="top">
                      <span>
                        <el-button link type="info" size="small" class="!text-rock-300" disabled>编辑</el-button>
                        <el-button link type="info" size="small" class="!text-rock-300" disabled>删除</el-button>
                      </span>
                    </el-tooltip>
                    <template v-else>
                      <el-button link type="primary" size="small" class="!text-healing-600" @click="openEditQuestion(row, scale)">编辑</el-button>
                      <el-button link type="danger" size="small" class="!text-clay-500" @click="deleteQuestion(row, scale)">删除</el-button>
                    </template>
                  </template>
                </el-table-column>
              </el-table>
            </div>
            <div v-else class="text-center py-8 text-rock-400 border-2 border-dashed border-cream-200 rounded-xl">
              请先保存量表基本信息，再添加题目
            </div>
          </div>
        </el-collapse-item>
      </el-collapse>
    </div>

    <!-- Question Dialog (Reused) -->
    <el-dialog v-model="editQuestionVisible" :title="questionEditing ? '编辑题目' : '新增题目'" width="680px" class="!rounded-2xl healing-dialog">
      <el-form label-position="top">
        <el-form-item label="所属维度">
          <el-select v-model="questionForm.dimension" allow-create filterable default-first-option placeholder="选择或输入维度" class="w-full">
            <el-option label="情感冷漠" value="情感冷漠" />
            <el-option label="冲动控制" value="冲动控制" />
            <el-option label="认知扭曲" value="认知扭曲" />
            <el-option label="反社会" value="反社会" />
            <el-option label="人际操控" value="人际操控" />
          </el-select>
        </el-form-item>
        <el-form-item label="题干内容">
          <el-input type="textarea" v-model="questionForm.content" rows="2" placeholder="例如：你是否经常感到...?" />
        </el-form-item>
        <el-form-item label="选项配置 (JSON)">
          <div class="mb-2 flex gap-2">
            <el-tag class="cursor-pointer hover:scale-105 transition-transform !bg-healing-50 !border-healing-100 !text-healing-600" @click="fillTemplate('yesno')">模板: 是/否 (0/1)</el-tag>
            <el-tag class="cursor-pointer hover:scale-105 transition-transform !bg-amber-50 !border-amber-100 !text-amber-600" @click="fillTemplate('degree')">模板: 符合程度 (0-2)</el-tag>
          </div>
          <el-input type="textarea" v-model="questionForm.optionsJson" rows="5" font-family="monospace" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="flex justify-end gap-3">
          <el-button @click="editQuestionVisible = false" class="!rounded-xl">取消</el-button>
          <el-button type="primary" class="!bg-healing-500 !border-healing-500 !rounded-xl" @click="saveQuestion">保存题目</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

type ScaleRow = { id: number; name: string; description?: string; items?: number; questions?: any[]; isEnabled?: boolean; dangerThreshold?: number; maxScore?: number; isStandard?: boolean }
type QuestionRow = { id: number; content: string; options: Array<Record<string, any>> }

const scales = ref<ScaleRow[]>([])
const activeName = ref<number | string>('') // Controls Collapse expansion
const currentScale = ref<ScaleRow | null>(null) // For Question Dialog context

// Question Dialog State
const editQuestionVisible = ref(false)
const questionEditing = ref(false)
const questionForm = ref<{ id?: number; dimension: string; content: string; optionsJson: string }>({ content: '', dimension: '', optionsJson: '' })

onMounted(async () => { await loadScales() })

async function loadScales() {
  try {
    const { data } = await axios.get('/api/scales')
    scales.value = (data || []).map((s: any) => ({ 
        ...s, 
        items: 0, 
        questions: [],
        isEnabled: s.isEnabled === undefined ? true : s.isEnabled,
        dangerThreshold: s.dangerThreshold !== undefined ? s.dangerThreshold : 6,
        maxScore: s.maxScore,
        // 标记标准量表（后端返回或前端 mock）
        isStandard: s.isStandard || (s.name && (s.name.includes('PCL-R') || s.name.includes('SAS') || s.name.includes('SDS') || s.name.includes('PHQ-9')))
    }))
    // If we have an active scale, reload its questions
    if (activeName.value && activeName.value !== -1) {
        await loadQuestions(Number(activeName.value))
    }
  } catch (e) { console.error(e) }
}

async function loadQuestions(scaleId: number) {
  if (scaleId === -1) return
  try {
    const { data } = await axios.get(`/api/scales/${scaleId}/questions`)
    const scale = scales.value.find(s => s.id === scaleId)
    if (scale) {
      scale.questions = data || []
      scale.items = scale.questions.length
    }
  } catch (e) { console.error(e) }
}

// --- Collapse Logic ---
function handleCollapseChange(val: number | string) {
    if (val && val !== -1) loadQuestions(Number(val))
}

// --- Scale Actions ---
async function handleAddScale() {
  // Check if already creating
  if (scales.value.some(s => s.id === -1)) {
    ElMessage.warning('请先保存当前正在新建的量表')
    activeName.value = -1
    return
  }

  const newScale = { id: -1, name: '', description: '', items: 0, questions: [], isEnabled: true, dangerThreshold: 6, maxScore: undefined }
  scales.value.unshift(newScale) // Add to top
  
  await nextTick()
  activeName.value = -1
}

function cancelCreate(index: number) {
    scales.value.splice(index, 1)
    activeName.value = ''
}

async function saveScale(scale: ScaleRow) {
    if (!scale.name.trim()) return ElMessage.warning('名称不能为空')
    
    try {
        const payload = { 
            name: scale.name, 
            description: scale.description,
            isEnabled: scale.isEnabled,
            dangerThreshold: scale.dangerThreshold,
            maxScore: scale.maxScore
        }

        if (scale.id === -1) {
            // Create
            const { data } = await axios.post('/api/scales', payload)
            scale.id = data.id // Update ID from backend
            ElMessage.success('量表创建成功')
            await loadScales()
            activeName.value = data.id // Expand the real ID
        } else {
            // Update
            await axios.put(`/api/scales/${scale.id}`, payload)
            ElMessage.success('量表更新成功')
        }
    } catch (e) {
        ElMessage.error('保存失败')
    }
}

async function toggleScale(scale: ScaleRow, val: boolean | string | number) {
  try {
      if (scale.id === -1) return
      await axios.put(`/api/scales/${scale.id}`, { isEnabled: scale.isEnabled })
      ElMessage.success(scale.isEnabled ? '量表已启用' : '量表已停用')
  } catch(e) { 
      scale.isEnabled = !scale.isEnabled // revert
      ElMessage.error('操作失败')
  }
}

async function deleteScale(scale: ScaleRow) {
    try {
        await ElMessageBox.confirm(
            `确定要删除量表“${scale.name}”吗？\n警告：此操作不可恢复，且会删除该量表下的所有题目和历史测评记录。`, 
            '高风险操作确认', 
            { 
              confirmButtonText: '确定删除', 
              cancelButtonText: '取消', 
              type: 'warning',
              confirmButtonClass: '!bg-red-500 !border-red-500'
            }
        )
        await axios.delete(`/api/scales/${scale.id}`) 
        ElMessage.success('已删除')
        activeName.value = ''
        await loadScales()
    } catch (e) {
        // ignore cancel
    }
}

// --- Question Actions ---
function openCreateQuestion(scale: ScaleRow) {
    currentScale.value = scale
    questionEditing.value = false
    questionForm.value = { content: '', dimension: '', optionsJson: JSON.stringify([{label:"是",score:1},{label:"否",score:0}]) }
    editQuestionVisible.value = true
}

function openEditQuestion(row: QuestionRow, scale: ScaleRow) {
    currentScale.value = scale
    questionEditing.value = true
    questionForm.value = { 
        id: row.id, 
        content: row.content, 
        dimension: extractDimension(row.content), 
        optionsJson: JSON.stringify(row.options) 
    }
    editQuestionVisible.value = true
}

async function saveQuestion() {
    if (!currentScale.value) return
    const dim = questionForm.value.dimension.trim()
    const text = questionForm.value.content.trim()
    let options: any
    try { options = JSON.parse(questionForm.value.optionsJson || '[]') } catch (e) { ElMessage.error('选项 JSON 解析失败'); return }
    
    const content = dim ? `维度:${dim} ${text}` : text
    const payload = { scaleId: currentScale.value.id, content, options }
    
    try {
        if (questionEditing.value && questionForm.value.id) {
            await axios.put(`/api/questions/${questionForm.value.id}`, payload)
            ElMessage.success('更新成功')
        } else {
            await axios.post('/api/questions', payload)
            ElMessage.success('创建成功')
        }
        editQuestionVisible.value = false
        await loadQuestions(currentScale.value.id)
    } catch (e) {
        ElMessage.error('操作失败')
    }
}

async function deleteQuestion(row: QuestionRow, scale: ScaleRow) {
    try {
        await axios.delete(`/api/questions/${row.id}`)
        ElMessage.success('已删除')
        await loadQuestions(scale.id)
    } catch (e) { ElMessage.error('删除失败') }
}

function extractDimension(content: string) { const m = content?.match(/维度:\s*([^，\s)]+)/); return m?.[1] || '' }
function fillTemplate(type: string) {
    if (type === 'yesno') questionForm.value.optionsJson = JSON.stringify([{label:"是",score:1},{label:"否",score:0}])
    if (type === 'degree') questionForm.value.optionsJson = JSON.stringify([{label:"完全不符",score:0},{label:"有点符合",score:1},{label:"完全符合",score:2}])
}
</script>

<style scoped>
.glass-card { background-color: rgba(255, 255, 255, 0.7); backdrop-filter: blur(12px); box-shadow: 0 8px 32px rgba(31, 38, 135, 0.07); }
.fade-up { animation: fadeUp 0.5s ease-out both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

/* Collapse Styles Override */
:deep(.el-collapse) { border: none; --el-collapse-header-bg-color: transparent; --el-collapse-content-bg-color: transparent; }
:deep(.el-collapse-item__header) { background: transparent; border-bottom: 1px solid rgba(0,0,0,0.05); font-size: 16px; transition: background-color 0.2s; border-radius: 12px; }
:deep(.el-collapse-item__header:hover) { background-color: rgba(255,255,255,0.4); }
:deep(.el-collapse-item__wrap) { background: transparent; border-bottom: none; }
:deep(.el-collapse-item__content) { padding-bottom: 0; }

/* Dialog */
:deep(.healing-dialog .el-dialog__header) {
  padding: 24px 24px 0;
  margin-right: 0;
}
:deep(.healing-dialog .el-dialog__body) {
  padding: 24px;
}

/* Colors patching */
.text-rock-800 { color: #4A4E69 !important; }
.text-rock-700 { color: #5C5F77 !important; }
.text-rock-600 { color: #7B7B8D !important; }
.text-rock-500 { color: #8F91A3 !important; }
.text-rock-400 { color: #A7A7B3 !important; }

.bg-healing-500 { background-color: #6B9080 !important; }
.border-healing-500 { border-color: #6B9080 !important; }
.bg-healing-50 { background-color: #F0F7F4 !important; }
.bg-amber-50 { background-color: #FFFBEB !important; }
.border-amber-100 { border-color: #FEF3C7 !important; }
.text-amber-600 { color: #D97706 !important; }
</style>
