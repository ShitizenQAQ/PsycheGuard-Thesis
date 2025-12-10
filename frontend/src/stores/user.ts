import { defineStore } from 'pinia'

export type Role = 'DOCTOR' | 'PRISONER'

export type User = {
  id: number
  username: string
  realName: string
  role: Role
  avatar?: string
}

const KEY = 'pg_user'

export const useUserStore = defineStore('user', {
  state: () => ({ user: null as User | null }),
  getters: {
    loggedIn: (s) => !!s.user,
  },
  actions: {
    load() {
      try { const raw = localStorage.getItem(KEY); if (raw) this.user = JSON.parse(raw) } catch {}
    },
    login(u: User) {
      this.user = u
      localStorage.setItem(KEY, JSON.stringify(u))
    },
    logout() {
      this.user = null
      localStorage.removeItem(KEY)
    }
  }
})

