# ZenCalendar 架构设计方案

## 📋 项目分析总结

### 参考项目对比

| 项目 | 架构模式 | 状态管理 | 特点 |
|------|---------|---------|------|
| **Calculator** | GetX MVC | GetX | 简洁、快速开发、禅意设计 |
| **Flutter_calendar** | Clean Architecture | BLoC + Provider | 企业级、可测试、复杂度高 |
| **flutter_calendar_view** | Package Library | Provider | 可复用组件库 |

---

## 🎯 推荐方案：混合架构（Hybrid Architecture）

基于 ZenCalendar 的特点（禅意应用、中等复杂度），我推荐采用 **GetX MVC + Clean Architecture 精简版** 的混合架构。

### 核心理念
- **简洁优先**：继承 Calculator 的禅意设计哲学
- **适度分层**：借鉴 Flutter_calendar 的清晰分层，但简化复杂度
- **快速开发**：使用 GetX 提升开发效率
- **可扩展性**：为未来功能预留架构空间

---

## 🏗️ 项目结构设计

```
lib/
├── main.dart                           # 应用入口
├── app/
│   ├── config/
│   │   └── theme/
│   │       ├── app_theme.dart          # 禅意主题配置
│   │       └── zen_colors.dart         # 禅意配色系统
│   │
│   ├── routes/
│   │   ├── app_pages.dart              # 路由配置
│   │   └── app_routes.dart             # 路由常量
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── event_model.dart        # 事件数据模型
│   │   │   ├── intention_model.dart    # 意图数据模型
│   │   │   └── zen_quote_model.dart    # 禅语数据模型
│   │   │
│   │   ├── providers/
│   │   │   ├── local_storage_provider.dart  # 本地存储
│   │   │   └── database_provider.dart       # 数据库（可选）
│   │   │
│   │   └── repositories/
│   │       ├── event_repository.dart        # 事件仓库
│   │       ├── intention_repository.dart    # 意图仓库
│   │       └── quote_repository.dart        # 禅语仓库
│   │
│   ├── modules/
│   │   ├── calendar/
│   │   │   ├── bindings/
│   │   │   │   └── calendar_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── calendar_controller.dart
│   │   │   └── views/
│   │   │       ├── calendar_view.dart
│   │   │       └── widgets/
│   │   │           ├── calendar_header.dart
│   │   │           ├── month_view.dart
│   │   │           ├── day_cell.dart
│   │   │           └── event_list.dart
│   │   │
│   │   ├── intention/
│   │   │   ├── bindings/
│   │   │   │   └── intention_binding.dart
│   │   │   ├── controllers/
│   │   │   │   └── intention_controller.dart
│   │   │   └── views/
│   │   │       ├── intention_view.dart
│   │   │       └── widgets/
│   │   │           ├── intention_card.dart
│   │   │           └── intention_input.dart
│   │   │
│   │   └── settings/
│   │       ├── bindings/
│   │       │   └── settings_binding.dart
│   │       ├── controllers/
│   │       │   └── settings_controller.dart
│   │       └── views/
│   │           └── settings_view.dart
│   │
│   ├── services/
│   │   ├── audio_service.dart          # 音频播放服务
│   │   ├── haptic_service.dart         # 触觉反馈服务
│   │   ├── notification_service.dart   # 通知服务
│   │   └── zen_quote_service.dart      # 禅语服务
│   │
│   ├── components/                     # 全局可复用组件
│   │   ├── soft_card.dart              # Soft UI 卡片
│   │   ├── zen_button.dart             # 禅意按钮
│   │   ├── zen_input.dart              # 禅意输入框
│   │   └── zen_quote_widget.dart       # 禅语组件
│   │
│   └── utils/
│       ├── date_utils.dart             # 日期工具
│       ├── validators.dart             # 验证工具
│       └── constants.dart              # 常量定义
│
└── core/                               # 核心基础设施（可选）
    ├── base/
    │   ├── base_controller.dart        # 基础控制器
    │   └── base_repository.dart        # 基础仓库
    └── extensions/
        ├── date_extensions.dart        # 日期扩展
        └── color_extensions.dart       # 颜色扩展
```

---

## 🎨 设计系统继承

### 从 Calculator 继承的设计元素

#### 1. 禅意配色方案
```dart
// 浅色主题 - 薰衣草庭院（ZenCalendar 特色）
static const Color lightBackground = Color(0xFFF0EBF4);  // 薰衣草白
static const Color lightShadowLight = Color(0xFFFFFBFF); // 纯白高光
static const Color lightShadowDark = Color(0xFFD4CFD8);  // 薰衣草灰阴影
static const Color lightText = Color(0xFF2D2A32);        // 深紫墨色
static const Color lightAccent = Color(0xFF9B86BD);      // 薰衣草紫

// 深色主题 - 夜间竹林（继承 Calculator）
static const Color darkBackground = Color(0xFF2B2D2A);   // 深竹绿灰
static const Color darkShadowLight = Color(0xFF3A3D38);  // 浅竹绿灰
static const Color darkShadowDark = Color(0xFF1C1E1B);   // 深夜色
static const Color darkText = Color(0xFFE8E4DC);         // 月光色
static const Color darkAccent = Color(0xFF8FA896);       // 浅竹绿
```

#### 2. Neumorphic/Soft UI 设计
- 柔和的阴影效果
- 自然的凸起/凹陷感
- 流畅的动画过渡（200-800ms）
- easeInOutCubic 曲线

#### 3. 触觉反馈系统
```dart
// 继承 Calculator 的触觉反馈分级
- 轻触：10ms（日期选择）
- 中等：15ms（事件创建）
- 强烈：20ms（删除操作）
```

---

## 📦 依赖包选择

### 核心依赖
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理 & 路由（继承 Calculator）
  get: ^4.6.6
  
  # 日历 UI（继承当前项目）
  table_calendar: ^3.1.2
  intl: ^0.19.0
  
  # 本地存储
  shared_preferences: ^2.2.0
  sqflite: ^2.3.0  # 可选：用于复杂事件存储
  
  # 触觉反馈 & 音频（继承 Calculator）
  vibration: ^2.0.0
  audioplayers: ^6.0.0
  
  # 通知（借鉴 Flutter_calendar）
  flutter_local_notifications: ^16.3.0
  timezone: ^0.9.2
  
  # 字体（当前项目）
  google_fonts: ^6.1.0
  
  # 工具
  uuid: ^4.2.1
  equatable: ^2.0.5
```

---

## 🔄 数据流设计

### GetX 响应式数据流

```
View (UI)
   ↓ 用户交互
Controller (业务逻辑)
   ↓ 调用
Repository (数据层)
   ↓ 访问
Provider (数据源)
   ↓ 返回
Controller (更新状态)
   ↓ 自动刷新
View (UI 更新)
```

### 示例：创建事件流程

```dart
// 1. View 触发
onPressed: () => controller.createEvent(event)

// 2. Controller 处理
Future<void> createEvent(Event event) async {
  isLoading.value = true;
  try {
    await _eventRepository.create(event);
    events.add(event);
    Get.snackbar('成功', '事件已创建');
  } catch (e) {
    Get.snackbar('错误', e.toString());
  } finally {
    isLoading.value = false;
  }
}

// 3. Repository 存储
Future<void> create(Event event) async {
  await _localStorageProvider.saveEvent(event);
}

// 4. UI 自动更新（GetX 响应式）
Obx(() => ListView.builder(
  itemCount: controller.events.length,
  ...
))
```

---

## 🎯 核心功能模块设计

### 1. Calendar Module（日历模块）

**职责**：
- 月视图展示
- 日期选择
- 事件列表显示
- 日期导航

**Controller 核心方法**：
```dart
class CalendarController extends GetxController {
  // 响应式状态
  final selectedDate = DateTime.now().obs;
  final focusedDate = DateTime.now().obs;
  final events = <Event>[].obs;
  final isLoading = false.obs;
  
  // 业务方法
  void selectDate(DateTime date);
  void changeMonth(int offset);
  Future<void> loadEvents(DateTime date);
  void navigateToEventDetail(Event event);
}
```

### 2. Intention Module（意图模块）

**职责**：
- 每日意图设定
- 意图历史查看
- 意图完成状态

**Controller 核心方法**：
```dart
class IntentionController extends GetxController {
  final todayIntention = Rxn<Intention>();
  final intentions = <Intention>[].obs;
  
  Future<void> setIntention(String text);
  Future<void> completeIntention();
  Future<void> loadIntentions();
}
```

### 3. Settings Module（设置模块）

**职责**：
- 主题切换
- 触觉反馈开关
- 音效开关
- 通知设置

---

## 🚀 实施步骤

### Phase 1: 基础架构搭建（1-2天）
1. ✅ 创建项目结构
2. ✅ 配置 GetX 路由
3. ✅ 实现禅意主题系统
4. ✅ 创建基础组件（SoftCard, ZenButton）

### Phase 2: 核心功能实现（3-4天）
1. ✅ Calendar Module
   - 月视图 UI
   - 日期选择逻辑
   - 事件列表展示
2. ✅ Event CRUD
   - 创建事件
   - 编辑事件
   - 删除事件
3. ✅ 本地存储
   - SharedPreferences 集成
   - 数据持久化

### Phase 3: 禅意功能（2-3天）
1. ✅ Intention Module
   - 每日意图设定
   - 意图历史
2. ✅ 禅语系统
   - 禅语服务
   - 智能触发
3. ✅ 触觉反馈
   - 分级震动
   - 场景适配

### Phase 4: 高级功能（2-3天）
1. ⏳ 通知系统
   - 本地通知
   - 事件提醒
2. ⏳ 音频播放
   - 冥想音乐
   - 自然音效
3. ⏳ 设置模块
   - 主题切换
   - 功能开关

### Phase 5: 优化与测试（1-2天）
1. ⏳ 性能优化
2. ⏳ UI 细节打磨
3. ⏳ 测试与修复

---

## 📊 架构优势对比

| 特性 | Calculator 架构 | Flutter_calendar 架构 | 推荐混合架构 |
|------|----------------|---------------------|-------------|
| **开发速度** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |
| **代码简洁** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **可测试性** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **可扩展性** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **学习曲线** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ |
| **适合规模** | 小型 | 大型 | 中小型 |

---

## 🎨 设计风格继承

### 从 Calculator 学习的设计原则

1. **极简主义**
   - 去除一切不必要的元素
   - 充足的留白空间
   - 单一焦点

2. **自然配色**
   - 温暖的色调
   - 柔和的对比
   - 自然的渐变

3. **流畅动画**
   - 缓慢、流畅的过渡
   - 避免突兀跳变
   - 呼吸感的节奏

4. **触觉反馈**
   - 分级震动设计
   - 场景化反馈
   - 自然的触感

---

## 💡 关键决策说明

### 为什么选择 GetX 而不是 BLoC？

**优势**：
- ✅ 更简洁的代码（减少 50% 样板代码）
- ✅ 更快的开发速度
- ✅ 内置路由和依赖注入
- ✅ 响应式编程更直观
- ✅ 更符合禅意"简洁"理念

**劣势**：
- ❌ 测试相对复杂（但可接受）
- ❌ 社区相对较小（但足够成熟）

### 为什么简化 Clean Architecture？

**原因**：
- ZenCalendar 是中等复杂度应用
- 不需要 UseCase 层（直接在 Controller 中处理）
- 保留 Repository 层（数据抽象）
- 简化 Entity/Model（合并为 Model）

**好处**：
- 减少文件数量（约 40%）
- 降低学习曲线
- 保持代码清晰
- 易于维护

---

## 📝 总结

这个混合架构方案：

1. **继承 Calculator 的优点**
   - 禅意设计哲学
   - GetX 快速开发
   - Neumorphic UI 风格
   - 触觉反馈系统

2. **借鉴 Flutter_calendar 的优点**
   - 清晰的分层结构
   - Repository 模式
   - 依赖注入
   - 通知系统

3. **适配 ZenCalendar 的需求**
   - 中等复杂度
   - 快速迭代
   - 易于维护
   - 可扩展性

**最终目标**：打造一个简洁、优雅、高效的禅意日历应用。
