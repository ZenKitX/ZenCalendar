# ZenCalendar 设计文档

## 设计系统

基于 UI/UX Pro Max 推荐的设计系统。

### 风格
- **Pattern**: Hero-Centric + Social Proof
- **Style**: Soft UI Evolution
- **特点**: 现代美学、柔和深度、无障碍友好、改进阴影

### 配色方案

#### 浅色模式
- Primary: `#8B5CF6` (薰衣草紫)
- Secondary: `#C4B5FD` (浅紫)
- CTA: `#10B981` (健康绿)
- Background: `#FAF5FF` (浅紫背景)
- Text: `#4C1D95` (深紫文字)

#### 深色模式
- Background: `#1F1B24`
- Surface: `#2D2833`
- Text: `#F3E8FF`

### 字体
- **标题**: Lora (serif) - 优雅、平静
- **正文**: Raleway (sans-serif) - 现代、易读

### 关键效果
- 改进的阴影（比扁平柔和，比拟态清晰）
- 现代过渡动画 (200-300ms)
- 焦点可见性
- WCAG AA/AAA 无障碍标准

### 避免的反模式
- 明亮霓虹色
- 刺眼动画
- 深色模式下的对比度问题

## 功能特性

### 核心功能
1. 日历视图 - 使用 table_calendar 包
2. 每日意图 - 可保存的文本输入
3. 禅语展示 - 每日智慧分享
4. 深色/浅色模式切换

### 数据持久化
- 使用 SharedPreferences 存储每日意图
- 按日期键值存储

### 用户体验
- 流畅的主题切换动画 (300ms)
- Soft UI 卡片设计
- 响应式布局
- 触觉反馈支持

## 技术栈

- Flutter 3.41.2
- Dart 3.11.0
- table_calendar: ^3.1.2
- google_fonts: ^6.1.0
- shared_preferences: ^2.2.0
- intl: ^0.19.0

## 文件结构

```
lib/
├── main.dart                      # 应用入口
├── models/
│   └── daily_intention.dart       # 每日意图数据模型
├── screens/
│   └── calendar_screen.dart       # 日历主屏幕
├── services/
│   ├── zen_quote_service.dart     # 禅语服务
│   ├── intention_service.dart     # 意图存储服务
│   ├── audio_service.dart         # 音频服务（保留）
│   └── haptic_service.dart        # 触觉反馈服务（保留）
├── theme/
│   └── app_theme.dart             # 主题配置
└── widgets/
    ├── soft_card.dart             # Soft UI 卡片组件
    └── zen_quote_widget.dart      # 禅语展示组件
```

## 未来改进

1. 添加事件管理功能
2. 集成冥想计时器
3. 添加呼吸练习引导
4. 统计和回顾功能
5. 云同步支持
6. 自定义主题颜色
7. 更多禅语和智慧分享
8. 提醒和通知功能
