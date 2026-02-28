import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

/// Settings 视图
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 外观设置
          _buildSectionTitle(context, '外观'),
          _buildThemeCard(context),
          
          const SizedBox(height: 24),
          
          // 通知设置
          _buildSectionTitle(context, '通知'),
          _buildNotificationCard(context),
          
          const SizedBox(height: 24),
          
          // 功能
          _buildSectionTitle(context, '功能'),
          _buildFeaturesCard(context),
          
          const SizedBox(height: 24),
          
          // 数据管理
          _buildSectionTitle(context, '数据管理'),
          _buildDataCard(context),
          
          const SizedBox(height: 24),
          
          // 关于
          _buildSectionTitle(context, '关于'),
          _buildAboutCard(context),
        ],
      ),
    );
  }

  /// 构建分区标题
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  /// 构建主题卡片
  Widget _buildThemeCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Obx(() => RadioListTile<ThemeMode>(
                title: const Text('浅色模式'),
                subtitle: const Text('始终使用浅色主题'),
                value: ThemeMode.light,
                groupValue: controller.themeMode.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.changeThemeMode(value);
                  }
                },
                secondary: const Icon(Icons.light_mode_outlined),
              )),
          const Divider(height: 1),
          Obx(() => RadioListTile<ThemeMode>(
                title: const Text('深色模式'),
                subtitle: const Text('始终使用深色主题'),
                value: ThemeMode.dark,
                groupValue: controller.themeMode.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.changeThemeMode(value);
                  }
                },
                secondary: const Icon(Icons.dark_mode_outlined),
              )),
          const Divider(height: 1),
          Obx(() => RadioListTile<ThemeMode>(
                title: const Text('跟随系统'),
                subtitle: const Text('根据系统设置自动切换'),
                value: ThemeMode.system,
                groupValue: controller.themeMode.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.changeThemeMode(value);
                  }
                },
                secondary: const Icon(Icons.brightness_auto_outlined),
              )),
        ],
      ),
    );
  }

  /// 构建通知卡片
  Widget _buildNotificationCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Obx(() => SwitchListTile(
                title: const Text('启用通知'),
                subtitle: const Text('接收应用通知'),
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                secondary: const Icon(Icons.notifications_outlined),
              )),
          const Divider(height: 1),
          Obx(() => SwitchListTile(
                title: const Text('事件提醒'),
                subtitle: const Text('在事件开始前提醒'),
                value: controller.eventReminders.value,
                onChanged: controller.notificationsEnabled.value
                    ? controller.toggleEventReminders
                    : null,
                secondary: const Icon(Icons.event_outlined),
              )),
          const Divider(height: 1),
          Obx(() => SwitchListTile(
                title: const Text('意图提醒'),
                subtitle: const Text('每日意图提醒'),
                value: controller.intentionReminders.value,
                onChanged: controller.notificationsEnabled.value
                    ? controller.toggleIntentionReminders
                    : null,
                secondary: const Icon(Icons.wb_sunny_outlined),
              )),
        ],
      ),
    );
  }

  /// 构建功能卡片
  Widget _buildFeaturesCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.self_improvement),
            title: const Text('冥想'),
            subtitle: const Text('正念冥想练习'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed('/meditation'),
          ),
        ],
      ),
    );
  }

  /// 构建数据卡片
  Widget _buildDataCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Obx(() => ListTile(
                leading: const Icon(Icons.storage_outlined),
                title: const Text('数据统计'),
                subtitle: Text(
                  '事件: ${controller.totalEvents.value} 条 | 意图: ${controller.totalIntentions.value} 条',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: controller.loadDataStats,
                  tooltip: '刷新',
                ),
              )),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('导出数据'),
            subtitle: const Text('导出为 JSON 或 CSV 文件'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showExportDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('导入数据'),
            subtitle: const Text('从 JSON 或 CSV 文件导入'),
            trailing: const Icon(Icons.chevron_right),
            onTap: controller.importData,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('创建备份'),
            subtitle: const Text('备份当前所有数据'),
            trailing: const Icon(Icons.chevron_right),
            onTap: controller.createBackup,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              '清除所有数据',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            subtitle: const Text('删除所有事件和意图'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }

  /// 构建关于卡片
  Widget _buildAboutCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于 ZenCalendar'),
            subtitle: const Text('版本 1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('开源许可'),
            subtitle: const Text('MIT License'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLicenseDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.code_outlined),
            title: const Text('GitHub'),
            subtitle: const Text('查看源代码'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              Get.snackbar(
                '提示',
                'GitHub 链接即将推出',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  /// 显示清除数据确认对话框
  void _showClearDataDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('清除所有数据'),
        content: const Text(
          '此操作将删除所有事件和意图数据，且无法恢复。\n\n确定要继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAllData();
            },
            child: Text(
              '清除',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示导出对话框
  void _showExportDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('导出数据'),
        content: const Text('请选择导出格式：'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.exportDataAsCsv();
            },
            child: const Text('CSV'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.exportDataAsJson();
            },
            child: const Text('JSON'),
          ),
        ],
      ),
    );
  }

  /// 显示关于对话框
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ZenCalendar',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.calendar_today,
          size: 32,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      applicationLegalese: '© 2026 ZenCalendar\n\n一个简洁优雅的日历和意图管理应用',
      children: [
        const SizedBox(height: 16),
        const Text(
          '特性：\n'
          '• 日历事件管理\n'
          '• 每日意图设定\n'
          '• 禅语启发\n'
          '• 优雅的 Soft UI 设计\n'
          '• 触觉反馈\n'
          '• 深色模式支持',
        ),
      ],
    );
  }

  /// 显示许可证对话框
  void _showLicenseDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('开源许可'),
        content: const SingleChildScrollView(
          child: Text(
            'MIT License\n\n'
            'Copyright (c) 2026 ZenCalendar\n\n'
            'Permission is hereby granted, free of charge, to any person obtaining a copy '
            'of this software and associated documentation files (the "Software"), to deal '
            'in the Software without restriction, including without limitation the rights '
            'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
            'copies of the Software, and to permit persons to whom the Software is '
            'furnished to do so, subject to the following conditions:\n\n'
            'The above copyright notice and this permission notice shall be included in all '
            'copies or substantial portions of the Software.\n\n'
            'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
            'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
            'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE '
            'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER '
            'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, '
            'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE '
            'SOFTWARE.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
