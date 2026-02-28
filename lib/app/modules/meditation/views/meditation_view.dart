import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/meditation_controller.dart';
import 'widgets/meditation_timer_widget.dart';
import 'widgets/meditation_stats_widget.dart';
import 'widgets/meditation_history_widget.dart';

/// 冥想主视图
class MeditationView extends GetView<MeditationController> {
  const MeditationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('冥想'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showHistorySheet(context);
            },
            tooltip: '历史记录',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 统计卡片
              MeditationStatsWidget(controller: controller),
              
              const SizedBox(height: 24),
              
              // 计时器
              MeditationTimerWidget(controller: controller),
              
              const SizedBox(height: 24),
              
              // 最近记录
              _buildRecentRecords(context),
            ],
          ),
        );
      }),
    );
  }

  /// 构建最近记录
  Widget _buildRecentRecords(BuildContext context) {
    return Obx(() {
      if (controller.records.isEmpty) {
        return const SizedBox.shrink();
      }

      final recentRecords = controller.records.take(3).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '最近记录',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => _showHistorySheet(context),
                child: const Text('查看全部'),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          ...recentRecords.map((record) {
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.self_improvement,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(record.formattedDuration),
                subtitle: Text(record.formattedDate),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteDialog(context, record),
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  /// 显示历史记录底部表单
  void _showHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return MeditationHistoryWidget(
              controller: controller,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, record) {
    Get.dialog(
      AlertDialog(
        title: const Text('删除记录'),
        content: Text('确定要删除这条冥想记录吗？\n时长：${record.formattedDuration}'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteRecord(record.id);
            },
            child: Text(
              '删除',
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
