import axios from 'axios'
import { ElMessage } from 'element-plus'

axios.defaults.timeout = 15000

axios.interceptors.request.use((config) => {
  const token = localStorage.getItem('pg_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

axios.interceptors.response.use(
  (resp) => resp,
  (error) => {
    // ===== 断网 / 超时友好提示（全局拦截器） =====
    if (!error.response) {
      // 无 response 对象 = 网络层错误（断网 / DNS 失败 / CORS 等）
      if (error.code === 'ECONNABORTED' || error.message?.includes('timeout')) {
        ElMessage.error({
          message: '⏱ 请求超时，请检查您的网络连接后重试',
          duration: 5000,
          grouping: true
        })
      } else {
        ElMessage.error({
          message: '🔌 网络连接已中断，请检查您的网络设置后重试',
          duration: 5000,
          grouping: true
        })
      }
      return Promise.reject(error)
    }
    // ===== 断网提示结束 =====

    const status = error?.response?.status
    const url = error?.config?.url || ''

    // 登录接口的 4xx 错误由组件自行处理，不在此弹全局提示
    const isLoginBizError = url.includes('/api/login') && status && status >= 400 && status < 500

    if (!isLoginBizError) {
      const baseMsg = error?.response?.data?.message || error?.message || '网络错误'
      const msg = status ? `[${status}] ${url}: ${baseMsg}` : baseMsg
      ElMessage.error(msg)
    }

    return Promise.reject(error)
  }
)

export default axios
