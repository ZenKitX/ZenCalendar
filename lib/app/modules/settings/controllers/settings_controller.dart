import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../services/haptic_service.dart';

/// Settings 控制器
class SettingsController extends GetxController {
  final LocalStorageProvider _storageProvider = Get.find<LocalStorageProvider>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 主题模式
  final themeMode = ThemeMode.system.obs;
  
  // 通知设置
  final notificationsEnabled = true.obs;
  final eventReminders = true.obs;
  final intentionReminders = true.obs;
  
  // 数据统计
  final totalEvents = 0.obs;
  final totalIntentions = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('SettingsController initialized');
    loadSettings();
    loadDataStats();
  }
  
  /// 加载设置
  Future<void> loadSettings() async {
    try {
      final settings = await _storageProvider.getSettings();
      
      // 加载主题设置
      final themeModeStr = settings['themeMode'] as String?;
      if (themeModeStr != null) {
        themeMode.value = _parseThemeMode(themeModeStr);
      }
      
      // 加载通知设置
      notificationsEnabled.value = settings['notificationsEnabled'] as bool? ?? true;
      eventReminders.value = settings['eventReminders'] as bool? ?? true;
      intentionReminders.value = settings['intentionReminders'] as bool? ?? true;
      
      print('✅ Settings loaded');
    } catch (e) {
      print('❌ Error loading settings: $e');
    }
  }
  
  /// 保存设置
  Future<void> saveSettings() async {
    try {
      await _storageProvider.saveSetting('themeMode', themeMode.value.name);
      await _storageProvider.saveSetting('notificationsEnabled', notificationsEnabled.value);
      await _storageProvider.saveSetting('eventReminders', eventReminders.value);
      await _storageProvider.saveSetting('intentionReminders', intentionReminders.value);
      
      print('✅ Settings saved');
    } catch (e) {
      print('❌ Error saving settings: $e');
    }
  }
  
  /// 加载数据统计
  Future<void> loadDataStats() async {
    try {
      final events = await _storageProvider.getEvents();
      final intentions = await _storageProvider.getIntentions();
      
      totalEvents.value = events.length;
      totalIntentions.value = intentions.length;
    } catch (e) {
      print('❌ Error loading data stats: $e');
    }
  }
  
  /// 切换主题模式
  Future<void> changeThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await saveSettings();
    _hapticService.selection();
  }
  
  /// 切换通知
  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await saveSettings();
    _hapticService.light();
  }
  
  /// 切换事件提醒
  Future<void> toggleEventReminders(bool value) async {
    eventReminders.value = value;
    await saveSettings();
    _hapticService.light();
  }
  
  /// 切换意图提醒
  Future<void> toggleIntentionReminders(bool value) async {
    intentionReminders.value = value;
    await saveSettings();
    _hapticService.light();
  }
  
  /// 清除所有数据
  Future<void> clearAllData() async {
    try {
      await _storageProvider.clearEvents();
      await _storageProvider.clearIntentions();
      await loadDataStats();
      
      _hapticService.success();
      Get.snackbar(
        '成功',
        '所有数据已清除',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error clearing data: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '清除数据失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 导出数据
  Future<void> exportData() async {
    try {
      // TODO: 实现数据导出功能
      _hapticService.success();
      Get.snackbar(
        '提示',
        '数据导出功能即将推出',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error exporting data: $e');
      _hapticService.error();
    }
  }
  
  /// 导入数据
  Future<void> importData() async {
    try {
      // TODO: 实现数据导入功能
      _hapticService.success();
      Get.snackbar(
        '提示',
        '数据导入功能即将推出',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('❌ Error importing data: $e');
      _hapticService.error();
    }
  }
  
  /// 解析主题模式
  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
