import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'zen_colors.dart';

/// ZenCalendar 主题配置
/// 
/// 设计风格：Soft UI Evolution
/// 字体组合：Lora (标题) + Raleway (正文)
class AppTheme {
  // ==================== 浅色主题 ====================
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ZenColors.lightBackground,
    primaryColor: ZenColors.lightAccent,
    
    // 颜色方案
    colorScheme: ColorScheme.light(
      primary: ZenColors.lightAccent,
      secondary: ZenColors.lightAccentSecondary,
      surface: ZenColors.lightBackground,
      error: ZenColors.errorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: ZenColors.lightText,
      onError: Colors.white,
    ),
    
    // 文字主题
    textTheme: _buildTextTheme(ZenColors.lightText, ZenColors.lightTextSecondary),
    
    // AppBar 主题
    appBarTheme: _buildAppBarTheme(true),
    
    // 卡片主题
    cardTheme: _buildCardTheme(true),
    
    // 浮动按钮主题
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ZenColors.lightAccent,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // 输入框主题
    inputDecorationTheme: _buildInputDecorationTheme(true),
    
    // 图标主题
    iconTheme: IconThemeData(
      color: ZenColors.lightText,
      size: 24,
    ),
  );
  
  // ==================== 深色主题 ====================
  
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ZenColors.darkBackground,
    primaryColor: ZenColors.darkAccent,
    
    // 颜色方案
    colorScheme: ColorScheme.dark(
      primary: ZenColors.darkAccent,
      secondary: ZenColors.darkAccentSecondary,
      surface: ZenColors.darkBackground,
      error: ZenColors.errorColor,
      onPrimary: ZenColors.darkBackground,
      onSecondary: ZenColors.darkBackground,
      onSurface: ZenColors.darkText,
      onError: Colors.white,
    ),
    
    // 文字主题
    textTheme: _buildTextTheme(ZenColors.darkText, ZenColors.darkTextSecondary),
    
    // AppBar 主题
    appBarTheme: _buildAppBarTheme(false),
    
    // 卡片主题
    cardTheme: _buildCardTheme(false),
    
    // 浮动按钮主题
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ZenColors.darkAccent,
      foregroundColor: ZenColors.darkBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // 输入框主题
    inputDecorationTheme: _buildInputDecorationTheme(false),
    
    // 图标主题
    iconTheme: IconThemeData(
      color: ZenColors.darkText,
      size: 24,
    ),
  );
  
  // ==================== 私有方法 ====================
  
  /// 构建文字主题
  static TextTheme _buildTextTheme(Color textColor, Color secondaryColor) {
    return TextTheme(
      // 大标题 - Lora
      displayLarge: GoogleFonts.lora(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      
      // 标题 - Lora
      headlineLarge: GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineMedium: GoogleFonts.lora(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      headlineSmall: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      
      // 正文 - Raleway
      bodyLarge: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      bodySmall: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      
      // 标签 - Raleway
      labelLarge: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: GoogleFonts.raleway(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
  
  /// 构建 AppBar 主题
  static AppBarTheme _buildAppBarTheme(bool isLight) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: isLight ? ZenColors.lightText : ZenColors.darkText,
      titleTextStyle: GoogleFonts.lora(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: isLight ? ZenColors.lightText : ZenColors.darkText,
      ),
    );
  }
  
  /// 构建卡片主题
  static CardThemeData _buildCardTheme(bool isLight) {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isLight ? ZenColors.lightCardBackground : ZenColors.darkCardBackground,
    );
  }
  
  /// 构建输入框主题
  static InputDecorationTheme _buildInputDecorationTheme(bool isLight) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? ZenColors.lightCardBackground : ZenColors.darkCardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLight ? ZenColors.lightAccent : ZenColors.darkAccent,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: ZenColors.errorColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
    );
  }
}
