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
  
  // 高级设置 (Phase 8.6)
  final locale = const Locale('zh', 'CN').obs;  // 语言设置
  final fontSize = 1.0.obs;  // 字体大小倍数 (0.8 - 1.5)
  final animationSpeed = 1.0.obs;  // 动画速度倍数 (0.5 - 2.0)
  final Rx<Color> primaryColor = const Color(0xFF2196F3).obs;  // 主题主色调
  final defaultView = 'calendar'.obs;  // 首页视图 (calendar/intention)
  final autoBackup = false.obs;  // 自动备份
  
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
      
      // 加载高级设置 (Phase 8.6)
      final localeStr = settings['locale'] as String?;
      if (localeStr != null) {
        final parts = localeStr.split('_');
        if (parts.length == 2) {
          locale.value = Locale(parts[0], parts[1]);
        }
      }
      
      fontSize.value = settings['fontSize'] as double? ?? 1.0;
      animationSpeed.value = settings['animationSpeed'] as double? ?? 1.0;
      
      final colorValue = settings['primaryColor'] as int?;
      if (colorValue != null) {
        primaryColor.value = Color(colorValue);
      }
      
      defaultView.value = settings['defaultView'] as String? ?? 'calendar';
      autoBackup.value = settings['autoBackup'] as bool? ?? false;
      
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
      
      // 保存高级设置 (Phase 8.6)
      await _storageProvider.saveSetting('locale', '${locale.value.languageCode}_${locale.value.countryCode}');
      await _storageProvider.saveSetting('fontSize', fontSize.value);
      await _storageProvider.saveSetting('animationSpeed', animationSpeed.value);
      await _storageProvider.saveSetting('primaryColor', primaryColor.value.value);
      await _storageProvider.saveSetting('defaultView', defaultView.value);
      await _storageProvider.saveSetting('autoBackup', autoBackup.value);
      
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
  
  // ========== Phase 8.6 高级设置方法 ==========
  
  /// 切换语言
  Future<void> changeLocale(Locale newLocale) async {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    await saveSettings();
    _hapticService.selection();
    
    Get.snackbar(
      '语言已更改',
      newLocale.languageCode == 'zh' ? '已切换到中文' : 'Switched to English',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  /// 调整字体大小
  Future<void> changeFontSize(double size) async {
    fontSize.value = size.clamp(0.8, 1.5);
    await saveSettings();
    _hapticService.light();
  }
  
  /// 调整动画速度
  Future<void> changeAnimationSpeed(double speed) async {
    animationSpeed.value = speed.clamp(0.5, 2.0);
    await saveSettings();
    _hapticService.light();
  }
  
  /// 更改主题颜色
  Future<void> changePrimaryColor(Color color) async {
    primaryColor.value = color;
    await saveSettings();
    _hapticService.selection();
    
    Get.snackbar(
      '主题颜色已更改',
      '重启应用后生效',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  /// 切换默认视图
  Future<void> changeDefaultView(String view) async {
    defaultView.value = view;
    await saveSettings();
    _hapticService.selection();
  }
  
  /// 切换自动备份
  Future<void> toggleAutoBackup(bool value) async {
    autoBackup.value = value;
    await saveSettings();
    _hapticService.light();
    
    if (value) {
      Get.snackbar(
        '自动备份已启用',
        '每天自动备份数据',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  /// 重置所有设置
  Future<void> resetAllSettings() async {
    try {
      themeMode.value = ThemeMode.system;
      notificationsEnabled.value = true;
      eventReminders.value = true;
      intentionReminders.value = true;
      locale.value = const Locale('zh', 'CN');
      fontSize.value = 1.0;
      animationSpeed.value = 1.0;
      primaryColor.value = const Color(0xFF2196F3);  // 蓝色
      defaultView.value = 'calendar';
      autoBackup.value = false;
      
      await saveSettings();
      Get.changeThemeMode(ThemeMode.system);
      Get.updateLocale(const Locale('zh', 'CN'));
      
      _hapticService.success();
      Get.snackbar(
        '设置已重置',
        '所有设置已恢复默认值',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error resetting settings: $e');
      _hapticService.error();
      Get.snackbar(
        '重置失败',
        '无法重置设置',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
