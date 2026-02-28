import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/calendar_view_type.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../services/haptic_service.dart';
import 'week_controller.dart';
import 'day_controller.dart';

/// Calendar 控制器
class CalendarController extends GetxController {
  // 依赖注入
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 响应式状态
  final selectedDate = DateTime.now().obs;
  final focusedDate = DateTime.now().obs;
  final events = <EventModel>[].obs;
  final isLoading = false.obs;
  final currentViewType = CalendarViewType.month.obs;
  
  // 子控制器
  WeekController? _weekController;
  DayController? _dayController;
  
  @override
  void onInit() {
    super.onInit();
    print('CalendarController initialized');
    _initializeSubControllers();
    loadEvents();
  }
  
  /// 初始化子控制器
  void _initializeSubControllers() {
    _weekController = Get.put(WeekController(), tag: 'week');
    _dayController = Get.put(DayController(), tag: 'day');
  }
  
  @override
  void onReady() {
    super.onReady();
    print('CalendarController ready');
  }
  
  @override
  void onClose() {
    print('CalendarController disposed');
    // 清理子控制器
    Get.delete<WeekController>(tag: 'week');
    Get.delete<DayController>(tag: 'day');
    super.onClose();
  }
  
  /// 加载事件
  Future<void> loadEvents() async {
    try {
      isLoading.value = true;
      events.value = await _eventRepository.getAll();
      print('✅ Loaded ${events.length} events');
    } catch (e) {
      print('❌ Error loading events: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '加载事件失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 根据日期加载事件
  Future<void> loadEventsByDate(DateTime date) async {
    try {
      isLoading.value = true;
      final allEvents = await _eventRepository.getAll();
      events.value = allEvents;
    } catch (e) {
      print('❌ Error loading events by date: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 选择日期
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _hapticService.light();
  }
  
  /// 改变月份
  void changeMonth(int offset) {
    focusedDate.value = DateTime(
      focusedDate.value.year,
      focusedDate.value.month + offset,
      1,
    );
  }
  
  /// 回到今天
  void goToToday() {
    final today = DateTime.now();
    selectedDate.value = today;
    focusedDate.value = today;
    _hapticService.medium();
  }
  
  /// 获取选中日期的事件
  List<EventModel> get selectedDateEvents {
    return events.where((event) => event.isOnDate(selectedDate.value)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }
  
  /// 删除事件
  Future<void> deleteEvent(String id) async {
    try {
      await _eventRepository.delete(id);
      await loadEvents();
      
      _hapticService.success();
      Get.snackbar(
        '成功',
        '事件已删除',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error deleting event: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '删除事件失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 创建测试事件（用于测试）
  Future<void> createTestEvent() async {
    try {
      final now = DateTime.now();
      final event = EventModel.create(
        title: '测试事件 ${now.hour}:${now.minute}',
        description: '这是一个测试事件，用于演示功能',
        startTime: selectedDate.value.add(Duration(
          hours: 9 + events.length,
          minutes: 0,
        )),
        endTime: selectedDate.value.add(Duration(
          hours: 10 + events.length,
          minutes: 0,
        )),
      );
      
      await _eventRepository.create(event);
      await loadEvents();
      
      _hapticService.success();
      Get.snackbar(
        '成功',
        '测试事件已创建',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error creating test event: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '创建事件失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 切换视图类型
  void switchViewType(CalendarViewType viewType) {
    if (currentViewType.value == viewType) return;
    
    currentViewType.value = viewType;
    _hapticService.light();
    
    // 同步选中日期到子控制器
    switch (viewType) {
      case CalendarViewType.week:
        _weekController?.selectDate(selectedDate.value);
        break;
      case CalendarViewType.day:
        _dayController?.selectDate(selectedDate.value);
        break;
      case CalendarViewType.month:
        // 月视图使用当前控制器
        break;
    }
  }
  
  /// 获取当前视图的控制器
  WeekController? get weekController => _weekController;
  DayController? get dayController => _dayController;
  
  /// 同步日期选择到所有控制器
  void syncDateSelection(DateTime date) {
    selectedDate.value = date;
    _weekController?.selectDate(date);
    _dayController?.selectDate(date);
  }
}
