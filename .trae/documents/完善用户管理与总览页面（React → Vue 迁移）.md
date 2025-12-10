## 目标
- 将 React 参考的 UserManagement 与 DoctorDashboard 视觉与交互完整迁移至 Vue 3 + Tailwind 环境，做到“样式一致、交互一致、布局一致”。
- 保留现有接口与页面结构，采用本地模拟数据实现搜索与筛选，后续可平滑替换为后端数据。

## 页面与路由
- 新增页面：`src/views/UserManagement.vue`，路由映射 `/users`
- 升级页面：`src/views/Dashboard.vue`，对齐 React 中 Overview 设计
- 统一布局：沿用 `MainLayout` 的侧边栏与头部，全站视觉一致

## UserManagement 页面实现
- 顶部工具栏（Top Bar）
  - 左侧：搜索输入（姓名、编号、用户名）
  - 中间：风险等级筛选（ALL/LOW/MEDIUM/HIGH）
  - 右侧：新建用户按钮（黑底白字）
- 卡片网格（Responsive Grid）
  - 玻璃拟态卡片：圆角、柔和阴影、半透明白背景、模糊
  - 居中头像，头像右下角风险短标签（高/中/低）色彩与徽标
  - 风险徽章（长标签）：高（红）、中（黄）、低（绿）
  - 底部双按钮：查看档案、发起测评
- 数据与逻辑
  - 使用 `MOCK_USERS_BASE` 与 `generateMoreUsers` 生成模拟数据
  - 计算属性实现搜索与筛选组合逻辑
  - 新建用户按钮向数据头部插入新项
- 交互跳转
  - 查看档案 → `/history`
  - 发起测评 → `/test`

## Dashboard 页面实现
- 头部欢迎：左侧“欢迎回来 Dr. Admin”，右侧通知铃铛
- 四张统计卡片（颜色与图标）
  - 蓝（从 cyan-500 到 blue-600）：在押总人数
  - 红（rose/red）：高风险预警
  - 绿（emerald/green）：累计测评
  - 橙（amber/orange）：平均分
- 近期记录列表（Recent Assessments）
  - 头像、姓名、日期、总分、风险标签（红/绿）
  - 模拟数据与样式对齐

## 样式与组件细节
- Tailwind 工具类：使用渐变、阴影、圆角、透明度类构建视觉
- 玻璃拟态：在全局 CSS 中定义 `.glass-card`，避免在 `@apply` 中使用透明度类
- 卡片交互：hover 高亮、选中态阴影与边框颜色变化
- 小标签：使用圆角、浅色背景、主题色文字，与 React 保持一致

## 验证与预览
- 启动前端 Dev，预览 `/users` 与 `/dashboard`
- 检查响应式布局与色彩对齐程度
- 检查 Top Bar 搜索与筛选逻辑是否正确

## 后续可选项
- 替换模拟数据为后端接口
- 提取风险标签为复用组件
- 引入分页与加载骨架

## 需要确认
- 是否需要完全复刻 React 中的图标库（如 lucide），还是使用 Element Plus 图标即可
- 风险颜色、文案与徽记形态是否需要像素级对齐截图
- 搜索字段范围是否包含 `tags` 等扩展属性

请确认以上迁移与实现方案，我将按此方案完成页面与路由的具体实现。