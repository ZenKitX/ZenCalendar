# ZenCalendar 📅✨

一个简洁优雅的日历和意图管理应用，融合禅意设计理念和现代 Material 3 设计语言。

![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)
![GetX](https://img.shields.io/badge/GetX-4.6.6-9C27B0)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ 特性

### 📆 日历管理
- 月视图日历展示
- 事件创建、编辑、删除
- 事件详情查看
- 全天事件支持
- 快速日期导航

### 🎯 意图管理
- 每日意图设定
- 意图完成追踪
- 历史记录查看
- 完成统计和进度可视化

### 🧘 禅意体验
- 每日禅语启发
- 多种禅语分类
- 柔和的 Soft UI 设计
- 触觉反馈增强

### ⚙️ 个性化设置
- 主题切换（浅色/深色/跟随系统）
- 通知设置管理
- 数据统计和管理

## 🎨 设计

### 设计理念
**Soft UI Evolution（柔和 UI 进化）**

继承自 Calculator 项目的 Neumorphic/Soft UI 设计，结合禅意美学：
- 柔和的阴影效果
- 流畅的动画过渡
- 触觉反馈系统
- 禅语启发系统

### 配色方案

#### 浅色主题
- 主色：薰衣草紫 (#9C88D4)
- 次要色：柔和粉 (#E8B4D4)
- 强调色：健康绿 (#7CB342)

#### 深色主题
- 主色：竹林绿 (#4A7C59)
- 次要色：月光蓝 (#5C7C8C)
- 强调色：禅意金 (#D4AF37)

### 字体
- 标题：Lora (衬线字体)
- 正文：Raleway (无衬线字体)

## 🏗️ 技术架构

### 架构模式
**GetX MVC + Clean Architecture 精简版**

```
lib/
├── main.dart                    # 应用入口
└── app/
    ├── config/                  # 配置
    │   └── theme/              # 主题配置
    ├── core/                    # 核心
    │   └── init_dependencies.dart
    ├── data/                    # 数据层
    │   ├── models/             # 数据模型
    │   ├── providers/          # 数据提供者
    │   └── repositories/       # 仓库
    ├── modules/                 # 功能模块
    │   ├── home/               # 主页
    │   ├── calendar/           # 日历
    │   ├── intention/          # 意图
    │   └── settings/           # 设置
    ├── routes/                  # 路由
    └── services/                # 服务
```

### 技术栈
- **Flutter**: 3.11+
- **GetX**: 4.6.6 (状态管理 + 路由 + 依赖注入)
- **SharedPreferences**: 本地存储
- **Table Calendar**: 日历组件
- **Google Fonts**: 字体
- **Material 3**: 设计语言

## 🚀 快速开始

### 环境要求
- Flutter SDK: 3.11.0 或更高
- Dart SDK: 3.11.0 或更高

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/yourusername/zen_calendar.git
cd zen_calendar
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📱 截图

### 日历视图
- 月视图日历
- 事件列表
- 事件详情

### 意图管理
- 今日意图卡片
- 每日禅语
- 完成统计
- 历史记录

### 设置页面
- 主题切换
- 通知设置
- 数据管理
- 关于信息

## 📚 文档

### 架构文档
- [最终推荐方案](docs/FINAL_RECOMMENDATION.md)
- [架构提案](docs/ARCHITECTURE_PROPOSAL.md)
- [架构图](docs/ARCHITECTURE_DIAGRAM.md)
- [项目对比](docs/COMPARISON_SUMMARY.md)

### 开发文档
- [迁移指南](docs/MIGRATION_GUIDE.md)
- [快速参考](docs/QUICK_REFERENCE.md)
- [文档索引](docs/INDEX.md)

### 阶段报告
- [Phase 1: 基础架构](docs/PHASE1_COMPLETE.md)
- [Phase 2: 数据层](docs/PHASE2_COMPLETE.md)
- [Phase 3: Calendar 模块](docs/PHASE3_COMPLETE.md)
- [Phase 4: Intention 模块](docs/PHASE4_COMPLETE.md)
- [Phase 5: Settings 模块](docs/PHASE5_COMPLETE.md)

### 项目总结
- [项目总结](docs/PROJECT_SUMMARY.md)

## 🗺️ 路线图

### v1.0 (当前版本) ✅
- [x] 日历事件管理
- [x] 每日意图设定
- [x] 禅语系统
- [x] 主题切换
- [x] 触觉反馈
- [x] 底部导航

### v1.1 (计划中)
- [ ] 数据导出/导入
- [ ] 事件搜索
- [ ] 事件分类/标签
- [ ] 周视图/日视图

### v1.2 (未来)
- [ ] 事件重复规则
- [ ] 通知提醒
- [ ] 冥想计时器
- [ ] 呼吸练习

### v2.0 (远期)
- [ ] 云端同步
- [ ] 多设备支持
- [ ] 社区分享
- [ ] AI 智能建议

## 🤝 贡献

欢迎贡献！请查看 [贡献指南](CONTRIBUTING.md) 了解详情。

### 贡献方式
1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [Flutter](https://flutter.dev/) - 优秀的跨平台框架
- [GetX](https://pub.dev/packages/get) - 强大的状态管理解决方案
- [Table Calendar](https://pub.dev/packages/table_calendar) - 优秀的日历组件
- [Google Fonts](https://fonts.google.com/) - 美丽的字体
- [Material Design](https://m3.material.io/) - 现代设计语言

## 📧 联系方式

- 项目主页: [GitHub](https://github.com/yourusername/zen_calendar)
- 问题反馈: [Issues](https://github.com/yourusername/zen_calendar/issues)

---

**ZenCalendar** - 让时间管理更加禅意 🧘‍♂️📅✨

Made with ❤️ using Flutter
