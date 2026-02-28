import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/services/export_service.dart';
import '../../../data/services/import_service.dart';
import '../../../data/services/backup_service.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../data/repositories/intention_repository.dart';
import '../../../services/haptic_service.dart';

/// Settings 控制器
class SettingsController extends GetxController {
  final LocalStorageProvider _storageProvider = Get.find<LocalStorageProvider>();
  final HapticService _hapticService = Get.find<HapticService>();
  final ExportService _exportService = ExportService();
  final ImportService _importService = ImportService();
  final BackupService _backupService = BackupService();
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final IntentionRepository _intentionRepository = Get.find<IntentionRepository>();
  
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
  
  /// 导出数据为 JSON
  Future<void> exportDataAsJson() async {
    try {
      _hapticService.light();
      
      // 获取所有数据
      final events = await _eventRepository.getAllEvents();
      final intentions = await _intentionRepository.getAllIntentions();
      
      // 导出为 JSON
      final jsonContent = await _exportService.exportToJson(events, intentions);
      final filename = _exportService.generateFilename('json');
      final file = await _exportService.saveToFile(jsonContent, filename);
      
      _hapticService.success();
      Get.snackbar(
        '导出成功',
        '文件已保存到：${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Error exporting JSON: $e');
      _hapticService.error();
      Get.snackbar(
        '导出失败',
        '无法导出数据：$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 导出数据为 CSV
  Future<void> exportDataAsCsv() async {
    try {
      _hapticService.light();
      
      // 获取所有数据
      final events = await _eventRepository.getAllEvents();
      final intentions = await _intentionRepository.getAllIntentions();
      
      // 导出为 CSV
      final csvContent = await _exportService.exportToCsv(events, intentions);
      final filename = _exportService.generateFilename('csv');
      final file = await _exportService.saveToFile(csvContent, filename);
      
      _hapticService.success();
      Get.snackbar(
        '导出成功',
        '文件已保存到：${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Error exporting CSV: $e');
      _hapticService.error();
      Get.snackbar(
        '导出失败',
        '无法导出数据：$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 导入数据
  Future<void> importData() async {
    try {
      _hapticService.light();
      
      // 选择文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv'],
      );
      
      if (result == null || result.files.isEmpty) {
        return;
      }
      
      final filePath = result.files.first.path;
      if (filePath == null) {
        Get.snackbar(
          '错误',
          '无法读取文件路径',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // 显示确认对话框
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('确认导入'),
          content: const Text('导入数据将与现有数据合并。建议先备份当前数据。\n\n是否继续？'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('导入'),
            ),
          ],
        ),
      );
      
      if (confirmed != true) return;
      
      // 创建备份
      await createBackup();
      
      // 导入数据
      final extension = filePath.split('.').last.toLowerCase();
      final importResult = extension == 'json'
          ? await _importService.importFromJson(filePath)
          : await _importService.importFromCsv(filePath);
      
      if (importResult.hasErrors) {
        _hapticService.error();
        Get.snackbar(
          '导入警告',
          '部分数据导入失败：\n${importResult.errors.take(3).join('\n')}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
        );
      }
      
      // 保存导入的数据
      for (final event in importResult.events) {
        await _eventRepository.createEvent(event);
      }
      for (final intention in importResult.intentions) {
        await _intentionRepository.createIntention(intention);
      }
      
      await loadDataStats();
      
      _hapticService.success();
      Get.snackbar(
        '导入成功',
        '已导入 ${importResult.events.length} 个事件和 ${importResult.intentions.length} 个意图',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('❌ Error importing data: $e');
      _hapticService.error();
      Get.snackbar(
        '导入失败',
        '无法导入数据：$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 创建备份
  Future<void> createBackup() async {
    try {
      _hapticService.light();
      
      final events = await _eventRepository.getAllEvents();
      final intentions = await _intentionRepository.getAllIntentions();
      
      final backupInfo = await _backupService.createBackup(events, intentions);
      
      _hapticService.success();
      Get.snackbar(
        '备份成功',
        '已创建备份：${backupInfo.formattedDate}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error creating backup: $e');
      _hapticService.error();
      Get.snackbar(
        '备份失败',
        '无法创建备份：$e',
        snackPosition: SnackPosition.BOTTOM,
      );
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
