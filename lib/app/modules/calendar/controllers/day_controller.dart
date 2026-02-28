import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../services/haptic_service.dart';

/// 日视图控制器
class DayController extends GetxController {
  // 依赖注入
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 响应式状态
  final selectedDate = DateTime.now().obs;
  final events = <EventModel>[].obs;
  final isLoading = false.obs;
  final scrollController = ScrollController();
  
  // 时间轴配置
  static const int startHour = 0;
  static const int endHour = 24;
  static const double hourHeight = 60.0;
  
  @override
  void onInit() {
    super.onInit();
    print('DayController initialized');
    loadEvents();
    _scrollToCurrentTime();
  }
  
  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  
  /// 滚动到当前时间
  void _scrollToCurrentTime() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isToday(selectedDate.value)) {
        final now = DateTime.now();
        final currentHour = now.hour;
        final currentMinute = now.minute;
        
        // 计算滚动位置（提前2小时显示）
        final scrollPosition = (currentHour - 2) * hourHeight + 
                              (currentMinute / 60) * hourHeight;
        
        if (scrollController.hasClients && scrollPosition > 0) {
          scrollController.animateTo(
            scrollPosition.clamp(0.0, scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }
  
  /// 加载事件
  Future<void> loadEvents() async {
    try {
      isLoading.value = true;
      events.value = await _eventRepository.getAll();
      print('✅ Loaded ${events.length} events for day view');
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
    _scrollToCurrentTime();
  }
  
  /// 切换到上一天
  void previousDay() {
    selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    _hapticService.light();
    _scrollToCurrentTime();
  }
  
  /// 切换到下一天
  void nextDay() {
    selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    _hapticService.light();
    _scrollToCurrentTime();
  }
  
  /// 回到今天
  void goToToday() {
    selectedDate.value = DateTime.now();
    _hapticService.medium();
    _scrollToCurrentTime();
  }
  
  /// 获取选中日期的事件
  List<EventModel> get selectedDateEvents {
    return events.where((event) => event.isOnDate(selectedDate.value)).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }
  
  /// 获取全天事件
  List<EventModel> get allDayEvents {
    return selectedDateEvents.where((event) => event.isAllDay).toList();
  }
  
  /// 获取定时事件
  List<EventModel> get timedEvents {
    return selectedDateEvents.where((event) => !event.isAllDay).toList();
  }
  
  /// 格式化日期标题
  String get dayTitle {
    final date = selectedDate.value;
    final now = DateTime.now();
    
    if (isToday(date)) {
      return '今天 ${date.month}月${date.day}日';
    } else if (date.isAtSameMomentAs(now.add(const Duration(days: 1)))) {
      return '明天 ${date.month}月${date.day}日';
    } else if (date.isAtSameMomentAs(now.subtract(const Duration(days: 1)))) {
      return '昨天 ${date.month}月${date.day}日';
    } else {
      final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      final weekday = weekdays[date.weekday - 1];
      return '$weekday ${date.month}月${date.day}日';
    }
  }
  
  /// 检查是否是今天
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  /// 获取当前时间线位置
  double get currentTimeLinePosition {
    if (!isToday(selectedDate.value)) return -1;
    
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    
    return hour * hourHeight + (minute / 60) * hourHeight;
  }
  
  /// 根据时间获取Y坐标
  double getYPositionForTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    return hour * hourHeight + (minute / 60) * hourHeight;
  }
  
  /// 根据Y坐标获取时间
  DateTime getTimeForYPosition(double yPosition) {
    final totalMinutes = (yPosition / hourHeight) * 60;
    final hour = (totalMinutes / 60).floor();
    final minute = (totalMinutes % 60).round();
    
    return DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      hour.clamp(0, 23),
      minute.clamp(0, 59),
    );
  }
  
  /// 创建新事件（在指定时间）
  Future<void> createEventAtTime(double yPosition) async {
    final startTime = getTimeForYPosition(yPosition);
    final endTime = startTime.add(const Duration(hours: 1));
    
    _hapticService.medium();
    
    final result = await Get.toNamed(
      '/create-event',
      arguments: {
        'date': selectedDate.value,
        'startTime': startTime,
        'endTime': endTime,
      },
    );
    
    if (result == true) {
      loadEvents();
    }
  }
}