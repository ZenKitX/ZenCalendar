import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../services/haptic_service.dart';

/// 周视图控制器
class WeekController extends GetxController {
  // 依赖注入
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 响应式状态
  final selectedDate = DateTime.now().obs;
  final currentWeekStart = DateTime.now().obs;
  final events = <EventModel>[].obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('WeekController initialized');
    _initializeWeek();
    loadEvents();
  }
  
  /// 初始化周视图
  void _initializeWeek() {
    final now = DateTime.now();
    currentWeekStart.value = _getWeekStart(now);
    selectedDate.value = now;
  }
  
  /// 获取一周的开始日期（周一）
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }
  
  /// 获取一周的结束日期（周日）
  DateTime _getWeekEnd(DateTime weekStart) {
    return weekStart.add(const Duration(days: 6));
  }
  
  /// 获取当前周的日期列表
  List<DateTime> get currentWeekDates {
    final weekStart = currentWeekStart.value;
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }
  
  /// 加载事件
  Future<void> loadEvents() async {
    try {
      isLoading.value = true;
      events.value = await _eventRepository.getAll();
      print('✅ Loaded ${events.length} events for week view');
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
  
  /// 选择日期
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _hapticService.light();
  }
  
  /// 切换到上一周
  void previousWeek() {
    currentWeekStart.value = currentWeekStart.value.subtract(const Duration(days: 7));
    _hapticService.light();
  }
  
  /// 切换到下一周
  void nextWeek() {
    currentWeekStart.value = currentWeekStart.value.add(const Duration(days: 7));
    _hapticService.light();
  }
  
  /// 回到本周
  void goToThisWeek() {
    final now = DateTime.now();
    currentWeekStart.value = _getWeekStart(now);
    selectedDate.value = now;
    _hapticService.medium();
  }
  
  /// 获取指定日期的事件
  List<EventModel> getEventsForDate(DateTime date) {
    return events.where((event) => event.isOnDate(date)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }
  
  /// 获取当前周的所有事件
  List<EventModel> get currentWeekEvents {
    final weekStart = currentWeekStart.value;
    final weekEnd = _getWeekEnd(weekStart);
    
    return events.where((event) {
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      return eventDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
             eventDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }
  
  /// 获取选中日期的事件
  List<EventModel> get selectedDateEvents {
    return getEventsForDate(selectedDate.value);
  }
  
  /// 格式化周标题
  String get weekTitle {
    final weekStart = currentWeekStart.value;
    final weekEnd = _getWeekEnd(weekStart);
    
    if (weekStart.month == weekEnd.month) {
      return '${weekStart.year}年${weekStart.month}月${weekStart.day}日 - ${weekEnd.day}日';
    } else {
      return '${weekStart.year}年${weekStart.month}月${weekStart.day}日 - ${weekEnd.month}月${weekEnd.day}日';
    }
  }
  
  /// 检查是否是今天
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  /// 检查是否是选中日期
  bool isSelectedDate(DateTime date) {
    final selected = selectedDate.value;
    return date.year == selected.year &&
           date.month == selected.month &&
           date.day == selected.day;
  }
}