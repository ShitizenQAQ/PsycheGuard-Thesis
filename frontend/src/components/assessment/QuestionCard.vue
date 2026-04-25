<template>
  <div class="w-full">
    <!-- 加载状态 -->
    <div v-if="loading" class="text-center py-20">
      <div class="w-12 h-12 border-4 border-healing-200 border-t-healing-500 rounded-full animate-spin mx-auto mb-4"></div>
      <p class="text-rock-500 font-bold">正在载入量表内容...</p>
    </div>

    <!-- 题目渲染逻辑 -->
    <div v-else-if="question" class="w-full">
      <!-- 进度条 -->
      <div class="max-w-2xl mx-auto mb-10 px-4">
        <div class="flex justify-between text-[11px] font-black uppercase tracking-widest text-rock-400 mb-3">
          <span>Progress: {{ index + 1 }} / {{ total }}</span>
          <span class="text-healing-600">{{ Math.round(((index + 1) / total) * 100) }}%</span>
        </div>
        <div class="h-1.5 w-full bg-cream-200 rounded-full overflow-hidden">
          <div class="h-full bg-healing-500 transition-all duration-500" :style="{ width: `${((index + 1) / total) * 100}%` }"></div>
        </div>
      </div>

      <!-- 题目卡片 -->
      <div :class="[
        'bg-white rounded-[2.5rem] shadow-xl border-2 overflow-hidden max-w-2xl mx-auto flex flex-col min-h-[450px] transition-all duration-300',
        highlightMissing ? 'border-red-400 highlight-pulse' : 'border-cream-200'
      ]">
         <!-- 漏答高亮提示条 -->
         <div v-if="highlightMissing" class="bg-red-50 px-6 py-3 text-red-600 text-sm font-bold flex items-center gap-2 border-b border-red-100 animate-fade-in">
           <svg class="w-5 h-5 animate-bounce flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
             <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
           </svg>
           <span>⚠️ 本题尚未作答，请选择一个选项后再提交</span>
         </div>
         
         <!-- 咨询师端头部：来访者信息 -->
         <div v-if="roleInfo.role === 'ROLE_COUNSELOR'" class="bg-cream-50 px-6 py-4 flex flex-wrap items-center justify-between gap-4 border-b border-cream-200">
            <div class="flex items-center gap-3">
              <button @click="$emit('back-list')" class="text-xs font-bold text-rock-400 hover:text-rock-600 flex items-center gap-1 bg-white px-3 py-2 rounded-lg border border-cream-200 hover:border-healing-200 transition-all">
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
                返回列表
              </button>
              <div class="h-6 w-px bg-cream-300"></div>
              <img :src="roleInfo.avatar" class="w-10 h-10 rounded-xl border-2 border-white shadow-sm" :alt="roleInfo.targetName" />
              <div>
                <div class="text-sm font-bold text-rock-800">{{ roleInfo.targetName }}</div>
                <div class="text-[10px] font-mono text-rock-400">ID: {{ roleInfo.targetId }}</div>
              </div>
            </div>
            <!-- 咨询师端不直接在这里更换量表，简化逻辑，需返回列表重选或由父组件传递列表 -->
            <div class="flex items-center gap-3" v-if="scaleList && scaleList.length > 0">
               <span class="text-xs text-rock-400 font-bold">切换量表:</span>
               <el-select 
                 :model-value="currentScaleId" 
                 @update:model-value="(val: number) => $emit('change-scale', val)"
                 placeholder="选择量表" 
                 size="small"
                 style="width: 140px" 
                 class="!rounded-xl"
               >
                 <el-option v-for="s in scaleList" :key="s.id" :label="s.name" :value="s.id" />
               </el-select>
            </div>
         </div>

         <!-- 来访者端头部：更换量表按钮 -->
         <div v-else class="bg-cream-50 px-8 py-4 flex justify-between items-center border-b border-cream-200">
            <button @click="$emit('back-scale-list')" class="text-xs font-bold text-rock-400 hover:text-rock-600 flex items-center gap-1">
              <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
              更换量表
            </button>
            <span class="text-xs font-black text-healing-600 uppercase tracking-widest">{{ scaleName }}</span>
         </div>

         <div class="p-10 md:p-14 flex-1 flex flex-col">
            <div class="inline-block px-3 py-1 rounded-full bg-healing-50 text-healing-600 text-[10px] font-black uppercase tracking-widest mb-6 w-fit">
               {{ question.dimension || '综合' }}
            </div>
            
            <h2 class="text-2xl md:text-3xl font-black text-rock-800 leading-tight mb-auto">
               {{ question.content }}
            </h2>

            <div class="grid grid-cols-1 gap-3 mt-12">
               <button
                v-for="opt in options"
                :key="opt.score"
                @click="$emit('answer', question.id, opt.score)"
                :class="[
                  'w-full text-left py-4 px-6 rounded-2xl border-2 font-bold transition-all duration-200 flex items-center justify-between group',
                  answer === opt.score
                    ? 'bg-healing-500 border-healing-500 text-white shadow-lg'
                    : 'bg-white border-cream-200 text-rock-600 hover:border-healing-200 hover:bg-healing-50'
                ]"
              >
                <span>{{ opt.label }}</span>
                <div v-if="answer === opt.score" class="w-5 h-5 bg-white/20 rounded-full flex items-center justify-center">✓</div>
              </button>
            </div>
         </div>

         <!-- 底部控制栏 -->
         <div class="bg-cream-50 p-6 flex justify-between items-center">
            <button v-if="index > 0" @click="$emit('prev')" class="text-sm font-bold text-rock-400 hover:text-rock-600 px-4">上一题</button>
            <div v-else></div>

            <button 
              v-if="index === total - 1" 
              @click="$emit('submit')" 
              :disabled="submitLoading" 
              class="px-8 py-3 bg-healing-500 text-white font-bold rounded-xl shadow-lg shadow-healing-500/30 hover:bg-healing-600 transition-all disabled:opacity-50"
            >
              {{ submitLoading ? '提交中...' : '提交结果' }}
            </button>
            <button 
              v-else 
              @click="$emit('next')" 
              class="px-8 py-3 bg-rock-800 text-white font-bold rounded-xl shadow-lg hover:bg-rock-900 transition-all disabled:opacity-30 disabled:cursor-not-allowed" 
              :disabled="answer === undefined"
            >
              下一题
            </button>
         </div>
      </div>
    </div>

    <!-- 🚑 修复提示：当题目真的为空时 -->
    <div v-else class="w-full flex justify-center fade-up">
       <div class="bg-white p-12 rounded-[3rem] border border-cream-200 shadow-xl max-w-md w-full text-center">
          <div class="w-16 h-16 bg-amber-50 rounded-full flex items-center justify-center mx-auto mb-6 text-amber-500 text-3xl font-bold">!</div>
          <h3 class="text-xl font-bold text-rock-800 mb-2">抱歉，量表未就绪</h3>
          <p class="text-rock-500 text-sm mb-10 leading-relaxed">该量表目前尚未配置测试题目，请联系咨询师或等待系统更新。</p>
          <div class="flex flex-col gap-3">
             <el-button type="primary" round class="!bg-healing-500 !border-healing-500 !h-12 !font-bold" @click="$emit('back-scale-list')">选择其它量表</el-button>
             <el-button round class="!h-12 !font-bold !text-rock-400" @click="$emit('back-home')">返回首页</el-button>
          </div>
       </div>
    </div>
  </div>
</template>

<script setup lang="ts">

type Option = { label: string; score: number }
type Question = { id: number; content: string; options: Option[]; dimension?: string }

defineProps<{
  loading: boolean
  question?: Question
  options: Option[]
  index: number
  total: number
  answer?: number
  scaleName: string
  submitLoading: boolean
  highlightMissing: boolean
  roleInfo: {
    role: string
    targetName?: string
    targetId?: string | number
    avatar?: string
  }
  scaleList?: Array<{id: number, name: string}>
  currentScaleId?: number
}>()

defineEmits<{
  (e: 'answer', qId: number, score: number): void
  (e: 'next'): void
  (e: 'prev'): void
  (e: 'submit'): void
  (e: 'back-list'): void
  (e: 'back-scale-list'): void
  (e: 'change-scale', id: number): void
  (e: 'back-home'): void
}>()
</script>

<style scoped>
@keyframes highlight-pulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(239, 68, 68, 0); }
  50% { box-shadow: 0 0 0 8px rgba(239, 68, 68, 0.15); }
}
.highlight-pulse {
  animation: highlight-pulse 0.8s ease-in-out 3;
}
@keyframes fade-in {
  from { opacity: 0; transform: translateY(-8px); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-fade-in {
  animation: fade-in 0.3s ease-out;
}
</style>
