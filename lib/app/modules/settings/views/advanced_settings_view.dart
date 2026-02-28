import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

/// 高级设置页面
class AdvancedSettingsView extends GetView<SettingsController> {
  const AdvancedSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('高级设置'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _showResetDialog(context),
            tooltip: '重置所有设置',
          ),
        ],
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 语言设置
          _buildLanguageSection(context),
          
          const SizedBox(height: 24),
          
          // 显示设置
          _buildDisplaySection(context),
          
          const SizedBox(height: 24),
          
          // 动画设置
          _buildAnimationSection(context),
          
          const SizedBox(height: 24),
          
          // 主题自定义
          _buildThemeSection(context),
          
          const SizedBox(height: 24),
          
          // 首页设置
          _buildHomeSection(context),
          
          const SizedBox(height: 24),
          
          // 数据同步设置
          _buildSyncSection(context),
        ],
      )),
    );
  }
  
  /// 语言设置区域
  Widget _buildLanguageSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '语言设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ListTile(
              title: const Text('中文'),
              trailing: controller.locale.value.languageCode == 'zh'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => controller.changeLocale(const Locale('zh', 'CN')),
            ),
            
            ListTile(
              title: const Text('English'),
              trailing: controller.locale.value.languageCode == 'en'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => controller.changeLocale(const Locale('en', 'US')),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 显示设置区域
  Widget _buildDisplaySection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.text_fields,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '显示设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 字体大小
            ListTile(
              title: const Text('字体大小'),
              subtitle: Text('${(controller.fontSize.value * 100).toInt()}%'),
            ),
            
            Slider(
              value: controller.fontSize.value,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              label: '${(controller.fontSize.value * 100).toInt()}%',
              onChanged: (value) => controller.changeFontSize(value),
            ),
            
            const SizedBox(height: 8),
            
            // 预览文本
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '这是预览文本 Preview Text',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14 * controller.fontSize.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 动画设置区域
  Widget _buildAnimationSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.animation,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '动画设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ListTile(
              title: const Text('动画速度'),
              subtitle: Text(_getAnimationSpeedLabel(controller.animationSpeed.value)),
            ),
            
            Slider(
              value: controller.animationSpeed.value,
              min: 0.5,
              max: 2.0,
              divisions: 6,
              label: _getAnimationSpeedLabel(controller.animationSpeed.value),
              onChanged: (value) => controller.changeAnimationSpeed(value),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 主题自定义区域
  Widget _buildThemeSection(BuildContext context) {
    final colors = [
      {'name': '蓝色', 'color': Colors.blue},
      {'name': '紫色', 'color': Colors.purple},
      {'name': '绿色', 'color': Colors.green},
      {'name': '橙色', 'color': Colors.orange},
      {'name': '粉色', 'color': Colors.pink},
      {'name': '青色', 'color': Colors.cyan},
    ];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '主题自定义',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            const Text('主题颜色'),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((colorData) {
                final color = colorData['color'] as Color;
                final name = colorData['name'] as String;
                final isSelected = controller.primaryColor.value.value == color.value;
                
                return GestureDetector(
                  onTap: () => controller.changePrimaryColor(color),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              '注意：主题颜色需要重启应用后生效',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 首页设置区域
  Widget _buildHomeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '首页设置',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            ListTile(
              title: const Text('日历'),
              subtitle: const Text('以日历视图作为首页'),
              trailing: controller.defaultView.value == 'calendar'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => controller.changeDefaultView('calendar'),
            ),
            
            ListTile(
              title: const Text('意图'),
              subtitle: const Text('以每日意图作为首页'),
              trailing: controller.defaultView.value == 'intention'
                  ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () => controller.changeDefaultView('intention'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 数据同步设置区域
  Widget _buildSyncSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sync,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '数据同步',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('自动备份'),
              subtitle: const Text('每天自动备份数据到本地'),
              value: controller.autoBackup.value,
              onChanged: (value) => controller.toggleAutoBackup(value),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              '云端同步功能将在未来版本中提供',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 获取动画速度标签
  String _getAnimationSpeedLabel(double speed) {
    if (speed <= 0.5) return '很慢';
    if (speed <= 0.75) return '慢';
    if (speed <= 1.0) return '正常';
    if (speed <= 1.5) return '快';
    return '很快';
  }
  
  /// 显示重置对话框
  void _showResetDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('重置所有设置'),
        content: const Text('确定要将所有设置恢复为默认值吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.resetAllSettings();
            },
            child: Text(
              '重置',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
