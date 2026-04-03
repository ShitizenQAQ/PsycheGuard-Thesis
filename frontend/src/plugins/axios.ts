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
