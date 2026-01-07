<template>
  <div class="min-h-screen w-full relative flex items-center justify-center bg-slate-50 overflow-hidden">
    
    <div 
      class="absolute w-[600px] h-[600px] rounded-full mix-blend-multiply filter blur-[80px] opacity-40 transition-all duration-1000 ease-in-out"
      :class="blobClasses.blob1"
    ></div>
    
    <div 
      class="absolute w-[600px] h-[600px] rounded-full mix-blend-multiply filter blur-[80px] opacity-40 transition-all duration-1000 ease-in-out"
      :class="blobClasses.blob2"
    ></div>
    
    <div 
      class="absolute w-[500px] h-[500px] rounded-full mix-blend-multiply filter blur-[80px] opacity-40 transition-all duration-1000 ease-in-out"
      :class="blobClasses.blob3"
    ></div>

    <div 
      class="relative z-10 w-full max-w-md px-6 transition-all duration-500"
      :class="{ 'opacity-0 scale-90': loginState === 'success', 'animate-shake': loginState === 'error' }"
    >
      <div class="bg-white/60 backdrop-blur-xl border border-white/50 p-10 rounded-[2.5rem] shadow-2xl shadow-blue-900/10">
        
        <div class="flex flex-col items-center text-center">
          <div class="w-16 h-16 rounded-2xl bg-gradient-to-tr from-cyan-500 to-blue-600 shadow-lg shadow-cyan-500/40 flex items-center justify-center text-white text-xl font-bold mb-6 transform hover:rotate-12 transition-transform duration-500">
            PG
          </div>
          <h1 class="text-3xl font-bold text-slate-800 tracking-tight">PsycheGuard</h1>
          <h1 class="text-3xl font-bold text-slate-800 tracking-tight">PsycheGuard</h1>
          <p class="mt-2 text-sm text-slate-500 font-medium">心理测评与分级预警系统</p>
        </div>

        <div class="mt-10 space-y-5">
          <div class="relative group">
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
              <el-icon class="text-slate-400 group-focus-within:text-cyan-600 transition-colors"><User /></el-icon>
            </div>
            <input 
              v-model="username" 
              type="text" 
              placeholder="请输入用户名 / 编号" 
              class="w-full pl-11 pr-4 py-3.5 rounded-xl bg-white/50 border border-slate-200 text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-cyan-500/50 focus:border-cyan-500 transition-all focus:bg-white"
              @keyup.enter="doLogin"
              :disabled="loginState === 'loading' || loginState === 'success'"
            />
          </div>

          <div class="relative group">
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
              <el-icon class="text-slate-400 group-focus-within:text-cyan-600 transition-colors"><Lock /></el-icon>
            </div>
            <input 
              v-model="password" 
              type="password" 
              placeholder="请输入密码" 
              class="w-full pl-11 pr-4 py-3.5 rounded-xl bg-white/50 border border-slate-200 text-slate-700 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-cyan-500/50 focus:border-cyan-500 transition-all focus:bg-white"
              @keyup.enter="doLogin"
              :disabled="loginState === 'loading' || loginState === 'success'"
            />
          </div>

          <button 
            class="w-full py-3.5 rounded-xl bg-slate-900 text-white font-bold text-lg shadow-xl shadow-slate-900/20 hover:bg-slate-800 hover:shadow-slate-900/30 active:scale-[0.98] transition-all flex items-center justify-center gap-2 disabled:opacity-70 disabled:cursor-not-allowed"
            @click="doLogin"
            :disabled="loginState === 'loading' || loginState === 'success'"
          >
            <span v-if="loginState === 'loading'" class="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
            <span>{{ btnText }}</span>
          </button>
        </div>

        <div class="mt-8 text-center">
          <p class="text-xs text-slate-400">System Version v2.5.0 · Secure Access</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock } from '@element-plus/icons-vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const router = useRouter()
const username = ref('')
const password = ref('')

// 状态机：'idle'(空闲) | 'loading'(请求中) | 'success'(成功聚拢) | 'error'(失败抖动)
type LoginState = 'idle' | 'loading' | 'success' | 'error'
const loginState = ref<LoginState>('idle')

// 计算按钮文字
const btnText = computed(() => {
  if (loginState.value === 'loading') return '验证中...'
  if (loginState.value === 'success') return '验证通过'
  return '安全登录'
})

// 计算光球的样式类
const blobClasses = computed(() => {
  // 1. 成功状态：所有光球聚到中心 (top-1/2 left-1/2)，颜色变亮，变大
  if (loginState.value === 'success') {
    return {
      blob1: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 scale-150 bg-cyan-500 opacity-80',
      blob2: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 scale-150 bg-blue-600 opacity-80 delay-100',
      blob3: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 scale-150 bg-purple-500 opacity-80 delay-200'
    }
  }
  
  // 2. 失败状态：光球变红，保持散开
  if (loginState.value === 'error') {
    return {
      blob1: 'top-[-10%] left-[-10%] bg-red-400 animate-blob',
      blob2: 'bottom-[-10%] right-[-10%] bg-rose-500 animate-blob animation-delay-2000',
      blob3: 'top-[20%] right-[20%] bg-orange-400 animate-blob animation-delay-4000'
    }
  }

  // 3. 默认状态：散开，原本的颜色，呼吸动画
  return {
    blob1: 'top-[-10%] left-[-10%] bg-cyan-400 animate-blob',
    blob2: 'bottom-[-10%] right-[-10%] bg-blue-500 animate-blob animation-delay-2000',
    blob3: 'top-[20%] right-[20%] bg-purple-400 animate-blob animation-delay-4000'
  }
})

async function doLogin() {
  if (!username.value || !password.value) {
    ElMessage.warning('请输入用户名和密码')
    // 触发简单的错误抖动
    loginState.value = 'error'
    setTimeout(() => { loginState.value = 'idle' }, 500)
    return
  }
  
  loginState.value = 'loading'
  
  try {
    const res = await axios.post('/api/login', { username: username.value, password: password.value })
    // The backend now returns { token: '...', user: {...} }
    // We need to adjust extraction logic
    const data = res.data
    const token = data.token
    const user = data.user
    
    // 存储数据
    localStorage.setItem('pg_token', token)
    localStorage.setItem('pg_user', JSON.stringify(user))
    localStorage.setItem('user_role', user.role || '')
    localStorage.setItem('user_id', String(user.id || ''))

    // --- 关键时刻：触发成功动画 ---
    // 1. 设置状态为 success -> 光球聚拢，登录卡片消失
    loginState.value = 'success'

    // 2. 等待动画执行完 (1秒) 后再跳转
    setTimeout(() => {
      const role = user.role
      if (role === 'ROLE_COUNSELOR') {
        ElMessage.success(`欢迎回来，${user.realName || user.username}`)
        router.replace('/dashboard')
      } else {
        ElMessage.success(`欢迎进入，${user.realName || user.username}`)
        router.replace('/test')
      }
    }, 800) // 800ms 稍微小于动画的 1000ms，衔接感更好

  } catch (e: any) {
    // --- 触发失败动画 ---
    loginState.value = 'error'
    ElMessage.error(e.response?.data?.message || '登录失败，请检查账号密码')
    
    // 震动完后恢复原状
    setTimeout(() => {
      loginState.value = 'idle'
    }, 500)
  }
}
</script>

<style scoped>
/* 呼吸动画 */
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.2); }
  66% { transform: translate(-20px, 20px) scale(0.8); }
  100% { transform: translate(0px, 0px) scale(1); }
}
.animate-blob { animation: blob 7s infinite; }
.animation-delay-2000 { animation-delay: 2s; }
.animation-delay-4000 { animation-delay: 4s; }

/* 错误时的震动动画 */
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
  20%, 40%, 60%, 80% { transform: translateX(5px); }
}
.animate-shake { animation: shake 0.4s cubic-bezier(.36,.07,.19,.97) both; }
</style>