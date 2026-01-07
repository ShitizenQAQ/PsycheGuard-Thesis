<template>
  <router-view />
</template>

<script setup lang="ts">
</script>

<style>
/* 全局基础样式 */
body {
  margin: 0;
  background-color: #F6F4F1; /* cream-100 */
  color: #4A4E69; /* rock-800 */
  font-family: 'Inter', 'Helvetica Neue', Helvetica, 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
}

:root {
  /* Element Plus 主题覆盖 - 晨曦治愈风 (Healing Green) */
  --el-color-primary: #6B9080;
  --el-color-primary-light-3: #97B1A6;
  --el-color-primary-light-5: #B5C7BF;
  --el-color-primary-light-7: #D2DDD8;
  --el-color-primary-light-9: #F0F3F2;
  --el-color-primary-dark-2: #557366;

  --el-color-success: #6B9080;
  --el-color-warning: #F2CC8F;
  --el-color-danger: #E07A5F;
  
  /* 解决按钮hover文字颜色问题 */
  --el-button-hover-text-color: #ffffff;
  --el-button-hover-bg-color: #557366;
}

/* 玻璃拟态卡片全局覆盖 */
.el-card, .el-dialog {
  background: rgba(255, 255, 255, 0.7) !important;
  backdrop-filter: blur(12px) !important;
  border-radius: 16px !important;
  border: 1px solid rgba(255, 255, 255, 0.6) !important;
  box-shadow: 0 4px 20px rgba(107, 144, 128, 0.1) !important;
}

/* 优化弹窗头部 */
.el-dialog__header {
  margin-right: 0 !important;
  border-bottom: 1px solid rgba(107, 144, 128, 0.1);
  padding: 20px 24px !important;
}

.el-dialog__title {
  color: #4A4E69 !important; /* rock-800 */
  font-weight: 600 !important;
}

/* 优化 Card 头部 */
.el-card__header {
  border-bottom: 1px solid rgba(107, 144, 128, 0.1) !important;
  padding: 16px 20px !important;
}
</style>
