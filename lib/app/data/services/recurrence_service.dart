import '../models/event_model.dart';
import '../models/recurrence_rule.dart';

/// 重复事件服务
class RecurrenceService {
  /// 生成重复事件实例
  /// 
  /// [masterEvent] 主事件
  /// [startDate] 开始日期
  /// [endDate] 结束日期
  /// [maxInstances] 最大实例数（防止无限生成）
  List<EventModel> generateRecurringInstances(
    EventModel masterEvent,
    DateTime startDate,
    DateTime endDate, {
    int maxInstances = 1000,
  }) {
    if (!masterEvent.hasRecurrence) {
      return [];
    }

    final rule = masterEvent.recurrenceRule!;
    final instances = <EventModel>[];
    
    DateTime currentDate = _getNextOccurrence(masterEvent.startTime, rule, startDate);
    int instanceCount = 0;

    while (currentDate.isBefore(endDate) && 
           instanceCount < maxInstances &&
           _shouldContinueGeneration(rule, currentDate, instanceCount)) {
      
      // 检查是否在例外日期列表中
      if (!_isExceptionDate(currentDate, rule.exceptions)) {
        final instanceStartTime = _adjustTimeToDate(masterEvent.startTime, currentDate);
        final instanceEndTime = _adjustTimeToDate(masterEvent.endTime, currentDate);
        
        final instance = EventModel.createRecurringInstance(
          originalEvent: masterEvent,
          instanceStartTime: instanceStartTime,
          instanceEndTime: instanceEndTime,
        );
        
        instances.add(instance);
        instanceCount++;
      }

      currentDate = _getNextOccurrence(currentDate, rule, currentDate.add(const Duration(days: 1)));
    }

    return instances;
  }

  /// 获取下一个重复事件的日期
  DateTime _getNextOccurrence(DateTime baseDate, RecurrenceRule rule, DateTime fromDate) {
    switch (rule.type) {
      case RecurrenceType.daily:
        return _getNextDailyOccurrence(baseDate, rule, fromDate);
      case RecurrenceType.weekly:
        return _getNextWeeklyOccurrence(baseDate, rule, fromDate);
      case RecurrenceType.monthly:
        return _getNextMonthlyOccurrence(baseDate, rule, fromDate);
      case RecurrenceType.yearly:
        return _getNextYearlyOccurrence(baseDate, rule, fromDate);
      case RecurrenceType.none:
        return fromDate.add(const Duration(days: 365 * 10)); // 返回一个很远的日期
    }
  }

  /// 获取下一个每日重复事件
  DateTime _getNextDailyOccurrence(DateTime baseDate, RecurrenceRule rule, DateTime fromDate) {
    if (fromDate.isBefore(baseDate) || fromDate.isAtSameMomentAs(baseDate)) {
      return baseDate;
    }

    final daysDiff = fromDate.difference(baseDate).inDays;
    final nextInterval = ((daysDiff / rule.interval).ceil()) * rule.interval;
    
    return baseDate.add(Duration(days: nextInterval));
  }

  /// 获取下一个每周重复事件
  DateTime _getNextWeeklyOccurrence(DateTime baseDate, RecurrenceRule rule, DateTime fromDate) {
    if (fromDate.isBefore(baseDate) || fromDate.isAtSameMomentAs(baseDate)) {
      return baseDate;
    }

    // 如果没有指定星期几，使用原事件的星期几
    final targetWeekdays = rule.weekdays.isEmpty ? [baseDate.weekday] : rule.weekdays;
    
    DateTime candidate = fromDate;
    
    while (true) {
      // 检查当前日期是否在目标星期几中
      if (targetWeekdays.contains(candidate.weekday)) {
        // 检查是否符合间隔要求
        final weeksDiff = candidate.difference(baseDate).inDays ~/ 7;
        if (weeksDiff % rule.interval == 0) {
          return candidate;
        }
      }
      
      candidate = candidate.add(const Duration(days: 1));
      
      // 防止无限循环
      if (candidate.difference(fromDate).inDays > 365) {
        break;
      }
    }
    
    return candidate;
  }

  /// 获取下一个每月重复事件
  DateTime _getNextMonthlyOccurrence(DateTime baseDate, RecurrenceRule rule, DateTime fromDate) {
    if (fromDate.isBefore(baseDate) || fromDate.isAtSameMomentAs(baseDate)) {
      return baseDate;
    }

    DateTime candidate = DateTime(fromDate.year, fromDate.month, baseDate.day);
    
    // 如果当前月的日期已经过了，移到下个月
    if (candidate.isBefore(fromDate)) {
      candidate = DateTime(candidate.year, candidate.month + 1, baseDate.day);
    }

    // 确保符合间隔要求
    while (true) {
      final monthsDiff = (candidate.year - baseDate.year) * 12 + (candidate.month - baseDate.month);
      if (monthsDiff % rule.interval == 0) {
        return candidate;
      }
      
      candidate = DateTime(candidate.year, candidate.month + 1, baseDate.day);
      
      // 防止无限循环
      if (candidate.year > baseDate.year + 10) {
        break;
      }
    }
    
    return candidate;
  }

  /// 获取下一个每年重复事件
  DateTime _getNextYearlyOccurrence(DateTime baseDate, RecurrenceRule rule, DateTime fromDate) {
    if (fromDate.isBefore(baseDate) || fromDate.isAtSameMomentAs(baseDate)) {
      return baseDate;
    }

    DateTime candidate = DateTime(fromDate.year, baseDate.month, baseDate.day);
    
    // 如果当前年的日期已经过了，移到下一年
    if (candidate.isBefore(fromDate)) {
      candidate = DateTime(candidate.year + 1, baseDate.month, baseDate.day);
    }

    // 确保符合间隔要求
    while (true) {
      final yearsDiff = candidate.year - baseDate.year;
      if (yearsDiff % rule.interval == 0) {
        return candidate;
      }
      
      candidate = DateTime(candidate.year + 1, baseDate.month, baseDate.day);
      
      // 防止无限循环
      if (candidate.year > baseDate.year + 100) {
        break;
      }
    }
    
    return candidate;
  }

  /// 检查是否应该继续生成重复事件
  bool _shouldContinueGeneration(RecurrenceRule rule, DateTime currentDate, int instanceCount) {
    switch (rule.endType) {
      case RecurrenceEndType.never:
        return true;
      case RecurrenceEndType.date:
        return rule.endDate == null || currentDate.isBefore(rule.endDate!);
      case RecurrenceEndType.count:
        return rule.count == null || instanceCount < rule.count!;
    }
  }

  /// 检查日期是否在例外列表中
  bool _isExceptionDate(DateTime date, List<DateTime> exceptions) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    return exceptions.any((exception) {
      final exceptionDateOnly = DateTime(exception.year, exception.month, exception.day);
      return dateOnly.isAtSameMomentAs(exceptionDateOnly);
    });
  }

  /// 将时间调整到指定日期
  DateTime _adjustTimeToDate(DateTime originalDateTime, DateTime targetDate) {
    return DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      originalDateTime.hour,
      originalDateTime.minute,
      originalDateTime.second,
      originalDateTime.millisecond,
    );
  }

  /// 添加例外日期
  RecurrenceRule addException(RecurrenceRule rule, DateTime exceptionDate) {
    final exceptions = List<DateTime>.from(rule.exceptions);
    final dateOnly = DateTime(exceptionDate.year, exceptionDate.month, exceptionDate.day);
    
    if (!exceptions.any((e) => 
        DateTime(e.year, e.month, e.day).isAtSameMomentAs(dateOnly))) {
      exceptions.add(dateOnly);
    }
    
    return rule.copyWith(exceptions: exceptions);
  }

  /// 移除例外日期
  RecurrenceRule removeException(RecurrenceRule rule, DateTime exceptionDate) {
    final exceptions = List<DateTime>.from(rule.exceptions);
    final dateOnly = DateTime(exceptionDate.year, exceptionDate.month, exceptionDate.day);
    
    exceptions.removeWhere((e) => 
        DateTime(e.year, e.month, e.day).isAtSameMomentAs(dateOnly));
    
    return rule.copyWith(exceptions: exceptions);
  }

  /// 获取重复事件的下 N 个实例
  List<EventModel> getNextInstances(EventModel masterEvent, int count) {
    if (!masterEvent.hasRecurrence) {
      return [];
    }

    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 365 * 2)); // 查找未来2年内的实例
    
    return generateRecurringInstances(
      masterEvent,
      now,
      endDate,
      maxInstances: count,
    );
  }

  /// 检查事件是否在指定日期范围内有重复实例
  bool hasInstancesInRange(EventModel masterEvent, DateTime startDate, DateTime endDate) {
    if (!masterEvent.hasRecurrence) {
      return false;
    }

    final instances = generateRecurringInstances(
      masterEvent,
      startDate,
      endDate,
      maxInstances: 1, // 只需要检查是否有实例，不需要生成所有
    );

    return instances.isNotEmpty;
  }
}