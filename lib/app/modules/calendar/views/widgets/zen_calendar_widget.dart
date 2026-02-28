import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../config/theme/zen_colors.dart';
import '../../../../data/models/event_model.dart';

/// 禅意日历组件
class ZenCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final List<EventModel> events;

  const ZenCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar<EventModel>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          selectedDayPredicate: (day) => isSameDay(selectedDay, day),
          onDaySelected: onDaySelected,
          onPageChanged: onPageChanged,
          eventLoader: _getEventsForDay,
          
          // 日历格式
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          
          // 样式配置
          calendarStyle: CalendarStyle(
            // 今天
            todayDecoration: BoxDecoration(
              color: isDark
                  ? ZenColors.darkAccent.withOpacity(0.3)
                  : ZenColors.lightAccent.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(
              color: isDark ? ZenColors.darkText : ZenColors.lightText,
              fontWeight: FontWeight.bold,
            ),
            
            // 选中日期
            selectedDecoration: BoxDecoration(
              color: isDark ? ZenColors.darkAccent : ZenColors.lightAccent,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            
            // 标记样式
            markerDecoration: BoxDecoration(
              color: isDark ? ZenColors.healthGreen : ZenColors.healthGreenLight,
              shape: BoxShape.circle,
            ),
            markerSize: 6,
            markersMaxCount: 3,
            
            // 周末
            weekendTextStyle: TextStyle(
              color: isDark
                  ? ZenColors.darkAccent
                  : ZenColors.lightAccent,
            ),
            
            // 外部日期（其他月份）
            outsideDaysVisible: false,
          ),
          
          // 头部样式
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: isDark ? ZenColors.darkText : ZenColors.lightText,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: isDark ? ZenColors.darkText : ZenColors.lightText,
            ),
          ),
          
          // 星期标题样式
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: isDark
                  ? ZenColors.darkTextSecondary
                  : ZenColors.lightTextSecondary,
            ),
            weekendStyle: TextStyle(
              color: isDark
                  ? ZenColors.darkAccent.withOpacity(0.7)
                  : ZenColors.lightAccent.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  /// 获取指定日期的事件
  List<EventModel> _getEventsForDay(DateTime day) {
    return events.where((event) => event.isOnDate(day)).toList();
  }
}
