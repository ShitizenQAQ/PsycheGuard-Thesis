<template>
  <div class="min-h-screen w-full flex flex-col md:flex-row bg-cream-100 overflow-hidden font-sans">
    
    <!-- 左侧：氛围区 (Morning Healing Atmosphere) -->
    <div class="md:w-1/2 relative overflow-hidden bg-gradient-to-br from-healing-50 to-healing-200 flex flex-col items-center justify-center p-12 order-2 md:order-1">
      
      <!-- 动态背景光斑 -->
      <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-healing-200 rounded-full mix-blend-multiply filter blur-[80px] opacity-60 animate-blob"></div>
      <div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-cream-100 rounded-full mix-blend-multiply filter blur-[80px] opacity-60 animate-blob animation-delay-2000"></div>
      <div class="absolute top-1/2 left-3/4 w-64 h-64 bg-healing-100 rounded-full mix-blend-multiply filter blur-[60px] opacity-50 animate-blob animation-delay-4000"></div>

      <!-- 玻璃拟态 Logo 展示区 -->
      <div class="relative z-10 flex flex-col items-center">
        <div class="glass-effect p-16 rounded-[3rem] shadow-[0_8px_32px_rgba(107,144,128,0.1)] transform hover:scale-105 transition-transform duration-700">
          <!-- Logo 占位 -->
          <div class="w-32 h-32 rounded-[2rem] bg-gradient-to-tr from-healing-500 to-healing-600 flex items-center justify-center shadow-lg shadow-healing-500/30 mb-0 mx-auto">
            <span class="text-white text-4xl font-bold tracking-widest">PG</span>
          </div>
        </div>
        
        <div class="mt-12 text-center space-y-4 max-w-lg">
          <h1 class="text-4xl md:text-5xl font-bold text-rock-800 tracking-tight">PsycheGuard</h1>
          <p class="text-lg text-rock-600 font-medium">智能心理测评与干预系统</p>
          <div class="h-1 w-20 bg-healing-500/30 rounded-full mx-auto mt-6"></div>
          <p class="text-rock-400 text-sm mt-8 opacity-80">
            "在每天的晨曦中，寻回内心的平静与力量"
          </p>
        </div>
      </div>
    </div>

    <!-- 右侧：操作区 (Operation Area) -->
    <div class="md:w-1/2 bg-cream-100 flex items-center justify-center p-8 md:p-16 relative order-1 md:order-2">
      <!-- 装饰纹理 -->
      <div class="absolute top-0 right-0 p-8 opacity-20">
        <svg width="100" height="100" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <circle cx="50" cy="50" r="40" stroke="#6B9080" stroke-width="2"/>
          <path d="M50 10 V90 M10 50 H90" stroke="#6B9080" stroke-width="2" stroke-linecap="round"/>
        </svg>
      </div>

      <div class="w-full max-w-md space-y-10 z-10">
        <!-- 欢迎文案 -->
        <div class="text-center md:text-left space-y-2">
          <h2 class="text-3xl font-bold text-rock-800">开启您的心理健康之旅</h2>
          <p class="text-rock-400">Welcome Back</p>
        </div>

        <!-- 登录表单 -->
        <div class="space-y-6">
          
          <div class="space-y-2 group">
            <label class="text-sm font-bold text-rock-600 ml-1">账号 / Username</label>
            <div class="relative transition-all duration-300 transform group-focus-within:-translate-y-1">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <el-icon class="text-rock-400 group-focus-within:text-healing-600 transition-colors"><User /></el-icon>
              </div>
              <input 
                v-model="username" 
                type="text" 
                placeholder="请输入您的账号" 
                class="w-full pl-11 pr-4 py-4 rounded-xl bg-white border border-cream-200 text-rock-800 placeholder-rock-400 focus:outline-none focus:ring-4 focus:ring-healing-500/10 focus:border-healing-500 transition-all shadow-sm group-hover:shadow-md"
                @keyup.enter="doLogin"
                :disabled="isLoading"
              />
            </div>
          </div>

          <div class="space-y-2 group">
             <div class="flex justify-between items-center ml-1">
              <label class="text-sm font-bold text-rock-600">密码 / Password</label>
            </div>
            <div class="relative transition-all duration-300 transform group-focus-within:-translate-y-1">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <el-icon class="text-rock-400 group-focus-within:text-healing-600 transition-colors"><Lock /></el-icon>
              </div>
              <input 
                v-model="password" 
                type="password" 
                placeholder="请输入您的密码" 
                class="w-full pl-11 pr-4 py-4 rounded-xl bg-white border border-cream-200 text-rock-800 placeholder-rock-400 focus:outline-none focus:ring-4 focus:ring-healing-500/10 focus:border-healing-500 transition-all shadow-sm group-hover:shadow-md"
                @keyup.enter="doLogin"
                :disabled="isLoading"
              />
            </div>
          </div>

          <!-- 登录按钮 -->
          <button 
            class="w-full py-4 rounded-xl bg-healing-500 text-white font-bold text-lg shadow-[0_10px_20px_-5px_rgba(107,144,128,0.4)] hover:bg-healing-600 hover:shadow-[0_15px_25px_-5px_rgba(107,144,128,0.5)] hover:-translate-y-0.5 active:scale-[0.98] transition-all duration-300 flex items-center justify-center gap-3 mt-8"
            @click="doLogin"
            :disabled="isLoading"
            :class="{ 'opacity-80 cursor-wait': isLoading }"
          >
            <span v-if="isLoading" class="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
            <span>{{ isLoading ? '正在连接...' : '进入空间' }}</span>
          </button>

          <!-- 帮助提示 (无注册) -->
          <p class="text-center text-xs text-rock-400 mt-8 opacity-80 font-medium">
            如需重置密码或开通账号，请联系管理员
          </p>
        </div>
      </div>

      <!-- 版本号 -->
      <div class="absolute bottom-6 left-0 w-full text-center">
        <p class="text-xs text-rock-400 font-mono opacity-50">Secure System v2.5.0 · Morning Healing UI</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock } from '@element-plus/icons-vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const router = useRouter()
const username = ref('')
const password = ref('')
const isLoading = ref(false)

async function doLogin() {
  if (!username.value || !password.value) {
    ElMessage.warning('请输入账号和密码')
    return
  }
  
  isLoading.value = true
  
  try {
    const res = await axios.post('/api/login', { username: username.value, password: password.value })
    
    // 处理登录成功
    const data = res.data
    const token = data.token
    const user = data.user
    
    if (token && user) {
      localStorage.setItem('pg_token', token)
      localStorage.setItem('pg_user', JSON.stringify(user))
      localStorage.setItem('user_role', user.role || '')
      localStorage.setItem('user_id', String(user.id || ''))

      ElMessage.success({
        message: `欢迎回来，${user.realName || user.username}`,
        duration: 2000,
        customClass: 'healing-message'
      })

      // 稍微延迟跳转以显示加载完成状态
      setTimeout(() => {
        if (user.role === 'ROLE_COUNSELOR') {
          router.replace('/dashboard')
        } else {
          // 默认跳转到测评中心或首页
          router.replace('/assess') 
        }
      }, 500)
    } else {
      throw new Error('Invalid response structure')
    }

  } catch (e: any) {
    console.error(e)
    ElMessage.error(e.response?.data?.message || '登录失败，请检查账号密码')
    isLoading.value = false
  }
}
</script>

<style scoped>
/* 呼吸动画 */
@keyframes blob {
  0% { transform: translate(0px, 0px) scale(1); }
  33% { transform: translate(30px, -50px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(0px, 0px) scale(1); }
}
.animate-blob { animation: blob 10s infinite; }
.animation-delay-2000 { animation-delay: 2s; }
.animation-delay-4000 { animation-delay: 4s; }

/* === 登录页专用治愈色系补丁 (CSS Patch) === */
.bg-cream-100 { background-color: #F6F4F1 !important; }
.text-rock-800 { color: #4A4E69 !important; }
.text-rock-600 { color: #7B7B8D !important; }
.text-rock-400 { color: #A7A7B3 !important; }

.bg-healing-50 { background-color: #F0F7F4 !important; }
.bg-healing-100 { background-color: #E1EFE9 !important; }
.bg-healing-200 { background-color: #C2DFCE !important; } /* 自定义更深的背景色 */
.bg-healing-500 { background-color: #6B9080 !important; }
.bg-healing-600 { background-color: #557366 !important; }
.text-healing-600 { color: #557366 !important; }
.text-healing-500 { color: #6B9080 !important; }
.border-healing-500 { border-color: #6B9080 !important; }

.text-clay-500 { color: #E07A5F !important; }
.text-clay-600 { color: #B3614C !important; }

.border-cream-200 { border-color: #EBE6E0 !important; }

/* 玻璃拟态特效 */
.glass-effect {
    background: rgba(255, 255, 255, 0.25);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.4);
}
</style>