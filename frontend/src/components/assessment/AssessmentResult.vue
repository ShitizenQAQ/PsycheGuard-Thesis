<template>
  <div class="w-full max-w-2xl mx-auto fade-up">
    <!-- HIGH RISK - 危机干预视图 -->
    <div v-if="riskLevel === 'HIGH'" class="bg-white/80 backdrop-blur-xl border-2 border-clay-200 p-8 md:p-12 rounded-[3rem] shadow-2xl shadow-clay-500/20">
      <div class="flex flex-col items-center text-center mb-8">
        <div class="w-20 h-20 rounded-full bg-clay-100 flex items-center justify-center mb-6 animate-pulse">
          <svg class="w-10 h-10 text-clay-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
        </div>
        <h2 class="text-2xl font-bold text-clay-600 mb-3">检测到您当前情绪波动较大</h2>
        <p class="text-rock-600 text-sm leading-relaxed max-w-md">测评结果显示您可能正在经历一定程度的心理压力。请不要担心，这是可以改善的，我们建议您及时寻求专业支持。</p>
      </div>

      <!-- 危机干预资源 -->
      <div class="bg-clay-50 border border-clay-200 rounded-2xl p-6 mb-8">
        <h3 class="text-lg font-bold text-clay-700 mb-4 flex items-center gap-2">📞 寻求帮助</h3>
        <div class="space-y-3">
          <div class="flex items-start gap-3 bg-white p-4 rounded-xl border border-clay-100">
            <span class="text-2xl">🚨</span>
            <div class="flex-1">
              <p class="font-bold text-rock-800">24小时心理援助热线</p>
              <p class="text-clay-600 text-lg font-mono font-bold mt-1">400-161-9995</p>
            </div>
          </div>
          <button @click="$emit('contact')" class="w-full bg-clay-500 text-white font-bold py-4 rounded-xl shadow-lg hover:bg-clay-600 transition-all">联系在线咨询师</button>
        </div>
      </div>

      <div class="flex flex-col sm:flex-row items-center gap-3">
        <button class="w-full sm:w-auto px-6 py-3 rounded-xl border-2 border-clay-200 text-clay-600 bg-white hover:bg-clay-50 font-bold transition-colors" @click="$emit('back')">返回测评中心</button>
        <button class="w-full sm:w-auto px-6 py-3 rounded-xl bg-clay-500 text-white hover:bg-clay-600 font-bold transition-all flex-1" @click="$emit('view-report')">查看详细报告</button>
      </div>
    </div>

    <!-- LOW/MEDIUM RISK - 治愈系视图 -->
    <div v-else class="bg-white/80 backdrop-blur-xl border border-healing-200 p-8 md:p-12 rounded-[3rem] shadow-xl shadow-healing-500/10">
      <div class="flex flex-col items-center text-center mb-8">
        <div class="w-20 h-20 rounded-full bg-healing-100 flex items-center justify-center mb-6 text-healing-600">
          <CheckCircle :size="40" />
        </div>
        <h2 class="text-2xl font-bold text-rock-800 mb-3">测评已完成</h2>
        <p class="text-rock-600 leading-relaxed max-w-md">您的心理状态报告已生成。根据评估结果，您当前的心理健康状况良好，请继续保持积极的生活态度。</p>
      </div>

      <div class="bg-healing-50 border border-healing-100 rounded-2xl p-6 mb-8">
        <h3 class="text-sm font-bold text-healing-700 mb-2">💡 温馨提示</h3>
        <p class="text-sm text-rock-600 leading-relaxed">定期进行心理健康自评有助于及时发现潜在问题。建议您保持对自身状态的关注。</p>
      </div>

      <div class="flex flex-col sm:flex-row items-center gap-3">
        <button class="w-full sm:w-auto px-6 py-3 rounded-xl border-2 border-cream-200 text-rock-600 bg-white hover:bg-cream-50 font-bold transition-colors" @click="$emit('back')">返回测评中心</button>
        <button class="w-full sm:w-auto px-6 py-3 rounded-xl bg-healing-500 text-white hover:bg-healing-600 font-bold transition-all flex-1" @click="$emit('view-report')">查看详细报告</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { CheckCircle } from 'lucide-vue-next'

defineProps<{
  riskLevel: string
}>()

defineEmits<{
  (e: 'back'): void
  (e: 'view-report'): void
  (e: 'contact'): void
}>()
</script>
