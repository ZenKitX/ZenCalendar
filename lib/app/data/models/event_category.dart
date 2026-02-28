import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// 事件分类模型
class EventCategory extends Equatable {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final bool isDefault;

  const EventCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.isDefault = false,
  });

  /// 预定义分类
  static List<EventCategory> get defaultCategories => [
        const EventCategory(
          id: 'work',
          name: '工作',
          color: Color(0xFF3B82F6), // 蓝色
          icon: Icons.work_outline,
          isDefault: true,
        ),
        const EventCategory(
          id: 'life',
          name: '生活',
          color: Color(0xFF10B981), // 绿色
          icon: Icons.home_outlined,
          isDefault: true,
        ),
        const EventCategory(
          id: 'study',
          name: '学习',
          color: Color(0xFF8B5CF6), // 紫色
          icon: Icons.school_outlined,
          isDefault: true,
        ),
        const EventCategory(
          id: 'health',
          name: '健康',
          color: Color(0xFFEF4444), // 红色
          icon: Icons.favorite_outline,
          isDefault: true,
        ),
        const EventCategory(
          id: 'social',
          name: '社交',
          color: Color(0xFFF97316), // 橙色
          icon: Icons.people_outline,
          isDefault: true,
        ),
        const EventCategory(
          id: 'entertainment',
          name: '娱乐',
          color: Color(0xFFEC4899), // 粉色
          icon: Icons.celebration_outlined,
          isDefault: true,
        ),
        const EventCategory(
          id: 'other',
          name: '其他',
          color: Color(0xFF6B7280), // 灰色
          icon: Icons.more_horiz,
          isDefault: true,
        ),
      ];

  /// 从 JSON 创建
  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['color'] as int),
      icon: IconData(
        json['icon'] as int,
        fontFamily: 'MaterialIcons',
      ),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'isDefault': isDefault,
    };
  }

  /// 复制并修改
  EventCategory copyWith({
    String? id,
    String? name,
    Color? color,
    IconData? icon,
    bool? isDefault,
  }) {
    return EventCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, name, color, icon, isDefault];
}
