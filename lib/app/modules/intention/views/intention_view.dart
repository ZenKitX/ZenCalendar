import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/intention_repository.dart';
import '../controllers/intention_controller.dart';
import 'widgets/today_intention_card.dart';
import 'widgets/daily_quote_card.dart';
import 'widgets/intention_history_list.dart';
import 'widgets/stats_card.dart';

/// Intention 视图
class IntentionView extends GetView<IntentionController> {
  const IntentionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.todayIntention.value == null) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: const Text('每日意图'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.loadTodayIntention();
            await controller.loadAllIntentions();
            controller.loadDailyQuote();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 每日禅语
              DailyQuoteCard(
                quote: controller.dailyQuote.value,
                onRefresh: controller.loadDailyQuote,
              ),
              
              const SizedBox(height: 16),
              
              // 今日意图卡片
              TodayIntentionCard(
                intention: controller.todayIntention.value,
                onToggleCompletion: (id) => controller.toggleCompletion(id),
                onEdit: (id) => _showEditDialog(context, id),
                onCreate: () => _showCreateDialog(context),
              ),
              
              const SizedBox(height: 16),
              
              // 统计卡片
              StatsCard(
                stats: controller.completionStats,
                completionRate: controller.completionRate,
              ),
              
              const SizedBox(height: 24),
              
              // 历史记录标题
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '历史记录',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (controller.allIntentions.isNotEmpty)
                    Text(
                      '共 ${controller.allIntentions.length} 条',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 历史记录列表
              IntentionHistoryList(
                intentions: controller.allIntentions,
                onToggleCompletion: (id) => controller.toggleCompletion(id),
                onEdit: (id) => _showEditDialog(context, id),
                onDelete: (id) => _showDeleteDialog(context, id),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// 显示创建意图对话框
  void _showCreateDialog(BuildContext context) {
    final textController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: const Text('设定今日意图'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: '今天我想要...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Get.back();
              controller.createTodayIntention(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final text = textController.text;
              if (text.trim().isNotEmpty) {
                Get.back();
                controller.createTodayIntention(text);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 显示编辑意图对话框
  void _showEditDialog(BuildContext context, String id) async {
    final repository = Get.find<IntentionRepository>();
    final intention = await repository.getById(id);
    if (intention == null) return;
    
    final textController = TextEditingController(text: intention.text);
    
    Get.dialog(
      AlertDialog(
        title: const Text('编辑意图'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: '输入意图内容',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Get.back();
              controller.updateIntention(id, value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final text = textController.text;
              if (text.trim().isNotEmpty) {
                Get.back();
                controller.updateIntention(id, text);
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context, String id) async {
    final repository = Get.find<IntentionRepository>();
    final intention = await repository.getById(id);
    if (intention == null) return;
    
    Get.dialog(
      AlertDialog(
        title: const Text('删除意图'),
        content: Text('确定要删除这条意图吗？\n\n「${intention.text}」'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteIntention(id);
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
