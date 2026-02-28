import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'recurrence_rule.dart';

/// 事件数据模型
class EventModel extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final bool isAllDay;
  final List<DateTime> reminders;
  final String? categoryId; // 新增：分类 ID
  final List<String> tags; // 新增：标签列表
  final RecurrenceRule? recurrenceRule; // 新增：重复规则
  final String? originalEventId; // 新增：原始事件 ID（用于重复事件实例）
  final bool isRecurringInstance; // 新增：是否为重复事件实例
  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.isAllDay = false,
    this.reminders = const [],
    this.categoryId,
    this.tags = const [],
    this.recurrenceRule,
    this.originalEventId,
    this.isRecurringInstance = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 创建新事件
  factory EventModel.create({
    required String title,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    Color? color,
    bool isAllDay = false,
    List<DateTime>? reminders,
    String? categoryId,
    List<String>? tags,
    RecurrenceRule? recurrenceRule,
  }) {
    final now = DateTime.now();
    return EventModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      color: color ?? Colors.blue,
      isAllDay: isAllDay,
      reminders: reminders ?? [],
      categoryId: categoryId,
      tags: tags ?? [],
      recurrenceRule: recurrenceRule,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 创建重复事件实例
  factory EventModel.createRecurringInstance({
    required EventModel originalEvent,
    required DateTime instanceStartTime,
    required DateTime instanceEndTime,
  }) {
    final duration = originalEvent.endTime.difference(originalEvent.startTime);
    final adjustedEndTime = instanceEndTime.isAfter(instanceStartTime.add(duration))
        ? instanceEndTime
        : instanceStartTime.add(duration);

    return EventModel(
      id: const Uuid().v4(),
      title: originalEvent.title,
      description: originalEvent.description,
      startTime: instanceStartTime,
      endTime: adjustedEndTime,
      color: originalEvent.color,
      isAllDay: originalEvent.isAllDay,
      reminders: originalEvent.reminders,
      categoryId: originalEvent.categoryId,
      tags: originalEvent.tags,
      recurrenceRule: null, // 实例不包含重复规则
      originalEventId: originalEvent.id,
      isRecurringInstance: true,
      createdAt: originalEvent.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 复制并修改
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    bool? isAllDay,
    List<DateTime>? reminders,
    String? categoryId,
    List<String>? tags,
    RecurrenceRule? recurrenceRule,
    String? originalEventId,
    bool? isRecurringInstance,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      isAllDay: isAllDay ?? this.isAllDay,
      reminders: reminders ?? this.reminders,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      originalEventId: originalEventId ?? this.originalEventId,
      isRecurringInstance: isRecurringInstance ?? this.isRecurringInstance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'color': color.value,
      'isAllDay': isAllDay,
      'reminders': reminders.map((r) => r.toIso8601String()).toList(),
      'categoryId': categoryId,
      'tags': tags,
      'recurrenceRule': recurrenceRule?.toJson(),
      'originalEventId': originalEventId,
      'isRecurringInstance': isRecurringInstance,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 从 JSON 创建
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      color: Color(json['color'] as int),
      isAllDay: json['isAllDay'] as bool? ?? false,
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((r) => DateTime.parse(r as String))
              .toList() ??
          [],
      categoryId: json['categoryId'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      recurrenceRule: json['recurrenceRule'] != null
          ? RecurrenceRule.fromJson(json['recurrenceRule'] as Map<String, dynamic>)
          : null,
      originalEventId: json['originalEventId'] as String?,
      isRecurringInstance: json['isRecurringInstance'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// 判断事件是否在指定日期
  bool isOnDate(DateTime date) {
    final eventDate = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
    );
    final targetDate = DateTime(date.year, date.month, date.day);
    return eventDate.isAtSameMomentAs(targetDate);
  }

  /// 判断事件是否跨天
  bool get isMultiDay {
    final startDate = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
    );
    final endDate = DateTime(
      endTime.year,
      endTime.month,
      endTime.day,
    );
    return !startDate.isAtSameMomentAs(endDate);
  }

  /// 检查是否有重复规则
  bool get hasRecurrence => recurrenceRule?.hasRecurrence ?? false;

  /// 检查是否为重复事件的主事件
  bool get isRecurringMaster => hasRecurrence && !isRecurringInstance;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        color,
        isAllDay,
        reminders,
        categoryId,
        tags,
        recurrenceRule,
        originalEventId,
        isRecurringInstance,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, startTime: $startTime)';
  }
}
