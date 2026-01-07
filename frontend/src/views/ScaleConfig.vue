<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white/50 p-5 flex items-center justify-between">
      <div>
        <h3 class="text-xl font-bold text-slate-800 flex items-center gap-2"><span>⚙️</span> 心理量表配置中心</h3>
        <p class="text-sm text-slate-500 mt-1">创建与维护心理测评量表及题库</p>
      </div>
      <div>
        <el-button type="primary" size="large" class="!rounded-xl shadow-lg shadow-blue-500/30" @click="handleAddScale">+ 新建量表</el-button>
      </div>
    </div>

    <div class="glass-card p-4 rounded-3xl overflow-hidden shadow-lg border border-white/60 min-h-[500px]">
      <el-collapse v-model="activeName" accordion @change="handleCollapseChange">
        <el-collapse-item v-for="(scale, index) in scales" :key="scale.id" :name="scale.id">
          <template #title>
            <div class="flex items-center justify-between w-full pr-4">
              <div class="flex items-center gap-3">
                <el-switch v-if="scale.id !== -1" v-model="scale.isEnabled" active-text="启用" inactive-text="停用" inline-prompt @change="toggleScale(scale)" @click.stop />
                <span class="font-bold text-slate-700 text-lg" :class="{ 'opacity-50': !scale.isEnabled }">{{ scale.name || '未命名量表' }}</span>
                <el-tag size="small" effect="plain" round>{{ scale.items }} 题</el-tag>
                <el-tag v-if="scale.id === -1" type="warning" size="small" effect="dark">新建中</el-tag>
              </div>
              <div class="text-xs text-slate-400 truncate max-w-[300px]">{{ scale.description }}</div>
            </div>
          </template>

          <div class="p-4 bg-white/40 rounded-xl mt-2">
            <!-- Scale Basic Info Form -->
            <el-form :model="scale" label-position="top" class="mb-6 border-b border-slate-200/50 pb-4">
              <el-row :gutter="20">
                <el-col :span="8">
                  <el-form-item label="量表名称">
                    <el-input v-model="scale.name" placeholder="请输入量表名称" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="简介描述">
                    <el-input v-model="scale.description" placeholder="请输入简介" />
                  </el-form-item>
                </el-col>
                <el-col :span="4" class="flex items-end pb-4">
                  <el-button type="primary" @click="saveScale(scale)">保存配置</el-button>
                  <el-button v-if="scale.id !== -1" type="danger" plain @click="deleteScale(scale)">删除</el-button>
                  <el-button v-else @click="cancelCreate(index)">取消</el-button>
                </el-col>
              </el-row>
            </el-form>

            <!-- Questions Manager (Only show if scale is saved) -->
            <div v-if="scale.id !== -1">
              <div class="flex items-center justify-between mb-4">
                <h4 class="font-bold text-slate-600 flex items-center gap-2">📄 题目列表</h4>
                <el-button type="primary" size="small" @click="openCreateQuestion(scale)">+ 新增题目</el-button>
              </div>

              <el-table :data="scale.questions || []" style="width: 100%" size="small" :header-cell-style="{ background: 'transparent' }" :row-style="{ background: 'transparent' }">
                <el-table-column prop="id" label="ID" width="60" />
                <el-table-column label="维度" width="100">
                  <template #default="{ row }">
                    <el-tag v-if="extractDimension(row.content)" size="small" effect="dark">{{ extractDimension(row.content) }}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="content" label="题干" min-width="200">
                  <template #default="{ row }">{{ row.content.replace(/维度:\s*[^，\s)]+/, '').trim() }}</template>
                </el-table-column>
                <el-table-column label="操作" width="120" align="right">
                  <template #default="{ row }">
                    <el-button link type="primary" size="small" @click="openEditQuestion(row, scale)">编辑</el-button>
                    <el-button link type="danger" size="small" @click="deleteQuestion(row, scale)">删除</el-button>
                  </template>
                </el-table-column>
              </el-table>
            </div>
            <div v-else class="text-center py-8 text-slate-400">
              请先保存量表基本信息，再添加题目
            </div>
          </div>
        </el-collapse-item>
      </el-collapse>
    </div>

    <!-- Question Dialog (Reused) -->
    <el-dialog v-model="editQuestionVisible" :title="questionEditing ? '编辑题目' : '新增题目'" width="680px" class="!rounded-2xl">
      <el-form label-position="top">
        <el-form-item label="所属维度">
          <el-select v-model="questionForm.dimension" allow-create filterable default-first-option placeholder="选择或输入维度">
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
            <el-tag class="cursor-pointer hover:scale-105 transition-transform" type="info" @click="fillTemplate('yesno')">模板: 是/否 (0/1)</el-tag>
            <el-tag class="cursor-pointer hover:scale-105 transition-transform" type="info" @click="fillTemplate('degree')">模板: 符合程度 (0-2)</el-tag>
          </div>
          <el-input type="textarea" v-model="questionForm.optionsJson" rows="5" font-family="monospace" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editQuestionVisible = false">取消</el-button>
        <el-button type="primary" @click="saveQuestion">保存题目</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import axios from 'axios'

type ScaleRow = { id: number; name: string; description?: string; items?: number; questions?: any[] }
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
    scales.value = (data || []).map((s: any) => ({ ...s, items: 0, questions: [] }))
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

  const newScale = { id: -1, name: '', description: '', items: 0, questions: [] }
  scales.value.unshift(newScale) // Add to top
  
  // FIX: Force layout update to ensure expansion works
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
        if (scale.id === -1) {
            // Create
            const { data } = await axios.post('/api/scales', { name: scale.name, description: scale.description })
            scale.id = data.id // Update ID from backend
            ElMessage.success('量表创建成功')
            // Remove the temporary -1 key logic if needed, or just reload
            await loadScales()
            activeName.value = data.id // Expand the real ID
        } else {
            // Update
            await axios.put(`/api/scales/${scale.id}`, { name: scale.name, description: scale.description })
            ElMessage.success('量表更新成功')
        }
    } catch (e) {
        ElMessage.error('保存失败')
    }
}

async function deleteScale(scale: ScaleRow) {
    try {
        await ElMessageBox.confirm('确定删除该量表及其所有题目吗？', '警告', { type: 'warning' })
        await axios.delete(`/api/scales/${scale.id}`) 
        ElMessage.success('已删除')
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
:deep(.el-collapse-item__header) { background: transparent; border-bottom: 1px solid rgba(0,0,0,0.05); font-size: 16px; }
:deep(.el-collapse-item__wrap) { background: transparent; border-bottom: none; }
:deep(.el-collapse-item__content) { padding-bottom: 0; }
</style>
