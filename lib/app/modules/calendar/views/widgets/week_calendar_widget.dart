import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/week_controller.dart';
import '../../../../data/models/event_model.dart';

/// 周视图日历组件
class WeekCalendarWidget extends StatelessWidget {
  final WeekController controller;
  final Function(EventModel)? onEventTap;
  
  const WeekCalendarWidget({
    super.key,
    required this.controller,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // 周导航栏
          _buildWeekNavigation(context),
          
          const SizedBox(height: 16),
          
          // 周视图内容
          _buildWeekView(context),
        ],
      );
    });
  }
  
  /// 构建周导航栏
  Widget _buildWeekNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: controller.previousWeek,
            icon: const Icon(Icons.chevron_left),
            tooltip: '上一周',
          ),
          
          Expanded(
            child: Text(
              controller.weekTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          IconButton(
            onPressed: controller.nextWeek,
            icon: const Icon(Icons.chevron_right),
            tooltip: '下一周',
          ),
        ],
      ),
    );
  }
  
  /// 构建周视图
  Widget _buildWeekView(BuildContext context) {
    final weekDates = controller.currentWeekDates;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // 星期标题行
          _buildWeekdayHeaders(context, weekDates),
          
          // 分隔线
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          
          // 事件内容区域
          _buildWeekContent(context, weekDates),
        ],
      ),
    );
  }
  
  /// 构建星期标题行
  Widget _buildWeekdayHeaders(BuildContext context, List<DateTime> weekDates) {
    final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: weekDates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          final isToday = controller.isToday(date);
          final isSelected = controller.isSelectedDate(date);
          
          return Expanded(
            child: Column(
              children: [
                Text(
                  weekdays[index],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                
                const SizedBox(height: 4),
                
                GestureDetector(
                  onTap: () => controller.selectDate(date),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : isToday
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                        ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          )
                        : null,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : isToday
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  /// 构建周内容区域
  Widget _buildWeekContent(BuildContext context, List<DateTime> weekDates) {
    return Container(
      height: 200, // 固定高度，可以根据需要调整
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: weekDates.map((date) {
          final dayEvents = controller.getEventsForDate(date);
          final isSelected = controller.isSelectedDate(date);
          
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectDate(date),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 事件列表
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(4),
                        itemCount: dayEvents.length,
                        itemBuilder: (context, index) {
                          final event = dayEvents[index];
                          return _buildEventCard(context, event);
                        },
                      ),
                    ),
                    
                    // 添加事件按钮（当选中时显示）
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: GestureDetector(
                          onTap: () => _createEventForDate(date),
                          child: Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  /// 构建事件卡片
  Widget _buildEventCard(BuildContext context, EventModel event) {
    return GestureDetector(
      onTap: () => onEventTap?.call(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          event.title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
  
  /// 为指定日期创建事件
  void _createEventForDate(DateTime date) async {
    final result = await Get.toNamed(
      '/create-event',
      arguments: date,
    );
    
    if (result == true) {
      controller.loadEvents();
    }
  }
}