<template>
  <el-drawer
    v-model="visible"
    title="通知中心"
    direction="rtl"
    size="400px"
    :before-close="handleClose"
  >
    <div class="notification-panel">
      <!-- 头部操作栏 -->
      <div class="panel-header">
        <div class="flex items-center justify-between mb-4">
          <span class="text-sm text-rock-600">
            {{ unreadCount }} 条未读通知
          </span>
          <button 
            v-if="unreadCount > 0"
            @click="handleMarkAllAsRead" 
            class="text-xs text-healing-600 hover:text-healing-700 font-medium"
          >
            全部已读
          </button>
        </div>
      </div>

      <!-- 通知列表 -->
      <div v-if="loading" class="text-center py-8 text-rock-400">
        <el-icon class="is-loading" :size="24"><Loading /></el-icon>
        <p class="mt-2 text-sm">加载中...</p>
      </div>

      <div v-else-if="notifications.length === 0" class="text-center py-12 text-rock-400">
        <el-icon :size="48"><BellFilled /></el-icon>
        <p class="mt-4 text-sm">暂无通知</p>
      </div>

      <div v-else class="notification-list space-y-3">
        <div
          v-for="notification in notifications"
          :key="notification.id"
          @click="handleNotificationClick(notification)"
          :class="[
            'notification-item p-4 rounded-xl cursor-pointer transition-all',
            notification.isRead ? 'bg-cream-50 opacity-60' : 'bg-white shadow-sm hover:shadow-md',
            getNotificationClass(notification.type)
          ]"
        >
          <!-- 通知图标和标题 -->
          <div class="flex items-start gap-3">
            <div :class="['notification-icon flex-shrink-0 w-8 h-8 rounded-lg flex items-center justify-center', getIconClass(notification.type)]">
              <el-icon :size="16">
                <WarningFilled v-if="notification.type === 'URGENT'" />
                <Warning v-else-if="notification.type === 'WARNING'" />
                <InfoFilled v-else />
              </el-icon>
            </div>
            
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between mb-1">
                <h4 class="text-sm font-bold text-rock-800 truncate">
                  {{ notification.title }}
                </h4>
                <span v-if="!notification.isRead" class="flex-shrink-0 w-2 h-2 bg-clay-500 rounded-full ml-2"></span>
              </div>
              
              <p class="text-xs text-rock-600 line-clamp-2 mb-2">
                {{ notification.content }}
              </p>
              
              <span class="text-[10px] text-rock-400">
                {{ formatTime(notification.createdAt) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </el-drawer>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useNotificationStore } from '@/stores/notification'
import { ElMessage } from 'element-plus'
import { Loading, BellFilled, WarningFilled, Warning, InfoFilled } from '@element-plus/icons-vue'

const props = defineProps<{
  modelValue: boolean
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
}>()

const router = useRouter()
const notificationStore = useNotificationStore()

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const notifications = computed(() => notificationStore.notifications)
const unreadCount = computed(() => notificationStore.unreadCount)
const loading = computed(() => notificationStore.loading)

// 监听弹窗打开,自动加载通知
watch(visible, (newVal) => {
  if (newVal) {
    notificationStore.fetchNotifications()
  }
})

function handleClose() {
  visible.value = false
}

function getNotificationClass(type: string) {
  if (type === 'URGENT') return 'border-l-4 border-clay-500'
  if (type === 'WARNING') return 'border-l-4 border-orange-500'
  return 'border-l-4 border-rock-300'
}

function getIconClass(type: string) {
  if (type === 'URGENT') return 'bg-clay-100 text-clay-600'
  if (type === 'WARNING') return 'bg-orange-100 text-orange-600'
  return 'bg-rock-100 text-rock-600'
}

function formatTime(dateStr: string) {
  const date = new Date(dateStr)
  const now = new Date()
  const diff = now.getTime() - date.getTime()
  
  const minutes = Math.floor(diff / 60000)
  const hours = Math.floor(diff / 3600000)
  const days = Math.floor(diff / 86400000)
  
  if (minutes < 1) return '刚刚'
  if (minutes < 60) return `${minutes}分钟前`
  if (hours < 24) return `${hours}小时前`
  if (days < 7) return `${days}天前`
  
  return date.toLocaleDateString('zh-CN')
}

async function handleNotificationClick(notification: any) {
  // 标记为已读
  if (!notification.isRead) {
    await notificationStore.markAsRead(notification.id)
  }
  
  // 跳转到相关页面
  if (notification.relatedUrl) {
    visible.value = false
    router.push(notification.relatedUrl)
  }
}

async function handleMarkAllAsRead() {
  await notificationStore.markAllAsRead()
  ElMessage.success('已全部标记为已读')
}
</script>

<style scoped>
.notification-panel {
  padding: 0 4px;
}

.notification-list {
  max-height: calc(100vh - 120px);
  overflow-y: auto;
}

.notification-item {
  border: 1px solid transparent;
}

.notification-item:hover {
  border-color: #E1EFE9;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 自定义滚动条 */
.notification-list::-webkit-scrollbar {
  width: 6px;
}

.notification-list::-webkit-scrollbar-track {
  background: #F6F4F1;
  border-radius: 3px;
}

.notification-list::-webkit-scrollbar-thumb {
  background: #A7A7B3;
  border-radius: 3px;
}

.notification-list::-webkit-scrollbar-thumb:hover {
  background: #7B7B8D;
}
</style>
