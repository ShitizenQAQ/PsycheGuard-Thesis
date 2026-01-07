<template>
  <div class="result-container bg-slate-50 min-h-screen">
    <div class="medical-report">
      <div class="report-header">
        <button v-if="isCounselor" @click="goBack"
          class="absolute left-6 top-6 z-20 bg-white/20 backdrop-blur-sm border border-white/30 text-white font-semibold rounded-xl px-4 py-2 flex items-center gap-2 hover:bg-white/30 transition-all duration-200 shadow-sm">
          <ArrowLeft :size="18" />
          <span>返回记录</span>
        </button>
        <button v-else @click="goLogin"
          class="absolute left-6 top-6 z-20 bg-white/20 backdrop-blur-sm border border-white/30 text-white font-semibold rounded-xl px-4 py-2 flex items-center gap-2 hover:bg-white/30 transition-all duration-200 shadow-sm">
          <LogOut :size="18" />
          <span>退出登录</span>
        </button>
        
        <button
          :disabled="isExporting"
          @click="downloadPDF"
          class="absolute right-6 top-6 z-20 bg-white text-blue-700 font-bold rounded-xl shadow-lg px-5 py-2 flex items-center gap-2 hover:scale-105 active:scale-95 transition-all duration-200 disabled:opacity-70 disabled:cursor-not-allowed"
        >
          <Download :size="18" />
          <span v-if="isExporting">生成中...</span>
          <span v-else>导出 PDF</span>
        </button>

        <div class="report-title-section pt-8">
          <div class="w-16 h-16 mx-auto bg-white/20 rounded-full flex items-center justify-center mb-4 backdrop-blur-md">
            <span class="text-3xl">🩺</span>
          </div>
          <h1 class="text-3xl font-bold mb-2 tracking-wide">心理健康评估报告</h1>
          <p class="text-blue-100 text-lg">评估对象：{{ subjectName }}</p>
        </div>
        
        <div class="report-info mt-6 md:mt-0 bg-white/10 p-4 rounded-xl backdrop-blur-sm border border-white/10">
          <div class="flex justify-between items-center mb-2 gap-4">
            <span class="text-blue-100 text-sm">报告编号</span>
            <span class="font-mono font-bold">{{ id }}</span>
          </div>
          <div class="flex justify-between items-center mb-2 gap-4">
            <span class="text-blue-100 text-sm">评估日期</span>
            <span class="font-bold">{{ currentDate }}</span>
          </div>
          <div class="flex justify-between items-center gap-4">
            <span class="text-blue-100 text-sm">主评咨询师</span>
            <span class="font-bold">{{ doctorName }}</span>
          </div>
        </div>
      </div>
      
      <div class="report-content space-y-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="bg-slate-50 p-6 rounded-2xl border border-slate-100 flex flex-col items-center justify-center">
            <div class="text-slate-500 text-sm font-medium mb-2 uppercase tracking-wider">综合评分</div>
            <div class="text-5xl font-black text-slate-800">{{ totalScore }} <span class="text-lg text-slate-400 font-normal">/ 40分</span></div>
          </div>
          <div class="bg-slate-50 p-6 rounded-2xl border border-slate-100 flex flex-col items-center justify-center">
            <div class="text-slate-500 text-sm font-medium mb-2 uppercase tracking-wider">关注等级</div>
            <el-tag 
              :type="riskLevel === 'HIGH' ? 'danger' : 'success'"
              effect="dark"
              class="!text-lg !px-6 !py-6 !rounded-xl font-bold"
            >
              {{ riskLevel === 'HIGH' ? '重点关注' : '安心状态' }}
            </el-tag>
          </div>
        </div>
        
        <div class="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm">
          <h2 class="text-lg font-bold text-slate-800 mb-6 flex items-center gap-2">
            <span class="w-1 h-6 bg-blue-500 rounded-full"></span>
            多维心理特征分析
          </h2>
          <div class="chart-container h-[400px] w-full flex items-center justify-center bg-slate-50/50 rounded-xl">
            <div ref="chartRef" class="w-full h-full"></div>
          </div>
        </div>

        <div v-if="isCounselor || expertAnnotation" class="bg-amber-50 rounded-2xl border border-amber-100 p-6">
          <div class="flex justify-between items-center mb-4">
            <h2 class="text-lg font-bold text-amber-900 flex items-center gap-2">
              <span>👨‍⚕️</span> 专家研判与批注
            </h2>
            <div v-if="isCounselor" class="flex gap-2">
               <el-tag v-if="isTeachingCase" type="success" effect="dark" round>已入库</el-tag>
               <el-button v-else type="warning" size="small" plain round @click="addToTeachingLibrary">加入案例库</el-button>
            </div>
          </div>
          
          <div v-if="isCounselor">
            <el-input
              v-model="expertAnnotation"
              type="textarea"
              :rows="4"
              placeholder="请输入临床观察结论..."
              class="!bg-white mb-3"
            />
            <div class="flex justify-end">
              <el-button type="primary" size="small" @click="saveAnnotation">保存批注</el-button>
            </div>
          </div>
          <div v-else>
             <p class="text-amber-800 leading-relaxed">{{ expertAnnotation || '暂无专家批注。' }}</p>
          </div>
        </div>
        
        <div :class="riskLevel === 'HIGH' ? 'bg-rose-50 border-rose-100' : 'bg-emerald-50 border-emerald-100'" class="rounded-2xl border p-6">
          <h2 :class="riskLevel === 'HIGH' ? 'text-rose-800' : 'text-emerald-800'" class="text-lg font-bold mb-3 flex items-center gap-2">
            <span>💡</span> 专业建议
          </h2>
          <p :class="riskLevel === 'HIGH' ? 'text-rose-700' : 'text-emerald-700'" class="leading-relaxed">
            <span v-if="riskLevel === 'HIGH'">
              ⚠️ 提示：评估结果显示该来访者存在需要关注的心理特征。建议安排专业咨询师进行一对一访谈，并关注其情绪与行为变化。
            </span>
            <span v-else>
              ✅ 结论：评估结果显示心理状况平稳，各项指标均在正常范围内。建议继续保持当前状态，定期进行心理健康维护。
            </span>
          </p>
        </div>
      </div>
      
      <div class="report-footer bg-slate-50 p-8 border-t border-slate-200">
        <div class="text-center text-slate-400 text-xs italic mb-8">
          * 本报告由 PsycheGuard 智能评估系统自动生成，仅供咨询参考。
        </div>
        <div class="flex justify-between items-end pt-8 border-t border-slate-200 border-dashed">
          <div class="text-slate-500 text-sm">
            <div>PsycheGuard System v2.5</div>
            <div class="mt-1">生成编号：{{ id.substring(0,8) }}...</div>
          </div>
          <div class="text-right">
            <div class="mb-8">
              <span class="text-slate-600 font-serif text-lg">签名：____________________</span>
            </div>
            <div class="text-slate-400 text-sm">日期：{{ new Date().toLocaleDateString() }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import * as echarts from 'echarts'
import { ArrowLeft, Download, LogOut } from 'lucide-vue-next'
import { ElMessage } from 'element-plus'

const route = useRoute()
const router = useRouter()
const isCounselor = computed(() => {
  try {
    const u = JSON.parse(localStorage.getItem('pg_user') || 'null')
    return u?.role === 'ROLE_COUNSELOR'
  } catch { return false }
})
const isExporting = ref(false)
const id = route.params.id as string
const chartRef = ref<HTMLDivElement | null>(null)
const riskLevel = ref('')
const totalScore = ref(0)
const isTeachingCase = ref(false)
const expertAnnotation = ref('')
const subjectName = computed(() => {
  const q = route.query?.name as string | undefined
  return q && q.trim() ? q : '来访者'
})
const doctorName = computed(() => {
  try {
    const u = JSON.parse(localStorage.getItem('pg_user') || 'null')
    if (u?.role === 'ROLE_COUNSELOR') return u?.realName || u?.username || '咨询师'
    return '咨询师'
  } catch { return '咨询师' }
})

const currentDate = computed(() => {
  return new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })
})

onMounted(async () => {
  try {
    const { data } = await axios.get(`/api/assessments/${id}`)
    riskLevel.value = data.riskLevel
    totalScore.value = data.totalScore
    isTeachingCase.value = !!data.isTeachingCase
    expertAnnotation.value = data.expertAnnotation || ''
    
    // 图表数据逻辑...
    const dim: Record<string, number> = data.dimensionScore || {}
    const rawKeys = Object.keys(dim).length ? Object.keys(dim) : ['情感冷漠', '冲动控制', '反社会', '认知扭曲', '生活方式']
    
    // 维度名称映射表: 后端原始名称 -> 前端专业展示名称
    const termMapping: Record<string, string> = {
      '人际操控': '人际关系',
      '情感冷漠': '情感反应',
      '感觉寻求': '行为模式',
      '冲动控制': '冲动性',
      '认知扭曲': '认知模式',
      '情感': '情感稳定性',
      '反社会': '社会适应',
      '生活方式': '生活方式'
    }

    // 维度满分值映射
    const indicatorMap: Record<string, number> = {
      '人际操控': 8, '情感冷漠': 8, '感觉寻求': 10, '冲动控制': 10,
      '认知扭曲': 8, '情感': 8, '反社会': 10, '生活方式': 10
    }
    
    const indicators = rawKeys.map(k => ({ 
      name: termMapping[k] || k, // 使用映射后的名称，如果没有则使用原名
      max: indicatorMap[k] ?? 10 
    }))
    const values = rawKeys.map((k, i) => Math.min((indicators[i].max as number), dim[k] || 0))

    if (chartRef.value) {
      const chart = echarts.init(chartRef.value)
      const isHigh = riskLevel.value === 'HIGH'
      const mainColor = isHigh ? '#ef4444' : '#10b981' // Red or Emerald
      
      chart.setOption({
        tooltip: { trigger: 'item' },
        radar: {
          indicator: indicators,
          shape: 'circle',
          splitNumber: 4,
          axisName: {
            formatter: function (value: string) {
              // 根据isCounselor决定是否显示原始术语
              return isCounselor.value ? value : (termMapping[value] || value);
            },
            color: '#64748b',
            fontSize: 12,
            fontWeight: 'bold'
          },
          splitLine: { lineStyle: { color: '#e2e8f0' } },
          splitArea: { show: true, areaStyle: { color: ['#f8fafc', '#fff'] } },
          axisLine: { lineStyle: { color: '#cbd5e1' } }
        },
        series: [{
          name: '心理特征画像',
          type: 'radar',
          data: [{
            value: values,
            name: subjectName.value,
            itemStyle: { color: mainColor },
            areaStyle: { color: mainColor, opacity: 0.2 },
            lineStyle: { width: 3 }
          }]
        }]
      })
      window.addEventListener('resize', () => chart.resize())
    }
  } catch (error: any) {
    const status = error?.response?.status
    if (status === 404) {
      ElMessage.warning('评估记录不存在或已删除')
      return router.replace(isCounselor.value ? '/history' : '/test')
    }
    // 即使报错也允许页面展示（可能只有部分数据）
    console.error(error)
  }
})

function goBack() { router.push(isCounselor.value ? '/history' : '/test') }

function goLogin() {
  localStorage.clear()
  router.replace('/login')
}

async function downloadPDF() {
  if (isExporting.value) return
  isExporting.value = true
  try {
    const el = document.querySelector('.medical-report') as HTMLElement
    if (!el) return
    
    const html2canvas = (await import('html2canvas')).default
    const { jsPDF } = await import('jspdf')
    
    const canvas = await html2canvas(el, {
      scale: 2,
      useCORS: true,
      backgroundColor: '#ffffff', // 强制白底
      ignoreElements: (element) => {
        // 导出时不包含按钮
        return element.tagName === 'BUTTON'
      }
    })
    
    const imgData = canvas.toDataURL('image/png')
    const pdf = new jsPDF({
      orientation: 'p',
      unit: 'px',
      format: [canvas.width, canvas.height] // 完美适配截图尺寸
    })
    
    pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height)
    pdf.save(`PsycheGuard_Report_${id}.pdf`)
  } catch (e) {
    ElMessage.error('导出失败，请重试')
    console.error(e)
  } finally {
    isExporting.value = false
  }
}

async function saveAnnotation() {
  try {
    const payload = { isTeachingCase: isTeachingCase.value, annotation: expertAnnotation.value }
    await axios.put(`/api/assessments/${id}/annotate`, payload)
    ElMessage.success('专家批注已保存')
  } catch (error: any) {
    ElMessage.error('保存失败')
  }
}

async function addToTeachingLibrary() {
  try {
    isTeachingCase.value = true
    await saveAnnotation() // 复用保存逻辑
    ElMessage.success('成功加入经典案例库')
  } catch (e) {
    ElMessage.error('操作失败')
  }
}
</script>

<style scoped>
.result-container {
  display: flex;
  justify-content: center;
  padding: 40px 20px;
}

.medical-report {
  background: white;
  border-radius: 24px; /* 更圆润的边角 */
  box-shadow: 0 20px 50px -12px rgba(0, 0, 0, 0.1);
  max-width: 800px; /* 标准 A4 比例宽度 */
  width: 100%;
  overflow: hidden;
  position: relative;
}

.report-header {
  background: linear-gradient(120deg, #1e293b, #334155); /* 深色高级感头部 */
  color: white;
  padding: 40px;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
}

/* 覆盖 Element Plus 样式以匹配 */
:deep(.el-textarea__inner) {
  border-radius: 12px;
  padding: 12px;
  font-family: inherit;
}
</style>
