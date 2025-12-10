<template>
  <div class="p-6 space-y-6 fade-up">
    <div class="bg-white/80 backdrop-blur-md rounded-2xl shadow-sm border border-white/50 p-5 flex items-center justify-between">
      <div>
        <h3 class="text-xl font-bold text-slate-800 flex items-center gap-2"><span>⚙️</span> 心理量表配置中心</h3>
        <p class="text-sm text-slate-500 mt-1">创建与维护心理测评量表及题库</p>
      </div>
      <div>
        <el-button type="primary" size="large" class="!rounded-xl shadow-lg shadow-blue-500/30" @click="openCreateScale">+ 新建量表</el-button>
      </div>
    </div>

    <div class="glass-card p-1 rounded-3xl overflow-hidden shadow-lg border border白/60">
      <el-table :data="scales" style="width: 100%" @row-click="onRowClick" highlight-current-row :header-cell-style="{ background: '#f8fafc', color: '#475569', fontWeight: '600' }" :row-style="{ background: 'transparent', cursor: 'pointer' }">
        <el-table-column prop="id" label="ID" width="80" align="center" />
        <el-table-column label="量表名称" min-width="200">
          <template #default="{ row }">
            <span class="font-bold text-slate-700">{{ row.name }}</span>
            <div class="text-xs text-slate-400 truncate">{{ row.description }}</div>
          </template>
        </el-table-column>
        <el-table-column label="题目数" width="120" align="center">
          <template #default="{ row }"><el-tag type="info" effect="plain" round>{{ row.items || '-' }} 题</el-tag></template>
        </el-table-column>
        <el-table-column label="操作" width="200" align="right">
          <template #default="{ row }">
            <el-button size="small" :icon="Edit" circle @click.stop="openEditScale(row)" />
            <el-button size="small" type="primary" class="!rounded-lg" @click.stop="selectScale(row)">管理题目</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <div v-if="selectedScale" class="glass-card p-6 rounded-3xl border border-blue-100 bg-blue-50/30">
      <div class="flex items-center justify-between mb-6">
        <div>
          <h3 class="text-lg font-bold text-slate-800 flex items-center gap-2"><span class="text-blue-600">📝</span> 题目管理 <span class="text-sm font-normal text-slate-400 bg-white px-2 py-0.5 rounded-md border border-slate-200">{{ selectedScale.name }}</span></h3>
        </div>
        <el-button type="primary" @click="openCreateQuestion">新增题目</el-button>
      </div>
      <el-table :data="questions" style="width: 100%" class="!bg-transparent" :header-cell-style="{ background: 'rgba(255,255,255,0.5)' }" :row-style="{ background: 'transparent' }">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column label="维度" width="120">
          <template #default="{ row }">
            <el-tag v-if="extractDimension(row.content)" size="small" effect="dark">{{ extractDimension(row.content) }}</el-tag>
            <span v-else class="text-slate-300">-</span>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="题干内容" min-width="300">
          <template #default="{ row }">{{ row.content.replace(/维度:\s*[^，\s)]+/, '').trim() }}</template>
        </el-table-column>
        <el-table-column label="操作" width="180" align="right">
          <template #default="{ row }">
            <el-button size="small" text type="primary" @click="openEditQuestion(row)">编辑</el-button>
            <el-button size="small" text type="danger" @click="deleteQuestion(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 新建量表 -->
    <el-dialog v-model="createScaleVisible" title="新建量表" width="500px" class="!rounded-2xl">
      <el-form label-position="top">
        <el-form-item label="量表名称"><el-input v-model="createScaleForm.name" /></el-form-item>
        <el-form-item label="量表简介"><el-input type="textarea" v-model="createScaleForm.description" rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="createScaleVisible = false">取消</el-button>
        <el-button type="primary" @click="saveCreateScale">保存</el-button>
      </template>
    </el-dialog>

    <!-- 编辑量表 -->
    <el-dialog v-model="editScaleVisible" title="编辑量表" width="500px" class="!rounded-2xl">
      <el-form label-position="top">
        <el-form-item label="量表名称"><el-input v-model="editScaleForm.name" /></el-form-item>
        <el-form-item label="量表简介"><el-input type="textarea" v-model="editScaleForm.description" rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editScaleVisible = false">取消</el-button>
        <el-button type="primary" @click="saveEditScale">保存</el-button>
      </template>
    </el-dialog>

    <!-- 新建/编辑题目 -->
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
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Edit } from '@element-plus/icons-vue'
import axios from 'axios'

type ScaleRow = { id: number; name: string; description?: string; items?: number }
type QuestionRow = { id: number; content: string; options: Array<Record<string, any>> }

const scales = ref<ScaleRow[]>([])
const selectedScale = ref<ScaleRow | null>(null)
const questions = ref<QuestionRow[]>([])

const createScaleVisible = ref(false)
const createScaleForm = ref<{ name: string; description?: string }>({ name: '', description: '' })

const editScaleVisible = ref(false)
const editScaleForm = ref<{ id: number | null; name: string; description?: string }>({ id: null, name: '', description: '' })

const editQuestionVisible = ref(false)
const questionEditing = ref(false)
const questionForm = ref<{ id?: number; dimension: string; content: string; optionsJson: string }>({ content: '', dimension: '', optionsJson: '' })

onMounted(async () => { await loadScales() })

async function loadScales() {
  try {
    const { data } = await axios.get('/api/scales')
    const list: Array<{ id: number; name: string; description?: string }> = data || []
    scales.value = list.map(s => ({ id: s.id, name: s.name, description: s.description, items: 0 }))
    if (selectedScale.value) await loadQuestions(selectedScale.value.id)
  } catch (e) { console.error(e) }
}

async function loadQuestions(scaleId: number) {
  try {
    const { data } = await axios.get(`/api/scales/${scaleId}/questions`)
    questions.value = (data || [])
    const scale = scales.value.find(s => s.id === scaleId)
    if (scale) scale.items = questions.value.length
  } catch (e) { console.error(e) }
}

function onRowClick(row: ScaleRow) { selectScale(row) }
function selectScale(row: ScaleRow) { selectedScale.value = row; loadQuestions(row.id) }

function openCreateScale() { createScaleVisible.value = true }
async function saveCreateScale() {
  if (!createScaleForm.value.name.trim()) return
  await axios.post('/api/scales', { name: createScaleForm.value.name.trim(), description: createScaleForm.value.description || '' })
  createScaleVisible.value = false
  createScaleForm.value = { name: '', description: '' }
  ElMessage.success('量表已创建')
  await loadScales()
}

function openEditScale(row: ScaleRow) { editScaleForm.value = { id: row.id, name: row.name, description: row.description || '' }; editScaleVisible.value = true }
async function saveEditScale() {
  if (!editScaleForm.value.id) return
  await axios.put(`/api/scales/${editScaleForm.value.id}`, { name: editScaleForm.value.name.trim(), description: editScaleForm.value.description || '' })
  editScaleVisible.value = false
  ElMessage.success('量表已更新')
  await loadScales()
}

function openCreateQuestion() { questionEditing.value = false; questionForm.value = { content: '', dimension: '', optionsJson: JSON.stringify([{label:"是",score:1},{label:"否",score:0}]) }; editQuestionVisible.value = true }
function openEditQuestion(row: QuestionRow) { questionEditing.value = true; questionForm.value = { id: row.id, content: row.content, dimension: extractDimension(row.content), optionsJson: JSON.stringify(row.options) }; editQuestionVisible.value = true }

async function saveQuestion() {
  if (!selectedScale.value) return
  const dim = questionForm.value.dimension.trim()
  const text = questionForm.value.content.trim()
  let options: any
  try { options = JSON.parse(questionForm.value.optionsJson || '[]') } catch (e) { ElMessage.error('选项 JSON 解析失败'); return }
  const content = dim ? `维度:${dim} ${text}` : text
  const payload = { scaleId: selectedScale.value.id, content, options }
  if (questionEditing.value && questionForm.value.id) {
    await axios.put(`/api/questions/${questionForm.value.id}`, payload)
    ElMessage.success('题目已更新')
  } else {
    await axios.post('/api/questions', payload)
    ElMessage.success('题目已创建')
  }
  editQuestionVisible.value = false
  await loadQuestions(selectedScale.value.id)
}

async function deleteQuestion(row: QuestionRow) {
  await axios.delete(`/api/questions/${row.id}`)
  ElMessage.success('题目已删除')
  if (selectedScale.value) await loadQuestions(selectedScale.value.id)
}

function extractDimension(content: string) { const m = content?.match(/维度:\s*([^，\s)]+)/); return m?.[1] || '' }
</script>

<style scoped>
.glass-card { background-color: rgba(255, 255, 255, 0.7); backdrop-filter: blur(12px); box-shadow: 0 8px 32px rgba(31, 38, 135, 0.07); }
.fade-up { animation: fadeUp 0.5s ease-out both; }
@keyframes fadeUp { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
:deep(.el-table) { background-color: transparent !important; --el-table-bg-color: transparent !important; --el-table-tr-bg-color: transparent !important; }
:deep(.el-table__inner-wrapper::before) { display: none; }
</style>
