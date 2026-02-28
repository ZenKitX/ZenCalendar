import 'package:flutter/material.dart';

/// ZenCalendar 禅意配色系统
/// 
/// 设计理念：
/// - 浅色主题：薰衣草庭院（温暖、宁静）
/// - 深色主题：夜间竹林（深邃、平静）
class ZenColors {
  // ==================== 浅色主题 - 薰衣草庭院 ====================
  
  /// 背景色 - 薰衣草白
  static const Color lightBackground = Color(0xFFF0EBF4);
  
  /// 卡片背景 - 纯白
  static const Color lightCardBackground = Color(0xFFFFFBFF);
  
  /// 高光阴影 - 纯白
  static const Color lightShadowLight = Color(0xFFFFFBFF);
  
  /// 深色阴影 - 薰衣草灰
  static const Color lightShadowDark = Color(0xFFD4CFD8);
  
  /// 主文字 - 深紫墨色
  static const Color lightText = Color(0xFF2D2A32);
  
  /// 次要文字 - 灰紫色
  static const Color lightTextSecondary = Color(0xFF6B6570);
  
  /// 强调色 - 薰衣草紫
  static const Color lightAccent = Color(0xFF9B86BD);
  
  /// 次要强调色 - 浅薰衣草紫
  static const Color lightAccentSecondary = Color(0xFFB8A5D6);
  
  // ==================== 深色主题 - 夜间竹林 ====================
  
  /// 背景色 - 深竹绿灰
  static const Color darkBackground = Color(0xFF2B2D2A);
  
  /// 卡片背景 - 浅竹绿灰
  static const Color darkCardBackground = Color(0xFF3A3D38);
  
  /// 高光阴影 - 浅竹绿灰
  static const Color darkShadowLight = Color(0xFF3A3D38);
  
  /// 深色阴影 - 深夜色
  static const Color darkShadowDark = Color(0xFF1C1E1B);
  
  /// 主文字 - 月光色
  static const Color darkText = Color(0xFFE8E4DC);
  
  /// 次要文字 - 雾色
  static const Color darkTextSecondary = Color(0xFFA8A49C);
  
  /// 强调色 - 浅竹绿
  static const Color darkAccent = Color(0xFF8FA896);
  
  /// 次要强调色 - 竹绿
  static const Color darkAccentSecondary = Color(0xFFA5BDB0);
  
  // ==================== 健康绿（保留原有） ====================
  
  /// 健康绿 - 主色
  static const Color healthGreen = Color(0xFF7C9885);
  
  /// 健康绿 - 浅色
  static const Color healthGreenLight = Color(0xFF9BB5A3);
  
  // ==================== 功能色 ====================
  
  /// 错误色 - 柔和红
  static const Color errorColor = Color(0xFFD97979);
  
  /// 警告色 - 柔和橙
  static const Color warningColor = Color(0xFFE8B86D);
  
  /// 成功色 - 健康绿
  static const Color successColor = Color(0xFF7C9885);
  
  /// 信息色 - 柔和蓝
  static const Color infoColor = Color(0xFF7B9FD9);
}
