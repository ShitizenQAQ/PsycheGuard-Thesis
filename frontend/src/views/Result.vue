<template>
  <div class="result-container bg-cream-100 min-h-screen py-8 px-4 flex justify-center items-start">
    <div class="medical-report relative">
      <!-- 装饰背景光斑 -->
      <div class="absolute top-0 right-0 w-96 h-96 bg-healing-100 rounded-full mix-blend-multiply filter blur-3xl opacity-50 pointer-events-none -z-10 animate-blob"></div>
      <div class="absolute bottom-0 left-0 w-96 h-96 bg-cream-200 rounded-full mix-blend-multiply filter blur-3xl opacity-50 pointer-events-none -z-10 animate-blob animation-delay-2000"></div>

      <!-- 报告头部区域 -->
      <div class="report-header relative overflow-hidden rounded-t-[2rem]">
         <!-- 动态背景 -->
         <div class="absolute inset-0 bg-gradient-to-br from-healing-100 via-healing-50 to-cream-50 z-0"></div>
         <!-- 装饰纹理 -->
         <div class="absolute top-0 right-0 p-10 opacity-10">
            <svg width="120" height="120" viewBox="0 0 100 100" fill="none" stroke="#6B9080" stroke-width="1.5">
              <circle cx="50" cy="50" r="40"/>
              <path d="M50 10 V90 M10 50 H90"/>
            </svg>
         </div>

         <!-- 顶部按钮栏 -->
         <div class="relative z-20 flex justify-between items-center px-6 pt-6">
            <button v-if="isCounselor" @click="goBack"
             class="bg-white/90 hover:bg-white backdrop-blur-md text-rock-600 font-bold rounded-xl px-4 py-2.5 flex items-center gap-2 shadow-sm transition-all text-sm border border-white/80">
              <ArrowLeft :size="16" />
              <span>返回列表</span>
            </button>
            <button v-else @click="goBackToClientDashboard"
             class="bg-white/90 hover:bg-white backdrop-blur-md text-rock-600 font-bold rounded-xl px-4 py-2.5 flex items-center gap-2 shadow-sm transition-all text-sm border border-white/80">
              <ArrowLeft :size="16" />
              <span>返回</span>
            </button>
            
            <button
              :disabled="isExporting"
              @click="downloadPDF"
              class="bg-healing-500 hover:bg-healing-600 text-white font-bold rounded-xl shadow-lg shadow-healing-500/20 px-5 py-2.5 flex items-center gap-2 transition-all disabled:opacity-70 disabled:cursor-not-allowed text-sm"
            >
              <Download :size="16" />
              <span v-if="isExporting">生成中...</span>
              <span v-else>导出报告</span>
            </button>
         </div>

         <!-- 标题信息 -->
         <div class="relative z-10 px-8 pb-10 pt-4 text-center">
            <div class="w-16 h-16 mx-auto bg-white rounded-2xl flex items-center justify-center mb-6 shadow-md shadow-healing-500/10">
              <span class="text-3xl text-healing-500 font-bold">PG</span>
            </div>
            <h1 class="text-3xl font-bold text-rock-800 tracking-tight mb-2">心理健康评估报告</h1>
            <p class="text-rock-500 font-medium">PsycheGuard Mind Health Assessment</p>
         </div>

         <!-- 信息条 -->
         <div class="relative z-10 px-8 pb-8">
            <div class="bg-white/90 backdrop-blur-md border border-white/80 rounded-2xl p-4 flex flex-col md:flex-row justify-between items-center gap-4 text-sm shadow-sm">
                <div class="flex flex-col items-center md:items-start">
                   <span class="text-rock-400 text-xs uppercase tracking-wider mb-1">评估编号 / ID</span>
                   <span class="font-mono font-bold text-rock-700 tracking-widest">{{ id }}</span>
                </div>
                <div class="flex flex-col items-center md:items-start md:border-l md:border-r md:border-cream-300 md:px-8">
                   <span class="text-rock-400 text-xs uppercase tracking-wider mb-1">评估对象 / Subject</span>
                   <span class="font-bold text-rock-800 text-lg">{{ subjectName }}</span>
                </div>
                <div class="flex flex-col items-center md:items-end">
                   <span class="text-rock-400 text-xs uppercase tracking-wider mb-1">评估日期 / Date</span>
                   <span class="font-bold text-rock-700">{{ currentDate }}</span>
                </div>
            </div>
         </div>
      </div>
      
      <!-- 报告内容区域 -->
      <div class="bg-white p-8 md:p-12 space-y-10 rounded-b-[2rem]">
        
        <!-- 核心指标卡 -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="bg-cream-50 p-6 rounded-3xl border border-cream-200 flex flex-col items-center justify-center relative overflow-hidden group hover:border-healing-200 transition-colors">
            <div class="text-rock-400 text-xs font-bold mb-2 uppercase tracking-widest">综合评分 / Score</div>
            <div class="flex items-baseline gap-2 z-10">
               <span class="text-5xl font-black text-rock-800">{{ totalScore }}</span>
               <span class="text-lg text-rock-400 font-medium">/ {{ maxScore || 40 }}</span>
            </div>
            <!-- 背景装饰 -->
            <div class="absolute -right-4 -bottom-4 w-24 h-24 bg-healing-100 rounded-full opacity-50 mix-blend-multiply filter blur-xl group-hover:bg-healing-200 transition-colors"></div>
          </div>

          <div class="bg-cream-50 p-6 rounded-3xl border border-cream-200 flex flex-col items-center justify-center relative overflow-hidden group hover:border-healing-200 transition-colors">
            <div class="text-rock-400 text-xs font-bold mb-3 uppercase tracking-widest">状态评级 / Status</div>
            <span 
              class="px-5 py-2 rounded-full text-lg font-bold border flex items-center gap-2 z-10 shadow-sm"
              :class="riskLevel === 'HIGH' ? 'bg-clay-100 text-clay-600 border-clay-200' : 'bg-healing-100 text-healing-600 border-healing-200'"
            >
              <span class="w-2.5 h-2.5 rounded-full" :class="riskLevel === 'HIGH' ? 'bg-clay-500' : 'bg-healing-500'"></span>
              {{ riskLevel === 'HIGH' ? '重点关注 (High Risk)' : '安心状态 (Stable)' }}
            </span>
            <!-- 背景装饰 -->
             <div class="absolute -left-4 -top-4 w-24 h-24 rounded-full opacity-50 mix-blend-multiply filter blur-xl transition-colors"
                  :class="riskLevel === 'HIGH' ? 'bg-clay-200' : 'bg-healing-200'"></div>
          </div>
        </div>
        
        <!-- 维度画像 -->
        <div>
          <h2 class="text-xl font-bold text-rock-800 mb-6 flex items-center gap-3">
            <span class="w-1.5 h-6 bg-healing-500 rounded-full"></span>
            多维心理特征画像
          </h2>
          <div class="bg-cream-50/50 rounded-[2rem] p-4 md:p-8 border border-cream-100 relative">
             <div ref="chartRef" class="w-full h-[400px]"></div>
          </div>
        </div>

        <!-- 专家批注 (Counselor Only) -->
        <div v-if="isCounselor || expertAnnotation" 
             class="rounded-[2rem] border p-8 relative overflow-hidden"
             :class="isCounselor ? 'bg-healing-50/50 border-healing-100' : 'bg-cream-50 border-cream-100'"
        >
          <div class="flex justify-between items-center mb-6 relative z-10">
            <h2 class="text-xl font-bold text-rock-800 flex items-center gap-3">
              <span class="text-2xl">📝</span> 专家研判与批注
            </h2>
            <div v-if="isCounselor" class="flex gap-2">
               <el-tag v-if="isTeachingCase" type="success" effect="plain" class="!bg-white !border-healing-200 !text-healing-600">已收录</el-tag>
               <el-button v-else text bg size="small" class="!text-healing-600 !bg-white hover:!bg-healing-50" @click="addToTeachingLibrary">加入案例库</el-button>
            </div>
          </div>
          
          <div v-if="isCounselor" class="relative z-10">
            <el-input
              v-model="expertAnnotation"
              type="textarea"
              :rows="4"
              placeholder="请输入临床观察结论与建议..."
              class="custom-textarea mb-4 shadow-sm"
            />
            <div class="flex justify-end">
              <el-button type="primary" class="!bg-healing-500 !border-healing-500 !rounded-xl shadow-lg shadow-healing-500/20" @click="saveAnnotation">保存批注</el-button>
            </div>
          </div>
          <div v-else class="relative z-10">
             <div class="bg-white/80 p-6 rounded-2xl border border-cream-200 text-rock-700 leading-relaxed font-serif">
                {{ expertAnnotation || '暂无专家批注。' }}
             </div>
          </div>
        </div>
        
        <!-- 智能建议 -->
        <div 
           class="rounded-[2rem] border p-8 relative overflow-hidden"
           :class="riskLevel === 'HIGH' ? 'bg-clay-50 border-clay-100' : 'bg-healing-50 border-healing-100'"
        >
          <h2 class="text-xl font-bold mb-4 flex items-center gap-3 relative z-10"
              :class="riskLevel === 'HIGH' ? 'text-clay-600' : 'text-healing-600'">
            <span>💡</span> 专业建议
          </h2>
          <div class="bg-white/90 p-6 rounded-2xl backdrop-blur-sm border border-white/80 relative z-10 shadow-sm">
             <p :class="riskLevel === 'HIGH' ? 'text-clay-800' : 'text-healing-800'" class="leading-relaxed font-medium">
                <span v-if="riskLevel === 'HIGH'">
                  ⚠️ 提示：评估结果显示该来访者存在需要关注的心理特征。建议安排专业咨询师进行一对一访谈，并关注其情绪与行为变化。建议启动【二级干预预案】。
                </span>
                <span v-else>
                  ✅ 结论：评估结果显示心理状况平稳，各项指标均在正常范围内。建议继续保持当前状态，定期进行心理健康维护。
                </span>
             </p>
             
             <!-- 发起干预按钮 -->
             <div v-if="isCounselor" class="mt-6 flex justify-end">
               <button 
                 @click="initiateIntervention"
                 class="px-6 py-3 rounded-xl font-bold text-white shadow-lg transition-all hover:scale-105 active:scale-95 flex items-center gap-2"
                 :class="riskLevel === 'HIGH' ? 'bg-clay-500 hover:bg-clay-600 shadow-clay-500/20' : 'bg-healing-500 hover:bg-healing-600 shadow-healing-500/20'"
               >
                 <span>⚡</span> {{ riskLevel === 'HIGH' ? '立即发起干预' : '制定跟进计划' }}
               </button>
             </div>
          </div>
        </div>
      </div>
      
      <!-- 页脚 -->
      <div class="report-footer bg-cream-50 p-8 rounded-b-[2rem] border-t border-cream-200 text-center">
        <p class="text-rock-400 text-xs italic mb-6">
          * 本报告由 PsycheGuard 智能评估系统自动生成，仅供咨询参考，不作为最终医疗诊断依据。
        </p>
        <div class="flex flex-col md:flex-row justify-between items-center gap-4 pt-6 border-t border-cream-200 border-dashed text-rock-500 text-xs font-mono">
          <div>Report generated by PsycheGuard AI</div>
          <div>{{ new Date().toLocaleString() }}</div>
        </div>
      </div>
    </div>

    <!-- 底部固定浮动操作栏 -->
    <div class="fixed-action-bar">
      <div class="action-bar-inner">
        <button v-if="isCounselor" @click="goBack"
          class="action-btn action-btn-back">
          <ArrowLeft :size="16" />
          <span>返回列表</span>
        </button>
        <button v-else @click="goBackToClientDashboard"
          class="action-btn action-btn-back">
          <ArrowLeft :size="16" />
          <span>返回</span>
        </button>

        <button
          :disabled="isExporting"
          @click="downloadPDF"
          class="action-btn action-btn-export"
        >
          <Download :size="16" />
          <span v-if="isExporting">生成中...</span>
          <span v-else>打印报告</span>
        </button>
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
import { ElMessage, ElLoading } from 'element-plus'

const route = useRoute()
const router = useRouter()

// ========== 量表配置字典 ==========
// 定义不同量表的维度名称映射和满分标准
const SCALE_CONFIGS: Record<string, any> = {
  // 精神病态量表 (PCL-R)
  'PCL-R': {
    labels: { 
      '人际操控': '人际关系', 
      '情感冷漠': '情感反应', 
      '感觉寻求': '行为模式', 
      '冲动控制': '冲动性',
      '认知扭曲': '认知模式', 
      '情感': '情感稳定性',
      '反社会': '社会适应', 
      '生活方式': '生活方式' 
    },
    maxScores: { 
      '人际操控': 8, '情感冷漠': 8, '感觉寻求': 10, '冲动控制': 10, 
      '认知扭曲': 8, '情感': 8, '反社会': 10, '生活方式': 10 
    }
  },
  // 焦虑自评量表 (SAS)
  'SAS': {
    labels: { '躯体性': '躯体症状', '精神性': '精神症状' },
    maxScores: { '躯体性': 40, '精神性': 40 }
  },
  // 抑郁自评量表 (SDS)
  'SDS': {
    labels: { '核心抑郁': '核心抑郁', '生理机能': '生理机能' },
    maxScores: { '核心抑郁': 40, '生理机能': 40 }
  },
  // 默认兜底配置
  'DEFAULT': { 
    labels: {}, 
    defaultMax: 10 
  }
}

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
const maxScore = ref(0)
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
    maxScore.value = data.maxScore
    isTeachingCase.value = !!data.isTeachingCase
    expertAnnotation.value = data.expertAnnotation || ''
    
    // ========== 动态量表适配逻辑 ==========
    // 1. 确定当前量表类型
    const currentScaleKey = data.scaleName || 
      (data.scaleId === 3 ? 'SAS' : (data.scaleId === 2 ? 'SDS' : 'PCL-R'))
    
    // 2. 获取对应的配置（如果没有则使用 DEFAULT）
    const config = SCALE_CONFIGS[currentScaleKey] || SCALE_CONFIGS['DEFAULT']
    
    // 3. 提取维度数据
    const dimensionData: Record<string, number> = data.dimensionAnalysis || data.dimensionScore || {}
    const rawKeys = Object.keys(dimensionData)
    
    // 4. 动态生成雷达图指标
    const indicators = rawKeys.map(dimensionName => {
      // 使用配置中的标签映射，如果不存在则使用原始名称
      const displayName = config.labels[dimensionName] || dimensionName
      
      // 使用配置中的最大值，如果不存在则使用默认值或动态计算
      const actualValue = dimensionData[dimensionName] || 0
      const configuredMax = config.maxScores?.[dimensionName]
      const calculatedMax = Math.max(Math.ceil(actualValue * 1.2), 10)
      const max = configuredMax || config.defaultMax || calculatedMax
      
      return { name: displayName, max }
    })
    
    // 5. 提取维度分数值
    const values = rawKeys.map((k, i) => Math.min((indicators[i].max as number), dimensionData[k] || 0))

    if (chartRef.value) {
      const chart = echarts.init(chartRef.value)
      const isHigh = riskLevel.value === 'HIGH'
      
      // Theme Colors
      const mainColor = isHigh ? '#E07A5F' : '#6B9080' // Clay or Healing
      const areaColor = isHigh ? 'rgba(224, 122, 95, 0.2)' : 'rgba(107, 144, 128, 0.2)'
      
      // 根据维度数量选择图表类型
      const dimensionCount = indicators.length
      const useBarChart = dimensionCount < 5 // 维度数 < 5 使用柱状图
      
      if (useBarChart) {
        // 柱状图配置 (适合 2-4 个维度)
        chart.setOption({
          tooltip: { 
            trigger: 'axis',
            backgroundColor: 'rgba(255,255,255,0.9)',
            borderColor: '#EBE6E0',
            textStyle: { color: '#4A4E69' },
            axisPointer: { type: 'shadow' }
          },
          grid: { 
            left: '15%', 
            right: '10%', 
            bottom: '15%', 
            top: '10%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            data: indicators.map(i => i.name),
            axisLabel: { 
              rotate: 0, 
              fontSize: 13, 
              fontWeight: 'bold',
              color: '#7B7B8D'
            },
            axisLine: { lineStyle: { color: '#EBE6E0' } },
            axisTick: { show: false }
          },
          yAxis: {
            type: 'value',
            name: '得分',
            nameTextStyle: { 
              fontSize: 12, 
              fontWeight: 'bold',
              color: '#7B7B8D'
            },
            max: function(value) { 
              const maxVal = Math.max(...indicators.map(i => i.max as number))
              return Math.ceil(maxVal * 1.1) 
            },
            axisLabel: { fontSize: 11, color: '#A7A7B3' },
            splitLine: { lineStyle: { color: '#F6F4F1', type: 'dashed' } }
          },
          series: [{
            type: 'bar',
            data: values.map((v, i) => ({
              value: v,
              itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  { offset: 0, color: mainColor },
                  { offset: 1, color: areaColor }
                ]),
                borderRadius: [8, 8, 0, 0]
              }
            })),
            barWidth: '50%',
            label: {
              show: true,
              position: 'top',
              formatter: '{c}',
              fontWeight: 'bold',
              fontSize: 12,
              color: mainColor
            }
          }]
        })
      } else {
        // 雷达图配置 (适合 5+ 个维度)
        chart.setOption({
          tooltip: { trigger: 'item', backgroundColor: 'rgba(255,255,255,0.9)', borderColor: '#EBE6E0', textStyle: { color: '#4A4E69' } },
          radar: {
            indicator: indicators,
            shape: 'circle',
            splitNumber: 4,
            axisName: {
              formatter: (value: string) => value,
              color: '#7B7B8D', // rock-600
              fontSize: 12,
              fontWeight: '600'
            },
            splitLine: { lineStyle: { color: '#EBE6E0' } }, // cream-200
            splitArea: { show: true, areaStyle: { color: ['#F6F4F1', '#fff'] } },
            axisLine: { lineStyle: { color: '#D2DDD8' } } // healing-light
          },
          series: [{
            name: '心理特征画像',
            type: 'radar',
            data: [{
              value: values,
              name: subjectName.value,
              itemStyle: { color: mainColor },
              areaStyle: { color: areaColor },
              lineStyle: { width: 3, color: mainColor },
              symbol: 'circle',
              symbolSize: 6
            }]
          }]
        })
      }
      
      window.addEventListener('resize', () => chart.resize())
    }
  } catch (error: any) {
    const status = error?.response?.status
    if (status === 404) {
      ElMessage.warning('评估记录不存在')
      return router.replace(isCounselor.value ? '/history' : '/test')
    }
  }
})

function goBack() { router.push(isCounselor.value ? '/history' : '/test') }

function goBackToClientDashboard() {
  router.push('/client-dashboard')
}

function goLogin() {
  localStorage.clear()
  router.replace('/login')
}

// ... unchanged logic for pdf download ... 
// 为了节省token, 省略未修改的 downloadPDF 实现细节，保持原样逻辑即可，但由于 write_to_file 是覆盖写入，我必须完整提供
async function downloadPDF() {
  if (isExporting.value) return
  isExporting.value = true
  const loadingInstance = ElLoading.service({
    lock: true,
    text: '正在生成专业报告，请稍候...',
    background: 'rgba(255, 255, 255, 0.8)'
  })
  
  try {
    const el = document.querySelector('.medical-report') as HTMLElement
    if (!el) return
    
    // Lazy load
    const html2canvas = (await import('html2canvas')).default
    const { jsPDF } = await import('jspdf')
    
    const canvas = await html2canvas(el, {
      scale: 2,
      useCORS: true,
      backgroundColor: '#F6F4F1', // Cream background
      ignoreElements: (element) => element.tagName === 'BUTTON'
    })
    
    const imgData = canvas.toDataURL('image/png')
    const pdf = new jsPDF({
      orientation: 'p',
      unit: 'px',
      format: [canvas.width, canvas.height]
    })
    
    pdf.addImage(imgData, 'PNG', 0, 0, canvas.width, canvas.height)
    pdf.save(`PsycheGuard_Report_${id}.pdf`)
  } catch (e) {
    ElMessage.error('导出失败')
  } finally {
    loadingInstance.close()
    isExporting.value = false
  }
}

async function saveAnnotation() {
  try {
    await axios.put(`/api/assessments/${id}/annotate`, { isTeachingCase: isTeachingCase.value, annotation: expertAnnotation.value })
    ElMessage.success('专家批注已保存')
  } catch (error) { ElMessage.error('保存失败') }
}

async function addToTeachingLibrary() {
  try {
    isTeachingCase.value = true
    await saveAnnotation()
    ElMessage.success('成功加入经典案例库')
  } catch (e) { ElMessage.error('操作失败') }
}

function initiateIntervention() {
  router.push({
    path: '/intervention',
    query: {
      targetId: id,
      targetName: subjectName.value,
      riskLevel: riskLevel.value
    }
  })
}
</script>

<style scoped>
.result-container { font-family: 'Inter', sans-serif; padding-bottom: 100px; }
.medical-report {
  width: 100%;
  max-width: 800px;
  background: #ffffff;
  border-radius: 2rem;
  box-shadow: 0 20px 60px -15px rgba(74, 78, 105, 0.1);
  overflow: hidden;
}

/* 底部固定浮动操作栏 */
.fixed-action-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 999;
  padding: 12px 16px;
  background: rgba(246, 244, 241, 0.85);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-top: 1px solid rgba(235, 230, 224, 0.6);
  box-shadow: 0 -4px 24px rgba(74, 78, 105, 0.08);
}
.action-bar-inner {
  max-width: 800px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}
.action-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 14px;
  border: none;
  cursor: pointer;
  transition: all 0.2s ease;
}
.action-btn:hover { transform: translateY(-1px); }
.action-btn:active { transform: translateY(0); }
.action-btn-back {
  background: rgba(255, 255, 255, 0.9);
  color: #5C5F77;
  border: 1px solid rgba(235, 230, 224, 0.8);
  box-shadow: 0 2px 8px rgba(74, 78, 105, 0.06);
}
.action-btn-back:hover { background: #fff; box-shadow: 0 4px 12px rgba(74, 78, 105, 0.1); }
.action-btn-export {
  background: #6B9080;
  color: #fff;
  box-shadow: 0 4px 12px rgba(107, 144, 128, 0.25);
}
.action-btn-export:hover { background: #557366; box-shadow: 0 6px 16px rgba(107, 144, 128, 0.35); }
.action-btn-export:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

@media print {
  .fixed-action-bar { display: none; }
}

/* 呼吸光斑 */
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}
.animate-blob { animation: blob 10s infinite; }
.animation-delay-2000 { animation-delay: 2s; }

/* 覆盖 Element UI 文本域样式 */
:deep(.el-textarea__inner) {
  border-radius: 12px !important;
  padding: 16px !important;
  border-color: #EBE6E0 !important;
  background-color: #FFFFFF !important;
  font-family: inherit;
  color: #4A4E69 !important;
  box-shadow: none !important;
  border: 1px solid #EBE6E0;
}
:deep(.el-textarea__inner:focus) {
  border-color: #6B9080 !important;
}

/* === 色彩补丁 === */
.bg-cream-50 { background-color: #FBF9F7 !important; }
.bg-cream-100 { background-color: #F6F4F1 !important; }
.bg-cream-200 { background-color: #EBE6E0 !important; }
.bg-cream-300 { background-color: #D8D3CD !important; }

.text-rock-800 { color: #4A4E69 !important; }
.text-rock-700 { color: #5C5F77 !important; }
.text-rock-600 { color: #7B7B8D !important; }
.text-rock-500 { color: #8F91A3 !important; }
.text-rock-400 { color: #A7A7B3 !important; }

.bg-healing-50 { background-color: #F0F7F4 !important; }
.bg-healing-100 { background-color: #E1EFE9 !important; }
.bg-healing-200 { background-color: #C2DFCE !important; }
.bg-healing-500 { background-color: #6B9080 !important; }
.bg-healing-600 { background-color: #557366 !important; }
.text-healing-500 { color: #6B9080 !important; }
.text-healing-600 { color: #557366 !important; }
.text-healing-800 { color: #2C4A3E !important; }

.bg-clay-100 { background-color: #FBECE8 !important; }
.bg-clay-200 { background-color: #F0BCAE !important; }
.bg-clay-500 { background-color: #E07A5F !important; }
.text-clay-600 { color: #B3614C !important; }
.text-clay-800 { color: #7A3525 !important; }
.border-clay-100 { border-color: #FBECE8 !important; }
.border-clay-200 { border-color: #F0BCAE !important; }
</style>
