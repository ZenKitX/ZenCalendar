# ZenCalendar 架构迁移指南

## 📋 当前状态分析

### 现有架构
```
lib/
├── main.dart
├── models/
│   └── daily_intention.dart
├── screens/
│   └── calendar_screen.dart
├── services/
│   ├── audio_service.dart
│   ├── haptic_service.dart
│   ├── intention_service.dart
│   └── zen_quote_service.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    ├── soft_card.dart
    └── zen_quote_widget.dart
```

### 目标架构（GetX MVC）
```
lib/
├── main.dart
└── app/
    ├── config/theme/
    ├── routes/
    ├── data/
    │   ├── models/
    │   ├── providers/
    │   └── repositories/
    ├── modules/
    │   ├── calendar/
    │   ├── intention/
    │   └── settings/
    ├── services/
    ├── components/
    └── utils/
```

---

## 🔄 迁移步骤

### Step 1: 安装 GetX 依赖

```yaml
# pubspec.yaml
dependencies:
  get: ^4.6.6
  uuid: ^4.2.1
  equatable: ^2.0.5
```

运行：
```bash
flutter pub get
```

---

### Step 2: 创建新的目录结构

```bash
# 创建 app 目录结构
mkdir -p lib/app/{config/theme,routes,data/{models,providers,repositories},modules/{calendar,intention,settings}/{bindings,controllers,views/widgets},services,components,utils}
```

---

### Step 3: 迁移主题配置

#### 3.1 移动并重构主题文件

**原文件**: `lib/theme/app_theme.dart`  
**新位置**: `lib/app/config/theme/app_theme.dart`

**重构内容**:
```dart
// lib/app/config/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'zen_colors.dart';

class AppTheme {
  // 浅色主题
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ZenColors.lightBackground,
    primaryColor: ZenColors.lightAccent,
    colorScheme: ColorScheme.light(
      primary: ZenColors.lightAccent,
      secondary: ZenColors.lightAccentSecondary,
      surface: ZenColors.lightBackground,
      background: ZenColors.lightBackground,
      error: ZenColors.errorColor,
    ),
    textTheme: _buildTextTheme(ZenColors.lightText),
    appBarTheme: _buildAppBarTheme(true),
    cardTheme: _buildCardTheme(true),
  );
  
  // 深色主题
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ZenColors.darkBackground,
    primaryColor: ZenColors.darkAccent,
    colorScheme: ColorScheme.dark(
      primary: ZenColors.darkAccent,
      secondary: ZenColors.darkAccentSecondary,
      surface: ZenColors.darkBackground,
      background: ZenColors.darkBackground,
      error: ZenColors.errorColor,
    ),
    textTheme: _buildTextTheme(ZenColors.darkText),
    appBarTheme: _buildAppBarTheme(false),
    cardTheme: _buildCardTheme(false),
  );
  
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor.withOpacity(0.8),
      ),
    );
  }
  
  static AppBarTheme _buildAppBarTheme(bool isLight) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: isLight ? ZenColors.lightText : ZenColors.darkText,
    );
  }
  
  static CardTheme _buildCardTheme(bool isLight) {
    return CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isLight ? ZenColors.lightCardBackground : ZenColors.darkCardBackground,
    );
  }
}
```

#### 3.2 创建颜色配置文件

```dart
// lib/app/config/theme/zen_colors.dart
import 'package:flutter/material.dart';

class ZenColors {
  // 浅色主题 - 薰衣草庭院
  static const Color lightBackground = Color(0xFFF0EBF4);
  static const Color lightCardBackground = Color(0xFFFFFBFF);
  static const Color lightShadowLight = Color(0xFFFFFBFF);
  static const Color lightShadowDark = Color(0xFFD4CFD8);
  static const Color lightText = Color(0xFF2D2A32);
  static const Color lightTextSecondary = Color(0xFF6B6570);
  static const Color lightAccent = Color(0xFF9B86BD);
  static const Color lightAccentSecondary = Color(0xFFB8A5D6);
  
  // 深色主题 - 夜间竹林
  static const Color darkBackground = Color(0xFF2B2D2A);
  static const Color darkCardBackground = Color(0xFF3A3D38);
  static const Color darkShadowLight = Color(0xFF3A3D38);
  static const Color darkShadowDark = Color(0xFF1C1E1B);
  static const Color darkText = Color(0xFFE8E4DC);
  static const Color darkTextSecondary = Color(0xFFA8A49C);
  static const Color darkAccent = Color(0xFF8FA896);
  static const Color darkAccentSecondary = Color(0xFFA5BDB0);
  
  // 健康绿（保留原有）
  static const Color healthGreen = Color(0xFF7C9885);
  static const Color healthGreenLight = Color(0xFF9BB5A3);
  
  // 功能色
  static const Color errorColor = Color(0xFFD97979);
  static const Color warningColor = Color(0xFFE8B86D);
  static const Color successColor = Color(0xFF7C9885);
  static const Color infoColor = Color(0xFF7B9FD9);
}
```

---

### Step 4: 设置 GetX 路由

#### 4.1 创建路由文件

```dart
// lib/app/routes/app_routes.dart
part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  
  static const CALENDAR = _Paths.CALENDAR;
  static const INTENTION = _Paths.INTENTION;
  static const EVENT_DETAIL = _Paths.EVENT_DETAIL;
  static const CREATE_EVENT = _Paths.CREATE_EVENT;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();
  
  static const CALENDAR = '/calendar';
  static const INTENTION = '/intention';
  static const EVENT_DETAIL = '/event/:id';
  static const CREATE_EVENT = '/create-event';
  static const SETTINGS = '/settings';
}
```

```dart
// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/intention/bindings/intention_binding.dart';
import '../modules/intention/views/intention_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.CALENDAR;

  static final routes = [
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: _Paths.INTENTION,
      page: () => const IntentionView(),
      binding: IntentionBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
```

---

### Step 5: 迁移数据模型

#### 5.1 重构 DailyIntention Model

**原文件**: `lib/models/daily_intention.dart`  
**新位置**: `lib/app/data/models/intention_model.dart`

```dart
// lib/app/data/models/intention_model.dart
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class IntentionModel extends Equatable {
  final String id;
  final String text;
  final DateTime date;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const IntentionModel({
    required this.id,
    required this.text,
    required this.date,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  // 工厂构造函数
  factory IntentionModel.create({
    required String text,
    required DateTime date,
  }) {
    return IntentionModel(
      id: const Uuid().v4(),
      text: text,
      date: date,
      createdAt: DateTime.now(),
    );
  }

  // copyWith
  IntentionModel copyWith({
    String? id,
    String? text,
    DateTime? date,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return IntentionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // JSON 序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory IntentionModel.fromJson(Map<String, dynamic> json) {
    return IntentionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, text, date, isCompleted, createdAt, completedAt];
}
```

#### 5.2 创建 Event Model

```dart
// lib/app/data/models/event_model.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EventModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool isAllDay;
  final List<DateTime> reminders;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.isAllDay = false,
    this.reminders = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.create({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    Color? color,
    bool isAllDay = false,
    List<DateTime>? reminders,
  }) {
    final now = DateTime.now();
    return EventModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      color: color ?? Colors.blue,
      isAllDay: isAllDay,
      reminders: reminders ?? [],
      createdAt: now,
      updatedAt: now,
    );
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    bool? isAllDay,
    List<DateTime>? reminders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      isAllDay: isAllDay ?? this.isAllDay,
      reminders: reminders ?? this.reminders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'color': color.value,
      'isAllDay': isAllDay,
      'reminders': reminders.map((r) => r.toIso8601String()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      color: Color(json['color'] as int),
      isAllDay: json['isAllDay'] as bool,
      reminders: (json['reminders'] as List<dynamic>)
          .map((r) => DateTime.parse(r as String))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        color,
        isAllDay,
        reminders,
        createdAt,
        updatedAt,
      ];
}
```

---

### Step 6: 创建数据层

#### 6.1 创建 Local Storage Provider

```dart
// lib/app/data/providers/local_storage_provider.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/intention_model.dart';

class LocalStorageProvider {
  final SharedPreferences _prefs;

  LocalStorageProvider(this._prefs);

  // Events
  static const String _eventsKey = 'events';

  Future<List<EventModel>> getEvents() async {
    final String? eventsJson = _prefs.getString(_eventsKey);
    if (eventsJson == null) return [];

    final List<dynamic> eventsList = json.decode(eventsJson);
    return eventsList.map((e) => EventModel.fromJson(e)).toList();
  }

  Future<void> saveEvents(List<EventModel> events) async {
    final String eventsJson = json.encode(
      events.map((e) => e.toJson()).toList(),
    );
    await _prefs.setString(_eventsKey, eventsJson);
  }

  // Intentions
  static const String _intentionsKey = 'intentions';

  Future<List<IntentionModel>> getIntentions() async {
    final String? intentionsJson = _prefs.getString(_intentionsKey);
    if (intentionsJson == null) return [];

    final List<dynamic> intentionsList = json.decode(intentionsJson);
    return intentionsList.map((i) => IntentionModel.fromJson(i)).toList();
  }

  Future<void> saveIntentions(List<IntentionModel> intentions) async {
    final String intentionsJson = json.encode(
      intentions.map((i) => i.toJson()).toList(),
    );
    await _prefs.setString(_intentionsKey, intentionsJson);
  }

  // Settings
  static const String _themeKey = 'theme_mode';
  static const String _hapticKey = 'haptic_enabled';
  static const String _audioKey = 'audio_enabled';

  ThemeMode getThemeMode() {
    final int? themeIndex = _prefs.getInt(_themeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeKey, mode.index);
  }

  bool getHapticEnabled() {
    return _prefs.getBool(_hapticKey) ?? true;
  }

  Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool(_hapticKey, enabled);
  }

  bool getAudioEnabled() {
    return _prefs.getBool(_audioKey) ?? true;
  }

  Future<void> setAudioEnabled(bool enabled) async {
    await _prefs.setBool(_audioKey, enabled);
  }
}
```

#### 6.2 创建 Repository

```dart
// lib/app/data/repositories/event_repository.dart
import '../models/event_model.dart';
import '../providers/local_storage_provider.dart';

class EventRepository {
  final LocalStorageProvider _storageProvider;

  EventRepository(this._storageProvider);

  Future<List<EventModel>> getAll() async {
    return await _storageProvider.getEvents();
  }

  Future<List<EventModel>> getByDate(DateTime date) async {
    final events = await getAll();
    return events.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList();
  }

  Future<EventModel?> getById(String id) async {
    final events = await getAll();
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> create(EventModel event) async {
    final events = await getAll();
    events.add(event);
    await _storageProvider.saveEvents(events);
  }

  Future<void> update(EventModel event) async {
    final events = await getAll();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event.copyWith(updatedAt: DateTime.now());
      await _storageProvider.saveEvents(events);
    }
  }

  Future<void> delete(String id) async {
    final events = await getAll();
    events.removeWhere((event) => event.id == id);
    await _storageProvider.saveEvents(events);
  }
}
```

```dart
// lib/app/data/repositories/intention_repository.dart
import '../models/intention_model.dart';
import '../providers/local_storage_provider.dart';

class IntentionRepository {
  final LocalStorageProvider _storageProvider;

  IntentionRepository(this._storageProvider);

  Future<List<IntentionModel>> getAll() async {
    return await _storageProvider.getIntentions();
  }

  Future<IntentionModel?> getByDate(DateTime date) async {
    final intentions = await getAll();
    try {
      return intentions.firstWhere((intention) {
        return intention.date.year == date.year &&
            intention.date.month == date.month &&
            intention.date.day == date.day;
      });
    } catch (e) {
      return null;
    }
  }

  Future<void> create(IntentionModel intention) async {
    final intentions = await getAll();
    intentions.add(intention);
    await _storageProvider.saveIntentions(intentions);
  }

  Future<void> update(IntentionModel intention) async {
    final intentions = await getAll();
    final index = intentions.indexWhere((i) => i.id == intention.id);
    if (index != -1) {
      intentions[index] = intention;
      await _storageProvider.saveIntentions(intentions);
    }
  }

  Future<void> delete(String id) async {
    final intentions = await getAll();
    intentions.removeWhere((intention) => intention.id == id);
    await _storageProvider.saveIntentions(intentions);
  }
}
```

---

### Step 7: 迁移服务层

**原位置**: `lib/services/`  
**新位置**: `lib/app/services/`

只需移动文件，无需修改代码：
- `audio_service.dart`
- `haptic_service.dart`
- `zen_quote_service.dart`

删除 `intention_service.dart`（功能已整合到 Repository）

---

### Step 8: 迁移组件

**原位置**: `lib/widgets/`  
**新位置**: `lib/app/components/`

移动文件：
- `soft_card.dart`
- `zen_quote_widget.dart`

---

### Step 9: 创建 Calendar Module

详见下一节的完整实现...

---

## 📝 迁移检查清单

- [ ] 安装 GetX 依赖
- [ ] 创建新目录结构
- [ ] 迁移主题配置
- [ ] 创建颜色配置
- [ ] 设置 GetX 路由
- [ ] 重构数据模型
- [ ] 创建 Provider 层
- [ ] 创建 Repository 层
- [ ] 迁移服务层
- [ ] 迁移组件层
- [ ] 创建 Calendar Module
- [ ] 创建 Intention Module
- [ ] 创建 Settings Module
- [ ] 更新 main.dart
- [ ] 测试所有功能
- [ ] 删除旧文件

---

## ⚠️ 注意事项

1. **渐进式迁移**：不要一次性删除所有旧代码，先确保新代码工作正常
2. **保留备份**：使用 Git 分支进行迁移
3. **测试驱动**：每迁移一个模块就测试一次
4. **依赖注入**：使用 GetX 的依赖注入管理所有服务和仓库
5. **响应式编程**：充分利用 GetX 的 `.obs` 和 `Obx()` 实现响应式 UI

---

## 🎯 下一步

完成迁移后，参考 `ARCHITECTURE_PROPOSAL.md` 继续实现新功能。
