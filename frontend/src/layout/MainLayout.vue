<template>
  <el-container class="layout-container bg-cream-100">
    <el-aside width="260px" class="sidebar bg-white/60 backdrop-blur-xl border-r border-white/40 shadow-xl shadow-slate-200/40 z-20 flex flex-col">
      <div class="sidebar-header flex items-center justify-center gap-3 py-8">
        <div class="w-10 h-10 rounded-xl bg-gradient-to-tr from-healing-500 to-healing-600 shadow-lg shadow-healing-500/30 flex items-center justify-center text-white font-bold text-lg">PG</div>
        <h2 class="sidebar-title text-xl font-bold text-rock-800 tracking-tight">PsycheGuard</h2>
      </div>
      
      <el-menu
        :default-active="$route.path"
        class="sidebar-menu flex-1 px-4 !bg-transparent !border-r-0"
        router
        :collapse-transition="false"
      >
        <div v-if="isCounselor">
          <div class="text-xs font-bold text-rock-400 px-4 py-2 mt-2 mb-1 uppercase tracking-wider">Dashboard</div>
          <el-menu-item index="/dashboard">
            <el-icon><Odometer /></el-icon>
            <span>工作台大屏</span>
          </el-menu-item>
        </div>

        <div class="text-xs font-bold text-rock-400 px-4 py-2 mt-6 mb-1 uppercase tracking-wider">Services</div>

        <el-menu-item index="/assess">
          <el-icon><Edit /></el-icon>
          <span>心理测评</span>
        </el-menu-item>
        <el-menu-item index="/history">
          <el-icon><Document /></el-icon>
          <span>测评记录</span>
        </el-menu-item>

        <div v-if="isCounselor">
          <el-menu-item index="/users">
            <el-icon><User /></el-icon>
            <span>人员档案</span>
          </el-menu-item>
          <el-menu-item index="/intervention">
            <el-icon><ShieldAlert /></el-icon>
            <span>预警干预</span>
          </el-menu-item>

          <div class="text-xs font-bold text-rock-400 px-4 py-2 mt-6 mb-1 uppercase tracking-wider">System</div>

          <el-menu-item index="/scales">
            <el-icon><Setting /></el-icon>
            <span>量表配置</span>
          </el-menu-item>
          <el-menu-item index="/teaching">
            <el-icon><BookOpen /></el-icon>
            <span>经典案例库</span>
          </el-menu-item>
        </div>
      </el-menu>

      <div class="p-6 text-center text-xs text-slate-400">
        v2.5.0 · Secure
      </div>
    </el-aside>

    <el-container class="relative">
      <el-header class="header h-20 px-8 flex items-center justify-between sticky top-0 z-10 bg-white/40 backdrop-blur-md border-b border-white/40">
        <div class="header-left">
          <h2 class="text-xl font-bold text-rock-800">{{ currentRouteName }}</h2>
          <p class="text-xs text-rock-600 mt-0.5">欢迎使用智能心理评估系统</p>
        </div>
        
        <div class="header-right flex items-center gap-6">
          <button class="relative p-2 text-rock-400 hover:text-rock-600 transition-colors" @click="openNotifications" aria-label="打开通知">
            <span class="absolute top-2 right-2 w-2 h-2 bg-clay-500 rounded-full border border-white"></span>
            <el-icon :size="20"><Bell /></el-icon>
          </button>

          <el-dropdown @command="onUserCommand" trigger="click">
            <div class="flex items-center gap-3 cursor-pointer py-1 px-2 rounded-xl hover:bg-white/50 transition-colors">
              <el-avatar :size="40" :src="userAvatar" class="border-2 border-white shadow-sm" />
              <div class="flex flex-col text-left">
                <span class="text-sm font-bold text-rock-800">{{ displayName }}</span>
                <span class="text-[10px] text-rock-600 font-medium bg-cream-50 px-1.5 rounded w-fit">
                  {{ isCounselor ? '咨询师/管理员' : '来访者' }}
                </span>
              </div>
              <el-icon class="text-rock-400 ml-1"><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu class="!rounded-xl !p-2">
                <el-dropdown-item command="profile" v-if="isCounselor">👤 个人中心</el-dropdown-item>
                <el-dropdown-item command="test">📝 发起测评</el-dropdown-item>
                <el-dropdown-item divided command="logout"><span class="text-clay-500">🚪 退出登录</span></el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <el-main class="main-content p-0 relative">
        <router-view v-slot="{ Component }">
          <transition name="fade-slide" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup lang="ts">
import { Odometer, Edit, Document, User, Setting, Bell, ArrowDown } from '@element-plus/icons-vue'
import { ShieldAlert, BookOpen } from 'lucide-vue-next'
import { computed, onMounted, onUnmounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'

const store = useUserStore()
store.load()
const displayName = computed(() => store.user?.realName || 'Admin')
const userAvatar = computed(() => store.user?.avatar || `https://api.dicebear.com/7.x/avataaars/svg?seed=${store.user?.username || 'admin'}`)
const isCounselor = computed(() => store.isCounselor)
const router = useRouter()
const route = useRoute()

// 动态获取当前页面标题
const currentRouteName = computed(() => {
  const map: Record<string, string> = {
    '/dashboard': '工作台大屏',
    '/assess': '心理测评中心',
    '/history': '历史测评记录',
    '/scales': '量表配置管理',
    '/users': '人员档案管理',
    '/intervention': '预警干预台账',
    '/teaching': '经典案例教学库'
  }
  return map[route.path] || '心理评估管理系统'
})

function onUserCommand(cmd: string) {
  if (cmd === 'profile') router.push('/users')
  else if (cmd === 'test') router.push('/assess') // 注意这里的路由可能是 /assess 或 /test
  else if (cmd === 'history') router.push('/history')
  else if (cmd === 'logout') {
    store.logout()
    localStorage.clear()
    router.replace('/login')
  }
}

let idleTimer: number | null = null
const TIMEOUT = 15 * 60 * 1000
const resetTimer = () => {
  if (idleTimer) clearTimeout(idleTimer)
  idleTimer = window.setTimeout(logout, TIMEOUT)
}
const logout = () => {
  if (localStorage.getItem('pg_token')) {
    localStorage.clear()
    router.replace('/login')
    ElMessage.warning('因长时间未操作，为确保安全已自动退出')
  }
}
onMounted(() => {
  window.addEventListener('mousemove', resetTimer)
  window.addEventListener('click', resetTimer)
  window.addEventListener('keydown', resetTimer)
  resetTimer()
})
onUnmounted(() => {
  if (idleTimer) clearTimeout(idleTimer)
  window.removeEventListener('mousemove', resetTimer)
  window.removeEventListener('click', resetTimer)
  window.removeEventListener('keydown', resetTimer)
})

function openNotifications() {
  router.push({ path: '/dashboard', query: { notify: '1' } })
}
</script>

<style scoped>
/* 侧边栏菜单样式覆盖 */
:deep(.el-menu-item) {
  height: 50px;
  line-height: 50px;
  margin: 4px 0;
  border-radius: 12px;
  color: #7B7B8D; /* rock-600 */
  font-weight: 500;
  border: 1px solid transparent;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-menu-item:hover) {
  background-color: rgba(255, 255, 255, 0.6) !important;
  color: #4A4E69; /* rock-800 */
  transform: translateX(4px);
}

:deep(.el-menu-item.is-active) {
  background: linear-gradient(90deg, #F0F7F4 0%, #FFFFFF 100%) !important; /* healing-50 base */
  color: #6B9080 !important; /* healing-500 */
  font-weight: 700;
  border: 1px solid #E1EFE9; /* healing-100 */
  box-shadow: 0 4px 12px rgba(107, 144, 128, 0.05);
}

:deep(.el-menu-item .el-icon) {
  font-size: 18px;
  margin-right: 12px;
  transition: transform 0.3s;
}

:deep(.el-menu-item.is-active .el-icon) {
  transform: scale(1.1);
  color: #6B9080;
}

/* 页面切换动画 */
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease;
}

.fade-slide-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.fade-slide-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* === 莫兰迪治愈色系定义 === */
.bg-cream-100 { background-color: #F6F4F1 !important; }
.bg-cream-50 { background-color: #FBF9F7 !important; }
.text-rock-800 { color: #4A4E69 !important; }
.text-rock-600 { color: #7B7B8D !important; }
.text-rock-400 { color: #A7A7B3 !important; }

.bg-healing-500 { background-color: #6B9080 !important; }
.from-healing-500 { --tw-gradient-from: #6B9080 !important; --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to) !important; }
.to-healing-600 { --tw-gradient-to: #557366 !important; }
.text-healing-600 { color: #557366 !important; }

.bg-clay-500 { background-color: #E07A5F !important; }
.text-clay-500 { color: #E07A5F !important; }
</style>
