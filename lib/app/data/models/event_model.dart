import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      createdAt: now,
      updatedAt: now,
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
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, startTime: $startTime)';
  }
}
