import axios from 'axios'
import { ElMessage } from 'element-plus'

axios.defaults.timeout = 15000

axios.interceptors.response.use(
  (resp) => resp,
  (error) => {
    const status = error?.response?.status
    const url = error?.config?.url
    const baseMsg = error?.response?.data?.message || error?.message || '网络错误'
    const msg = status ? `[${status}] ${url}: ${baseMsg}` : baseMsg
    ElMessage.error(msg)
    return Promise.reject(error)
  }
)

export default axios
