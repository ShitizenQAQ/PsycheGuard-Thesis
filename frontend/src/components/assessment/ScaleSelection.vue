<template>
  <div class="w-full max-w-5xl fade-up">
    <div class="text-center mb-10">
      <h2 class="text-3xl font-black text-rock-800 mb-3 tracking-tight">测评中心</h2>
      <p class="text-rock-500 font-medium tracking-wide">请选择一个您想进行的心理状态评估</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div 
        v-for="scale in scales" 
        :key="scale.id"
        class="group bg-white rounded-[2rem] p-6 shadow-sm border border-cream-200 hover:border-healing-200 hover:shadow-healing-500/20 transition-all duration-300 hover:-translate-y-1 cursor-pointer"
        @click="$emit('select', scale.id)"
      >
        <div class="w-14 h-14 rounded-2xl bg-healing-50 mb-6 flex items-center justify-center text-healing-600 group-hover:bg-healing-500 group-hover:text-white transition-colors">
          <span class="font-bold text-xl">{{ scale.name.charAt(0) }}</span>
        </div>
        <h3 class="text-xl font-bold text-rock-800 mb-2">{{ scale.name }}</h3>
        <p class="text-sm text-rock-500 mb-6 line-clamp-2 leading-relaxed">{{ scale.description || '专业心理评估量表，助您了解当前心理状态。' }}</p>
        <div class="w-full py-3 rounded-xl bg-healing-50 text-healing-600 font-bold group-hover:bg-healing-500 group-hover:text-white transition-all text-center">
          立即开始
        </div>
      </div>
    </div>

    <!-- 备选退出方式 -->
    <div class="mt-12 text-center">
       <button @click="$emit('back')" class="text-rock-400 hover:text-rock-600 text-sm font-bold border-b border-transparent hover:border-rock-200 pb-1 transition-all">
         暂不测评，返回首页
       </button>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  scales: Array<{ id: number; name: string; description?: string }>
}>()

defineEmits<{
  (e: 'select', id: number): void
  (e: 'back'): void
}>()
</script>
