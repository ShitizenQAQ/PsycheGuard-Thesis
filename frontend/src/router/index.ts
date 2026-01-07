import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

const MainLayout = () => import('@/layout/MainLayout.vue')
const Assessment = () => import('@/views/Assessment.vue')
const Result = () => import('@/views/Result.vue')
const Dashboard = () => import('@/views/Dashboard.vue')
const History = () => import('@/views/History.vue')
const UserManagement = () => import('@/views/UserManagement.vue')
const Login = () => import('@/views/Login.vue')
const ScaleConfig = () => import('@/views/ScaleConfig.vue')
const Intervention = () => import('@/views/Intervention.vue')
const TeachingLibrary = () => import('@/views/TeachingLibrary.vue')

const ClientDashboard = () => import('@/views/client/ClientDashboard.vue')

const routes: RouteRecordRaw[] = [
  { path: '/login', name: 'Login', component: Login },
  { path: '/test', name: 'Assessment', component: Assessment },
  { path: '/result/:id', name: 'Result', component: Result },
  { path: '/client-dashboard', name: 'ClientDashboard', component: ClientDashboard },
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: 'dashboard', name: 'Dashboard', component: Dashboard },
      { path: 'history', name: 'History', component: History },
      { path: 'users', name: 'Users', component: UserManagement }
      , { path: 'scales', name: 'ScaleConfig', component: ScaleConfig }
      , { path: 'intervention', name: 'Intervention', component: Intervention }
      , { path: 'assess', name: 'AssessInLayout', component: Assessment }
      , { path: 'teaching', name: 'TeachingLibrary', component: TeachingLibrary }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
router.beforeEach((to, _from, next) => {
  const role = localStorage.getItem('user_role')
  const isAuthenticated = !!role

  // 1. 已登录用户访问登录页 -> 跳转到各自首页
  if (to.path === '/login') {
    if (isAuthenticated) {
      return next(role === 'ROLE_COUNSELOR' ? '/dashboard' : '/client-dashboard')
    }
    return next()
  }

  // 2. 未登录用户 -> 跳转登录
  if (!isAuthenticated) return next('/login')

  // 3. 根路径 -> 跳转各自首页
  if (to.path === '/') {
    return next(role === 'ROLE_COUNSELOR' ? '/dashboard' : '/client-dashboard')
  }

  // 4. Client 角色权限控制
  if (role === 'ROLE_CLIENT') {
    // 允许访问的路径前缀
    const clientAllowed = ['/client-dashboard', '/test', '/result', '/history', '/assess']
    const isAllowed = clientAllowed.some(prefix => to.path.startsWith(prefix))

    if (!isAllowed) {
      return next('/client-dashboard')
    }
  }

  next()
})
