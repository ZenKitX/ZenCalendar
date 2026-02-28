import 'package:equatable/equatable.dart';

/// 重复类型
enum RecurrenceType {
  /// 不重复
  none,
  
  /// 每天
  daily,
  
  /// 每周
  weekly,
  
  /// 每月
  monthly,
  
  /// 每年
  yearly,
}

/// 重复结束类型
enum RecurrenceEndType {
  /// 永不结束
  never,
  
  /// 指定日期结束
  date,
  
  /// 指定次数结束
  count,
}

/// 重复规则模型
class RecurrenceRule extends Equatable {
  final RecurrenceType type;
  final int interval; // 间隔（每 N 天/周/月/年）
  final RecurrenceEndType endType;
  final DateTime? endDate; // 结束日期（当 endType 为 date 时）
  final int? count; // 重复次数（当 endType 为 count 时）
  final List<int> weekdays; // 星期几重复（1-7，周一到周日）
  final List<DateTime> exceptions; // 例外日期列表

  const RecurrenceRule({
    required this.type,
    this.interval = 1,
    this.endType = RecurrenceEndType.never,
    this.endDate,
    this.count,
    this.weekdays = const [],
    this.exceptions = const [],
  });

  /// 创建无重复规则
  factory RecurrenceRule.none() {
    return const RecurrenceRule(type: RecurrenceType.none);
  }

  /// 创建每天重复
  factory RecurrenceRule.daily({
    int interval = 1,
    RecurrenceEndType endType = RecurrenceEndType.never,
    DateTime? endDate,
    int? count,
  }) {
    return RecurrenceRule(
      type: RecurrenceType.daily,
      interval: interval,
      endType: endType,
      endDate: endDate,
      count: count,
    );
  }

  /// 创建每周重复
  factory RecurrenceRule.weekly({
    int interval = 1,
    List<int> weekdays = const [],
    RecurrenceEndType endType = RecurrenceEndType.never,
    DateTime? endDate,
    int? count,
  }) {
    return RecurrenceRule(
      type: RecurrenceType.weekly,
      interval: interval,
      weekdays: weekdays,
      endType: endType,
      endDate: endDate,
      count: count,
    );
  }

  /// 创建每月重复
  factory RecurrenceRule.monthly({
    int interval = 1,
    RecurrenceEndType endType = RecurrenceEndType.never,
    DateTime? endDate,
    int? count,
  }) {
    return RecurrenceRule(
      type: RecurrenceType.monthly,
      interval: interval,
      endType: endType,
      endDate: endDate,
      count: count,
    );
  }

  /// 创建每年重复
  factory RecurrenceRule.yearly({
    int interval = 1,
    RecurrenceEndType endType = RecurrenceEndType.never,
    DateTime? endDate,
    int? count,
  }) {
    return RecurrenceRule(
      type: RecurrenceType.yearly,
      interval: interval,
      endType: endType,
      endDate: endDate,
      count: count,
    );
  }

  /// 复制并修改
  RecurrenceRule copyWith({
    RecurrenceType? type,
    int? interval,
    RecurrenceEndType? endType,
    DateTime? endDate,
    int? count,
    List<int>? weekdays,
    List<DateTime>? exceptions,
  }) {
    return RecurrenceRule(
      type: type ?? this.type,
      interval: interval ?? this.interval,
      endType: endType ?? this.endType,
      endDate: endDate ?? this.endDate,
      count: count ?? this.count,
      weekdays: weekdays ?? this.weekdays,
      exceptions: exceptions ?? this.exceptions,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'interval': interval,
      'endType': endType.name,
      'endDate': endDate?.toIso8601String(),
      'count': count,
      'weekdays': weekdays,
      'exceptions': exceptions.map((e) => e.toIso8601String()).toList(),
    };
  }

  /// 从 JSON 创建
  factory RecurrenceRule.fromJson(Map<String, dynamic> json) {
    return RecurrenceRule(
      type: RecurrenceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RecurrenceType.none,
      ),
      interval: json['interval'] as int? ?? 1,
      endType: RecurrenceEndType.values.firstWhere(
        (e) => e.name == json['endType'],
        orElse: () => RecurrenceEndType.never,
      ),
      endDate: json['endDate'] != null 
        ? DateTime.parse(json['endDate'] as String)
        : null,
      count: json['count'] as int?,
      weekdays: (json['weekdays'] as List<dynamic>?)?.cast<int>() ?? [],
      exceptions: (json['exceptions'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList() ?? [],
    );
  }

  /// 检查是否有重复
  bool get hasRecurrence => type != RecurrenceType.none;

  /// 获取重复描述
  String get description {
    if (!hasRecurrence) return '不重复';

    String desc = '';
    
    switch (type) {
      case RecurrenceType.daily:
        desc = interval == 1 ? '每天' : '每 $interval 天';
        break;
      case RecurrenceType.weekly:
        if (interval == 1) {
          if (weekdays.isEmpty) {
            desc = '每周';
          } else {
            final weekdayNames = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
            final selectedDays = weekdays.map((w) => weekdayNames[w - 1]).join('、');
            desc = '每周 $selectedDays';
          }
        } else {
          desc = '每 $interval 周';
        }
        break;
      case RecurrenceType.monthly:
        desc = interval == 1 ? '每月' : '每 $interval 个月';
        break;
      case RecurrenceType.yearly:
        desc = interval == 1 ? '每年' : '每 $interval 年';
        break;
      case RecurrenceType.none:
        return '不重复';
    }

    // 添加结束条件
    switch (endType) {
      case RecurrenceEndType.never:
        break;
      case RecurrenceEndType.date:
        if (endDate != null) {
          desc += '，直到 ${endDate!.month}月${endDate!.day}日';
        }
        break;
      case RecurrenceEndType.count:
        if (count != null) {
          desc += '，共 $count 次';
        }
        break;
    }

    return desc;
  }

  @override
  List<Object?> get props => [
        type,
        interval,
        endType,
        endDate,
        count,
        weekdays,
        exceptions,
      ];

  @override
  String toString() {
    return 'RecurrenceRule(type: $type, interval: $interval, description: $description)';
  }
}

/// 重复类型扩展
extension RecurrenceTypeExtension on RecurrenceType {
  /// 获取显示名称
  String get displayName {
    switch (this) {
      case RecurrenceType.none:
        return '不重复';
      case RecurrenceType.daily:
        return '每天';
      case RecurrenceType.weekly:
        return '每周';
      case RecurrenceType.monthly:
        return '每月';
      case RecurrenceType.yearly:
        return '每年';
    }
  }
}