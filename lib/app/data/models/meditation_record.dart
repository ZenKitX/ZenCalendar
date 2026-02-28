import 'package:equatable/equatable.dart';

/// 冥想记录模型
class MeditationRecord extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String? notes;
  final DateTime createdAt;

  const MeditationRecord({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.notes,
    required this.createdAt,
  });

  /// 创建新的冥想记录
  factory MeditationRecord.create({
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
  }) {
    final duration = endTime.difference(startTime).inMinutes;
    
    return MeditationRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: startTime,
      endTime: endTime,
      durationMinutes: duration,
      notes: notes,
      createdAt: DateTime.now(),
    );
  }

  /// 从 JSON 创建
  factory MeditationRecord.fromJson(Map<String, dynamic> json) {
    return MeditationRecord(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: json['durationMinutes'] as int,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 复制并修改
  MeditationRecord copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? notes,
    DateTime? createdAt,
  }) {
    return MeditationRecord(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 格式化时长显示
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '$durationMinutes 分钟';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) {
        return '$hours 小时';
      }
      return '$hours 小时 $minutes 分钟';
    }
  }

  /// 格式化日期显示
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(startTime.year, startTime.month, startTime.day);

    if (recordDate.isAtSameMomentAs(today)) {
      return '今天';
    } else if (recordDate.isAtSameMomentAs(
        today.subtract(const Duration(days: 1)))) {
      return '昨天';
    } else {
      return '${startTime.month}月${startTime.day}日';
    }
  }

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        durationMinutes,
        notes,
        createdAt,
      ];
}
