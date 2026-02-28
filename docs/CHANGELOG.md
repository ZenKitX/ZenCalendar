# 更新日志

## v1.0.0 - 2026-02-26

### 初始版本

从 ZenCalc 计算器应用改造为 ZenCalendar 禅意日历应用。

#### 新增功能
- ✨ 日历视图 - 使用 table_calendar 实现月历展示
- ✨ 每日意图 - 可为每天设定专注目标并保存
- ✨ 禅语展示 - 15 条精选禅语随机展示
- ✨ 深色/浅色模式切换
- ✨ Soft UI Evolution 设计风格
- ✨ Google Fonts 字体支持 (Lora + Raleway)

#### 设计系统
- 🎨 配色方案：薰衣草紫 (#8B5CF6) + 健康绿 (#10B981)
- 🎨 浅色背景：#FAF5FF
- 🎨 深色背景：#1F1B24
- 🎨 柔和阴影和现代过渡动画

#### 技术改进
- 📦 添加 table_calendar 包
- 📦 添加 google_fonts 包
- 📦 添加 intl 包用于日期格式化
- 🗄️ 使用 SharedPreferences 持久化每日意图
- 🧹 移除计算器相关代码和组件
- 🧹 清理不需要的依赖

#### 文档
- 📝 创建 DESIGN.md 设计文档
- 📝 创建 QUICKSTART.md 快速启动指南
- 📝 更新 README.md

#### 代码质量
- ✅ 通过 Flutter analyze 检查
- ✅ 更新测试文件
- ✅ 使用最新的 Flutter API (withValues 替代 withOpacity)
