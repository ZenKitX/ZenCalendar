import 'package:flutter/material.dart';

/// 日历视图类型
enum CalendarViewType {
  /// 月视图
  month,
  
  /// 周视图
  week,
  
  /// 日视图
  day,
}

/// 日历视图类型扩展
extension CalendarViewTypeExtension on CalendarViewType {
  /// 获取显示名称
  String get displayName {
    switch (this) {
      case CalendarViewType.month:
        return '月视图';
      case CalendarViewType.week:
        return '周视图';
      case CalendarViewType.day:
        return '日视图';
    }
  }
  
  /// 获取图标
  IconData get icon {
    switch (this) {
      case CalendarViewType.month:
        return Icons.calendar_month;
      case CalendarViewType.week:
        return Icons.view_week;
      case CalendarViewType.day:
        return Icons.view_day;
    }
  }
}