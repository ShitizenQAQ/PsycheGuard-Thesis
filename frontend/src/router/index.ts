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

const routes: RouteRecordRaw[] = [
  { path: '/login', name: 'Login', component: Login },
  { path: '/test', name: 'Assessment', component: Assessment },
  { path: '/result/:id', name: 'Result', component: Result },
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: 'dashboard', name: 'Dashboard', component: Dashboard },
      { path: 'history', name: 'History', component: History },
      { path: 'users', name: 'Users', component: UserManagement }
      ,{ path: 'scales', name: 'ScaleConfig', component: ScaleConfig }
      ,{ path: 'intervention', name: 'Intervention', component: Intervention }
      ,{ path: 'assess', name: 'AssessInLayout', component: Assessment }
      ,{ path: 'teaching', name: 'TeachingLibrary', component: TeachingLibrary }
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

  if (to.path === '/login') {
    if (isAuthenticated) return next(role === 'DOCTOR' ? '/dashboard' : '/test')
    return next()
  }

  if (!isAuthenticated) return next('/login')

  if (to.path === '/') {
    return next(role === 'DOCTOR' ? '/dashboard' : '/test')
  }

  if (role === 'PRISONER') {
    if (!to.path.startsWith('/test') && !to.path.startsWith('/result')) {
      return next('/test')
    }
  }

  next()
})
