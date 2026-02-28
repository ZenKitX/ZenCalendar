import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// 每日意图数据模型
class IntentionModel extends Equatable {
  final String id;
  final String text;
  final DateTime date;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;

  const IntentionModel({
    required this.id,
    required this.text,
    required this.date,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });

  /// 创建新意图
  factory IntentionModel.create({
    required String text,
    required DateTime date,
  }) {
    return IntentionModel(
      id: const Uuid().v4(),
      text: text,
      date: DateTime(date.year, date.month, date.day), // 只保留日期部分
      createdAt: DateTime.now(),
    );
  }

  /// 复制并修改
  IntentionModel copyWith({
    String? id,
    String? text,
    DateTime? date,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return IntentionModel(
      id: id ?? this.id,
      text: text ?? this.text,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  /// 标记为完成
  IntentionModel markAsCompleted() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );
  }

  /// 标记为未完成
  IntentionModel markAsIncomplete() {
    return copyWith(
      isCompleted: false,
      completedAt: null,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// 从 JSON 创建
  factory IntentionModel.fromJson(Map<String, dynamic> json) {
    return IntentionModel(
      id: json['id'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  /// 判断是否是今天的意图
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// 判断是否过期
  bool get isExpired {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  @override
  List<Object?> get props => [
        id,
        text,
        date,
        isCompleted,
        createdAt,
        completedAt,
      ];

  @override
  String toString() {
    return 'IntentionModel(id: $id, text: $text, date: $date, isCompleted: $isCompleted)';
  }
}
