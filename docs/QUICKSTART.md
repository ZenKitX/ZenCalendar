# ZenCalendar 快速启动指南

## 安装依赖

```bash
flutter pub get
```

## 运行应用

### 开发模式
```bash
flutter run
```

### 指定设备
```bash
# 查看可用设备
flutter devices

# 在特定设备上运行
flutter run -d <device_id>
```

## 构建应用

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Windows
```bash
flutter build windows --release
```

### macOS
```bash
flutter build macos --release
```

### Linux
```bash
flutter build linux --release
```

### Web
```bash
flutter build web --release
```

## 测试

```bash
# 运行所有测试
flutter test

# 运行分析
flutter analyze
```

## 项目结构

```
lib/
├── main.dart                      # 应用入口
├── models/                        # 数据模型
├── screens/                       # 屏幕页面
├── services/                      # 业务逻辑服务
├── theme/                         # 主题配置
└── widgets/                       # 可复用组件
```

## 主要功能

1. **日历视图** - 查看和选择日期
2. **每日意图** - 为每一天设定专注目标
3. **禅语展示** - 每日智慧分享
4. **主题切换** - 深色/浅色模式

## 技术栈

- Flutter 3.41.2
- Dart 3.11.0
- Material Design 3
- Google Fonts (Lora + Raleway)

## 设计理念

基于 Soft UI Evolution 设计风格，采用薰衣草紫和健康绿的配色方案，营造平静、放松的使用体验。

## 下一步

查看 [DESIGN.md](./DESIGN.md) 了解详细的设计系统和技术细节。
