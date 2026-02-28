# ZenCalendar 快速参考指南

## 🎯 核心概念速查

### GetX 三大核心

| 功能 | 用途 | 示例 |
|------|------|------|
| **状态管理** | 响应式数据 | `final count = 0.obs;` |
| **路由管理** | 页面导航 | `Get.to(() => NextPage());` |
| **依赖注入** | 服务管理 | `Get.put(Controller());` |

---

## 📁 项目结构速查

```
lib/app/
├── config/theme/          # 主题配置
├── routes/                # 路由配置
├── data/                  # 数据层
│   ├── models/           # 数据模型
│   ├── providers/        # 数据源
│   └── repositories/     # 数据仓库
├── modules/              # 功能模块
│   └── [module]/
│       ├── bindings/     # 依赖绑定
│       ├── controllers/  # 业务逻辑
│       └── views/        # UI 界面
├── services/             # 全局服务
├── components/           # 可复用组件
└── utils/                # 工具函数
```

---

## 🚀 常用代码片段

### 1. 创建新模块

```dart
// 1. Controller
class MyController extends GetxController {
  final myData = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    // 加载数据
  }
}

// 2. Binding
class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyController>(() => MyController());
  }
}

// 3. View
class MyView extends GetView<MyController> {
  const MyView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(
        itemCount: controller.myData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(controller.myData[index]),
          );
        },
      )),
    );
  }
}

// 4. 路由注册
GetPage(
  name: '/my-page',
  page: () => const MyView(),
  binding: MyBinding(),
),
```

### 2. 响应式状态

```dart
// 声明响应式变量
final count = 0.obs;
final name = ''.obs;
final user = Rxn<User>();  // 可空对象
final items = <String>[].obs;

// 更新值
count.value++;
name.value = 'New Name';
user.value = User(name: 'John');
items.add('New Item');

// UI 中使用
Obx(() => Text('Count: ${count.value}'))

// 或使用 GetBuilder（性能更好，但需手动刷新）
GetBuilder<MyController>(
  builder: (controller) => Text('Count: ${controller.count}'),
)
```

### 3. 路由导航

```dart
// 跳转到新页面
Get.to(() => NextPage());

// 命名路由
Get.toNamed('/calendar');

// 带参数
Get.toNamed('/event/123');

// 替换当前页面
Get.off(() => NextPage());

// 清空栈并跳转
Get.offAll(() => HomePage());

// 返回
Get.back();

// 返回并传递数据
Get.back(result: {'success': true});

// 接收返回数据
final result = await Get.to(() => NextPage());
```

### 4. 依赖注入

```dart
// 注册依赖
Get.put(MyService());  // 立即创建
Get.lazyPut(() => MyService());  // 懒加载
Get.putAsync(() async => await MyService.create());  // 异步

// 获取依赖
final service = Get.find<MyService>();

// 删除依赖
Get.delete<MyService>();
```

### 5. 对话框和提示

```dart
// Snackbar
Get.snackbar(
  '成功',
  '操作完成',
  snackPosition: SnackPosition.BOTTOM,
  duration: const Duration(seconds: 2),
);

// Dialog
Get.dialog(
  AlertDialog(
    title: const Text('提示'),
    content: const Text('确定删除吗？'),
    actions: [
      TextButton(
        onPressed: () => Get.back(),
        child: const Text('取消'),
      ),
      TextButton(
        onPressed: () {
          // 执行删除
          Get.back();
        },
        child: const Text('确定'),
      ),
    ],
  ),
);

// BottomSheet
Get.bottomSheet(
  Container(
    height: 200,
    color: Colors.white,
    child: const Center(
      child: Text('Bottom Sheet'),
    ),
  ),
);
```

### 6. Repository 模式

```dart
// Repository
class EventRepository {
  final LocalStorageProvider _provider;
  
  EventRepository(this._provider);
  
  Future<List<Event>> getAll() async {
    return await _provider.getEvents();
  }
  
  Future<void> create(Event event) async {
    final events = await getAll();
    events.add(event);
    await _provider.saveEvents(events);
  }
}

// Controller 中使用
class CalendarController extends GetxController {
  final EventRepository _repository;
  final events = <Event>[].obs;
  
  CalendarController(this._repository);
  
  Future<void> loadEvents() async {
    events.value = await _repository.getAll();
  }
  
  Future<void> createEvent(Event event) async {
    await _repository.create(event);
    await loadEvents();
  }
}
```

### 7. 生命周期

```dart
class MyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // 初始化，类似 initState
    print('Controller initialized');
  }
  
  @override
  void onReady() {
    super.onReady();
    // 渲染完成后调用
    print('Controller ready');
  }
  
  @override
  void onClose() {
    // 清理资源
    print('Controller disposed');
    super.onClose();
  }
}
```

---

## 🎨 禅意设计速查

### 颜色使用

```dart
// 浅色主题
ZenColors.lightBackground      // 背景色
ZenColors.lightText           // 主文字
ZenColors.lightTextSecondary  // 次要文字
ZenColors.lightAccent         // 强调色

// 深色主题
ZenColors.darkBackground
ZenColors.darkText
ZenColors.darkTextSecondary
ZenColors.darkAccent

// 功能色
ZenColors.healthGreen         // 健康绿
ZenColors.errorColor          // 错误红
ZenColors.successColor        // 成功绿
```

### Soft UI 效果

```dart
// 使用 SoftCard 组件
SoftCard(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Content'),
  ),
)

// 自定义阴影
BoxDecoration(
  color: ZenColors.lightBackground,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: ZenColors.lightShadowDark,
      offset: const Offset(4, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: ZenColors.lightShadowLight,
      offset: const Offset(-4, -4),
      blurRadius: 8,
    ),
  ],
)
```

### 动画时序

```dart
// 快速响应（按钮按压）
duration: const Duration(milliseconds: 150)

// 柔和变化（阴影过渡）
duration: const Duration(milliseconds: 200)

// 平静过渡（内容切换）
duration: const Duration(milliseconds: 300)

// 缓慢呼吸（主题切换）
duration: const Duration(milliseconds: 800)

// 统一曲线
curve: Curves.easeInOutCubic
```

---

## 🔧 服务使用

### 触觉反馈

```dart
// 注入服务
final hapticService = Get.find<HapticService>();

// 使用
hapticService.light();    // 轻触（10ms）
hapticService.medium();   // 中等（15ms）
hapticService.heavy();    // 强烈（20ms）
hapticService.selection(); // 选择（8ms）
```

### 音频播放

```dart
final audioService = Get.find<AudioService>();

await audioService.playSound('tap');
await audioService.playSound('success');
await audioService.stopAll();
```

### 禅语服务

```dart
final quoteService = Get.find<ZenQuoteService>();

final quote = quoteService.getRandomQuote();
final clearQuote = quoteService.getClearQuote();
final errorQuote = quoteService.getErrorQuote();
```

---

## 📱 常用 Widget

### 响应式列表

```dart
Obx(() => ListView.builder(
  itemCount: controller.items.length,
  itemBuilder: (context, index) {
    final item = controller.items[index];
    return ListTile(
      title: Text(item.title),
      onTap: () => controller.selectItem(item),
    );
  },
))
```

### 加载状态

```dart
Obx(() {
  if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }
  
  if (controller.items.isEmpty) {
    return const Center(child: Text('暂无数据'));
  }
  
  return ListView.builder(...);
})
```

### 表单输入

```dart
TextField(
  onChanged: (value) => controller.title.value = value,
  decoration: InputDecoration(
    labelText: '标题',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

---

## 🐛 常见问题

### 1. Controller 未找到

```dart
// 错误
final controller = Get.find<MyController>();

// 解决：确保在 Binding 中注册
class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyController>(() => MyController());
  }
}
```

### 2. 响应式变量不更新

```dart
// 错误
final items = <String>[].obs;
items.add('new');  // UI 不会更新

// 正确
items.value.add('new');
items.refresh();  // 手动刷新

// 或者
items.value = [...items.value, 'new'];
```

### 3. 内存泄漏

```dart
// 在 onClose 中清理资源
@override
void onClose() {
  _scrollController.dispose();
  _textController.dispose();
  super.onClose();
}
```

---

## 📚 学习资源

- [GetX 官方文档](https://github.com/jonataslaw/getx)
- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 语言指南](https://dart.dev/guides)

---

## 💡 最佳实践

1. **单一职责**：每个 Controller 只负责一个功能模块
2. **依赖注入**：使用 Binding 管理依赖，不要在 Controller 中直接创建
3. **响应式优先**：优先使用 `.obs` 和 `Obx()`，性能敏感场景使用 `GetBuilder`
4. **错误处理**：使用 try-catch 包裹异步操作
5. **代码复用**：提取公共组件到 `components/` 目录
6. **命名规范**：
   - Controller: `XxxController`
   - Binding: `XxxBinding`
   - View: `XxxView`
   - Model: `XxxModel`
   - Repository: `XxxRepository`

---

## 🎯 开发流程

1. **创建 Model** → 定义数据结构
2. **创建 Provider** → 实现数据源
3. **创建 Repository** → 封装数据操作
4. **创建 Controller** → 实现业务逻辑
5. **创建 Binding** → 注册依赖
6. **创建 View** → 实现 UI
7. **注册路由** → 添加到 `app_pages.dart`
8. **测试功能** → 确保正常工作

---

**提示**：将此文件加入书签，开发时随时查阅！
