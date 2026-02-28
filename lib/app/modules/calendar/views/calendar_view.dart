import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/calendar_view_type.dart';
import '../../../routes/app_pages.dart';
import '../controllers/calendar_controller.dart';
import '../controllers/week_controller.dart';
import '../controllers/day_controller.dart';
import 'widgets/zen_calendar_widget.dart';
import 'widgets/event_list_widget.dart';
import 'widgets/view_switcher_widget.dart';
import 'week_view.dart';
import 'day_view.dart';

/// Calendar 视图
class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.events.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('ZenCalendar'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Get.toNamed(Routes.SEARCH);
              },
              tooltip: '搜索',
            ),
            IconButton(
              icon: const Icon(Icons.today_outlined),
              onPressed: () {
                switch (controller.currentViewType.value) {
                  case CalendarViewType.month:
                    controller.goToToday();
                    break;
                  case CalendarViewType.week:
                    if (Get.isRegistered<WeekController>(tag: 'week')) {
                      Get.find<WeekController>(tag: 'week').goToThisWeek();
                    }
                    break;
                  case CalendarViewType.day:
                    if (Get.isRegistered<DayController>(tag: 'day')) {
                      Get.find<DayController>(tag: 'day').goToToday();
                    }
                    break;
                }
              },
              tooltip: '回到今天',
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.loadEvents();
            // 同时刷新子控制器
            if (Get.isRegistered<WeekController>(tag: 'week')) {
              await Get.find<WeekController>(tag: 'week').loadEvents();
            }
            if (Get.isRegistered<DayController>(tag: 'day')) {
              await Get.find<DayController>(tag: 'day').loadEvents();
            }
          },
          child: Column(
            children: [
              // 视图切换器
              ViewSwitcherWidget(
                currentViewType: controller.currentViewType.value,
                onViewTypeChanged: controller.switchViewType,
              ),
              
              // 视图内容
              Expanded(
                child: _buildCurrentView(context),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            DateTime selectedDate;
            
            // 根据当前视图获取选中日期
            switch (controller.currentViewType.value) {
              case CalendarViewType.month:
                selectedDate = controller.selectedDate.value;
                break;
              case CalendarViewType.week:
                selectedDate = Get.isRegistered<WeekController>(tag: 'week')
                    ? Get.find<WeekController>(tag: 'week').selectedDate.value
                    : DateTime.now();
                break;
              case CalendarViewType.day:
                selectedDate = Get.isRegistered<DayController>(tag: 'day')
                    ? Get.find<DayController>(tag: 'day').selectedDate.value
                    : DateTime.now();
                break;
            }
            
            final result = await Get.toNamed(
              '/create-event',
              arguments: selectedDate,
            );
            
            // 如果创建成功，重新加载事件
            if (result == true) {
              controller.loadEvents();
              if (Get.isRegistered<WeekController>(tag: 'week')) {
                Get.find<WeekController>(tag: 'week').loadEvents();
              }
              if (Get.isRegistered<DayController>(tag: 'day')) {
                Get.find<DayController>(tag: 'day').loadEvents();
              }
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('新建事件'),
        ),
      );
    });
  }

  /// 构建当前视图
  Widget _buildCurrentView(BuildContext context) {
    switch (controller.currentViewType.value) {
      case CalendarViewType.month:
        return _buildMonthView(context);
      case CalendarViewType.week:
        return const WeekView();
      case CalendarViewType.day:
        return const DayView();
    }
  }
  
  /// 构建月视图
  Widget _buildMonthView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 日历组件
        ZenCalendarWidget(
          focusedDay: controller.focusedDate.value,
          selectedDay: controller.selectedDate.value,
          onDaySelected: (selectedDay, focusedDay) {
            controller.syncDateSelection(selectedDay);
          },
          onPageChanged: (focusedDay) {
            controller.focusedDate.value = focusedDay;
          },
          events: controller.events,
        ),
        
        const SizedBox(height: 24),
        
        // 日期标题
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatSelectedDate(controller.selectedDate.value),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (controller.selectedDateEvents.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.selectedDateEvents.length} 个事件',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 事件列表
        EventListWidget(
          events: controller.selectedDateEvents,
          onEventTap: (event) async {
            final result = await Get.toNamed('/event/${event.id}');
            
            // 如果删除或编辑了事件，重新加载
            if (result == true) {
              controller.loadEvents();
            }
          },
          onEventDelete: (event) {
            _showDeleteDialog(context, event);
          },
        ),
      ],
    );
  }

  /// 格式化选中日期
  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay.isAtSameMomentAs(today)) {
      return '今天';
    } else if (selectedDay.isAtSameMomentAs(
        today.add(const Duration(days: 1)))) {
      return '明天';
    } else if (selectedDay.isAtSameMomentAs(
        today.subtract(const Duration(days: 1)))) {
      return '昨天';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, event) {
    Get.dialog(
      AlertDialog(
        title: const Text('删除事件'),
        content: Text('确定要删除「${event.title}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteEvent(event.id);
            },
            child: Text(
              '删除',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
