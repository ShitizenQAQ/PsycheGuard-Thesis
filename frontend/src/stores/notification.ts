import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import axios from 'axios'

export interface Notification {
    id: number
    userId: number
    title: string
    content: string
    type: 'URGENT' | 'WARNING' | 'INFO'
    relatedUrl: string
    isRead: boolean
    createdAt: string
}

export const useNotificationStore = defineStore('notification', () => {
    const notifications = ref<Notification[]>([])
    const unreadCount = ref(0)
    const loading = ref(false)

    // 计算是否有紧急通知
    const hasUrgent = computed(() => {
        return notifications.value.some(n => !n.isRead && n.type === 'URGENT')
    })

    // 计算是否有预警通知
    const hasWarning = computed(() => {
        return notifications.value.some(n => !n.isRead && n.type === 'WARNING')
    })

    // 计算徽章颜色
    const badgeColor = computed(() => {
        if (hasUrgent.value) return 'urgent' // 红色
        if (hasWarning.value) return 'warning' // 橙色
        return 'info' // 灰色
    })

    // 获取通知列表
    async function fetchNotifications() {
        loading.value = true
        try {
            const token = localStorage.getItem('pg_token')
            const response = await axios.get('/api/notifications', {
                headers: { Authorization: `Bearer ${token}` }
            })
            notifications.value = response.data
            await fetchUnreadCount()
        } catch (error) {
            console.error('Failed to fetch notifications:', error)
        } finally {
            loading.value = false
        }
    }

    // 获取未读数量
    async function fetchUnreadCount() {
        try {
            const token = localStorage.getItem('pg_token')
            const response = await axios.get('/api/notifications/unread-count', {
                headers: { Authorization: `Bearer ${token}` }
            })
            unreadCount.value = response.data.count
        } catch (error) {
            console.error('Failed to fetch unread count:', error)
        }
    }

    // 标记单条通知为已读
    async function markAsRead(id: number) {
        try {
            const token = localStorage.getItem('pg_token')
            await axios.put(`/api/notifications/${id}/read`, {}, {
                headers: { Authorization: `Bearer ${token}` }
            })

            // 更新本地状态
            const notification = notifications.value.find(n => n.id === id)
            if (notification) {
                notification.isRead = true
            }
            await fetchUnreadCount()
        } catch (error) {
            console.error('Failed to mark notification as read:', error)
        }
    }

    // 一键已读所有通知
    async function markAllAsRead() {
        try {
            const token = localStorage.getItem('pg_token')
            await axios.put('/api/notifications/read-all', {}, {
                headers: { Authorization: `Bearer ${token}` }
            })

            // 更新本地状态
            notifications.value.forEach(n => n.isRead = true)
            unreadCount.value = 0
        } catch (error) {
            console.error('Failed to mark all as read:', error)
        }
    }

    return {
        notifications,
        unreadCount,
        loading,
        hasUrgent,
        hasWarning,
        badgeColor,
        fetchNotifications,
        fetchUnreadCount,
        markAsRead,
        markAllAsRead
    }
})
