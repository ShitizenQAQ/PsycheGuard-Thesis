<template>
  <div class="min-h-screen w-full flex flex-row bg-white overflow-hidden font-sans relative">
    
    <!-- 转场动画遮罩层 -->
    <Transition name="fade-scale">
      <div v-if="showWelcome" class="fixed inset-0 z-50 flex items-center justify-center bg-[#F0F7F4]/90 backdrop-blur-3xl">
        <div class="text-center space-y-6 animate-float">
          <!-- 治愈系图标 -->
          <div class="relative inline-block">
             <div class="absolute inset-0 bg-[#6B9080]/20 rounded-full blur-xl animate-pulse"></div>
             <svg class="w-24 h-24 text-[#6B9080] relative z-10" fill="currentColor" viewBox="0 0 24 24">
               <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
             </svg>
          </div>
          
          <div class="space-y-2">
            <h2 class="text-3xl font-black text-slate-800 tracking-tight">欢迎回来，{{ welcomeName }}</h2>
            <p class="text-lg text-[#557366] font-medium animate-pulse">PsycheGuard 正在为您准备安全空间...</p>
          </div>
        </div>
      </div>
    </Transition>

    <!-- 左侧：登录表单区 (45%) -->
    <div 
      class="w-full md:w-[45%] xl:w-[40%] flex flex-col justify-center px-8 md:px-16 lg:px-24 xl:px-32 relative z-10 bg-white transition-all duration-700 ease-out"
      :class="{ 'opacity-0 scale-95 blur-sm': showWelcome }"
    >
      
      <!-- Logo (Mobile Only) -->
      <div class="md:hidden absolute top-8 left-8 flex items-center gap-3">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-[#6B9080] to-[#557366] flex items-center justify-center text-white font-bold shadow-lg shadow-[#6B9080]/30">PG</div>
        <span class="text-rock-800 font-bold text-lg tracking-tight">PsycheGuard</span>
      </div>

      <div class="space-y-10 fade-in-up">
        <!-- 头部标题 -->
        <div class="space-y-3">
          <div class="w-12 h-12 rounded-2xl bg-gradient-to-br from-[#6B9080] to-[#557366] hidden md:flex items-center justify-center text-white font-bold text-xl shadow-xl shadow-[#6B9080]/20 mb-6">PG</div>
          <h1 class="text-4xl md:text-5xl font-black text-slate-800 tracking-tight">Welcome Back</h1>
          <p class="text-slate-500 text-lg">请登录您的账户以继续使用</p>
        </div>

        <!-- 表单区域 -->
        <div class="space-y-6">
          
          <div class="space-y-2 group">
            <label class="text-sm font-bold text-slate-600 block pl-1">账号 / Username</label>
            <div class="relative pg-login-input">
              <el-input 
                v-model="username" 
                placeholder="请输入您的账号"
                @keyup.enter="doLogin"
                :disabled="isLoading || showWelcome"
              />
            </div>
          </div>

          <div class="space-y-2 group">
             <div class="flex justify-between items-center pl-1">
              <label class="text-sm font-bold text-slate-600">密码 / Password</label>
              <button 
                @click="handleForgotPassword" 
                class="text-sm font-bold text-[#6B9080] hover:text-[#557366] transition-colors focus:outline-none"
                tabindex="-1"
              >
                忘记密码？
              </button>
            </div>
            <div class="relative pg-login-input">
              <el-input 
                v-model="password" 
                type="password" 
                show-password
                placeholder="请输入您的密码"
                @keyup.enter="doLogin"
                :disabled="isLoading || showWelcome"
              />
            </div>
            <!-- 行内业务错误提示 -->
            <Transition name="slide-fade">
              <p v-if="errorMessage" class="text-red-500 text-sm mt-2 pl-1 font-medium flex items-center gap-1.5">
                <svg class="w-4 h-4 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/></svg>
                {{ errorMessage }}
              </p>
            </Transition>
          </div>

          <!-- 登录按钮 -->
          <button 
            class="w-full h-14 rounded-xl bg-gradient-to-r from-[#6B9080] to-[#557366] text-white font-bold text-lg shadow-lg shadow-[#6B9080]/30 hover:shadow-xl hover:shadow-[#6B9080]/40 hover:-translate-y-0.5 active:scale-[0.98] transition-all duration-300 flex items-center justify-center gap-3 mt-4 disabled:opacity-70 disabled:cursor-not-allowed"
            @click="doLogin"
            :disabled="isLoading || showWelcome"
          >
            <span v-if="isLoading" class="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
            <span>{{ isLoading ? '正在建立安全连接...' : '登 录' }}</span>
          </button>
        </div>

        <!-- 底部版权 -->
        <div class="pt-8 text-center md:text-left">
           <p class="text-xs text-slate-400 font-medium">
             © 2026 PsycheGuard Intelligence. All rights reserved.<br>
             <span class="opacity-60">Professional Psychological Assessment System</span>
           </p>
        </div>
      </div>
    </div>

    <!-- 右侧：视觉沉浸区 (55%) -->
    <div 
      class="hidden md:block md:w-[55%] xl:w-[60%] relative overflow-hidden bg-slate-900 transition-all duration-1000 ease-in-out"
      :class="{ 'opacity-80 scale-105 blur-sm': showWelcome }"
    >
      <!-- 背景图片 -->
      <img 
        src="https://images.unsplash.com/photo-1470770841072-f978cf4d019e?q=80&w=2070&auto=format&fit=crop" 
        class="absolute inset-0 w-full h-full object-cover opacity-90 transition-transform duration-[20s] hover:scale-110"
        alt="Healing Background"
      />
      <!-- 渐变蒙版 -->
      <div class="absolute inset-0 bg-gradient-to-br from-[#6B9080]/80 via-[#2C3E50]/40 to-[#557366]/90 mix-blend-multiply"></div>
      <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>

      <!-- 每日金句展示 -->
      <div class="absolute bottom-0 left-0 w-full p-16 z-10 transition-all duration-700" :class="{ 'translate-y-20 opacity-0': showWelcome }">
        <div class="glass-quote p-10 rounded-[2rem] max-w-2xl backdrop-blur-md border border-white/20 shadow-2xl">
          <svg class="w-10 h-10 text-white/60 mb-6" fill="currentColor" viewBox="0 0 24 24"><path d="M14.017 21L14.017 18C14.017 16.896 14.321 16.067 14.929 15.513C15.537 14.959 16.481 14.682 17.761 14.682V12.182H14.017V6.682H21.017V21H14.017ZM3.017 21L3.017 18C3.017 16.896 3.321 16.067 3.929 15.513C4.537 14.959 5.481 14.682 6.761 14.682V12.182H3.017V6.682H10.017V21H3.017Z"/></svg>
          <p class="text-2xl md:text-3xl font-medium text-white leading-relaxed tracking-wide mb-6 font-serif">
            "{{ quote.text }}"
          </p>
          <div class="flex items-center gap-4">
             <div class="h-[1px] w-12 bg-white/50"></div>
             <span class="text-white/80 font-medium tracking-widest uppercase text-sm">{{ quote.author }}</span>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const username = ref('')
const password = ref('')
const isLoading = ref(false)
const showWelcome = ref(false)
const welcomeName = ref('')
const errorMessage = ref('')  // 行内业务错误提示

// 每日金句数据
const quotes = [
  { text: "There is a crack in everything, that's how the light gets in.", author: "Leonard Cohen" },
  { text: "Your present circumstances don't determine where you can go; they merely determine where you start.", author: "Nido Qubein" },
  { text: "The only journey is the one within.", author: "Rainer Maria Rilke" },
  { text: "What you seek is seeking you.", author: "Rumi" }
]
const quote = ref(quotes[0])

onMounted(() => {
  // 随机选择一句金句
  quote.value = quotes[Math.floor(Math.random() * quotes.length)]
})

async function doLogin() {
  // ① 清空所有历史报错状态
  errorMessage.value = ''
  ElMessage.closeAll()

  if (!username.value || !password.value) {
    ElMessage.warning('请输入账号和密码')
    return
  }

  isLoading.value = true

  try {
    const res = await axios.post('/api/login', { username: username.value, password: password.value })
    const data = res.data

    if (data.token && data.user) {
      localStorage.setItem('pg_token', data.token)
      localStorage.setItem('pg_user', JSON.stringify(data.user))
      const userStore = useUserStore()
      userStore.login(data.user)

      // 兼容旧逻辑
      localStorage.setItem('user_role', data.user.role || '')
      localStorage.setItem('user_id', String(data.user.id || ''))

      // 触发转场动画
      isLoading.value = false
      welcomeName.value = data.user.realName || data.user.username
      showWelcome.value = true

      // 延迟跳转
      setTimeout(() => {
        if (data.user.role === 'ROLE_COUNSELOR') {
          router.replace('/dashboard')
        } else {
          router.replace('/client-dashboard')
        }
      }, 1500)
    } else {
      throw new Error('Invalid response')
    }

  } catch (e: any) {
    console.error(e)
    isLoading.value = false

    const status = e.response?.status
    const serverMsg = e.response?.data?.message || e.response?.data?.error

    // ② 分类处理：业务级错误 vs 网络/服务器异常（互斥）
    if (status && status >= 400 && status < 500 && serverMsg) {
      // 业务级错误（401 密码错误/用户不存在, 400 参数缺失等）→ 行内红字
      errorMessage.value = serverMsg
    } else {
      // 网络断开 / 服务器 500 / 未知异常 → 全局 ElMessage
      const fallback = !e.response
        ? '网络连接失败，请检查网络后重试'
        : '服务器异常，请稍后再试'
      ElMessage.error(serverMsg || fallback)
    }
  }
}

function handleForgotPassword() {
  ElMessageBox.alert(
    `<div class="text-center py-4">
      <div class="w-16 h-16 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-4 text-2xl">🔐</div>
      <h3 class="text-xl font-bold text-slate-800 mb-2">需要重置密码？</h3>
      <p class="text-slate-500 text-sm mb-6 px-4">为保障账户安全，请联系系统管理员或致电值班中心进行身份核验重置。</p>
      <div class="bg-slate-50 p-4 rounded-xl border border-slate-100 mx-4">
        <p class="text-base font-bold text-slate-700 flex items-center justify-center gap-2">
          <span>📞</span> <span>010-8888-9999</span>
        </p>
      </div>
    </div>`, 
    '', 
    { 
      dangerouslyUseHTMLString: true, 
      showConfirmButton: true,
      confirmButtonText: '好的，我知道了', 
      center: true,
      customClass: 'forgot-password-dialog !rounded-3xl !w-[400px]',
      confirmButtonClass: '!w-full !h-12 !rounded-xl !bg-slate-900 !border-slate-900 !font-bold !text-lg !mt-4'
    }
  )
}
</script>

<style scoped>
/* 覆盖 el-input 样式以匹配原生 Tailwind 设计 */
:deep(.pg-login-input .el-input__wrapper) {
  height: 3.5rem; /* h-14 = 56px */
  padding-left: 1rem;
  padding-right: 1rem;
  border-radius: 0.75rem; /* rounded-xl */
  background-color: #f9fafb; /* bg-gray-50 */
  box-shadow: 0 0 0 1px transparent inset;
  transition: all 0.3s;
}
:deep(.pg-login-input .el-input__inner) {
  font-weight: 500;
  color: #1e293b; /* text-slate-800 */
}
:deep(.pg-login-input .el-input__inner::placeholder) {
  color: #94a3b8; /* placeholder-slate-400 */
}
:deep(.pg-login-input .is-focus) {
  background-color: #ffffff;
  box-shadow: 0 0 0 1px #6B9080 inset, 0 0 0 4px rgba(107, 144, 128, 0.1) !important;
}

.fade-in-up {
  animation: fadeInUp 0.8s ease-out forwards;
  opacity: 0;
  transform: translateY(20px);
}

@keyframes fadeInUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 行内错误提示动画 */
.slide-fade-enter-active {
  transition: all 0.3s ease-out;
}
.slide-fade-leave-active {
  transition: all 0.2s ease-in;
}
.slide-fade-enter-from {
  opacity: 0;
  transform: translateY(-6px);
}
.slide-fade-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}

/* 浮动动画 */
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
  100% { transform: translateY(0); }
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

/* Vue Transition */
.fade-scale-enter-active,
.fade-scale-leave-active {
  transition: all 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}

.fade-scale-enter-from,
.fade-scale-leave-to {
  opacity: 0;
  transform: scale(0.9);
}

.glass-quote {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

/* 全局样式覆盖 */
:global(.forgot-password-dialog .el-message-box__header) {
  display: none;
}
:global(.forgot-password-dialog .el-message-box__content) {
  padding: 0 !important;
}
</style>