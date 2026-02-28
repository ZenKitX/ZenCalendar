import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/week_controller.dart';
import '../controllers/calendar_controller.dart';
import 'widgets/week_calendar_widget.dart';
import 'widgets/event_list_widget.dart';

/// 周视图页面
class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeekController>(tag: 'week');
    
    return Obx(() {
      if (controller.isLoading.value && controller.events.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return SingleChildScrollView(
        child: Column(
          children: [
            // 周视图日历
            WeekCalendarWidget(
              controller: controller,
              onEventTap: (event) async {
                final result = await Get.toNamed('/event/${event.id}');
                
                // 如果删除或编辑了事件，重新加载
                if (result == true) {
                  controller.loadEvents();
                }
              },
            ),
            
            const SizedBox(height: 24),
            
            // 选中日期的事件详情
            _buildSelectedDateEvents(context, controller),
          ],
        ),
      );
    });
  }
  
  /// 构建选中日期的事件列表
  Widget _buildSelectedDateEvents(BuildContext context, WeekController controller) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
        maxHeight: 400,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatSelectedDate(controller.selectedDate.value),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
          ),
          
          // 分隔线
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          
          // 事件列表
          Flexible(
            child: controller.selectedDateEvents.isEmpty
              ? _buildEmptyState(context)
              : EventListWidget(
                  events: controller.selectedDateEvents,
                  onEventTap: (event) async {
                    final result = await Get.toNamed('/event/${event.id}');
                    
                    if (result == true) {
                      controller.loadEvents();
                    }
                  },
                  onEventDelete: (event) {
                    _showDeleteDialog(context, event, controller);
                  },
                ),
          ),
        ],
      ),
    );
  }
  
  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '这一天还没有事件',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '点击日期或使用浮动按钮创建新事件',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 格式化选中日期
  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay.isAtSameMomentAs(today)) {
      return '今天 ${date.month}月${date.day}日';
    } else if (selectedDay.isAtSameMomentAs(
        today.add(const Duration(days: 1)))) {
      return '明天 ${date.month}月${date.day}日';
    } else if (selectedDay.isAtSameMomentAs(
        today.subtract(const Duration(days: 1)))) {
      return '昨天 ${date.month}月${date.day}日';
    } else {
      final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      final weekday = weekdays[date.weekday - 1];
      return '$weekday ${date.month}月${date.day}日';
    }
  }
  
  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, event, WeekController controller) {
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
            onPressed: () async {
              Get.back();
              // 这里需要调用删除方法，暂时使用 CalendarController 的方法
              final calendarController = Get.find<CalendarController>();
              await calendarController.deleteEvent(event.id);
              controller.loadEvents();
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