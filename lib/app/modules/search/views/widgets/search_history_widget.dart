import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/event_search_controller.dart';

/// 搜索历史组件
class SearchHistoryWidget extends StatelessWidget {
  final EventSearchController controller;

  const SearchHistoryWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.searchHistory.isEmpty) {
        return _buildEmptyState(context);
      }
      
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 标题栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '搜索历史',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => _showClearHistoryDialog(context),
                child: const Text('清除'),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 历史记录列表
          ...controller.searchHistory.map((query) {
            return _buildHistoryItem(context, query);
          }),
        ],
      );
    });
  }
  
  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '暂无搜索历史',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '开始搜索事件，历史记录会显示在这里',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// 构建历史记录项
  Widget _buildHistoryItem(BuildContext context, String query) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          Icons.history,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        title: Text(query),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            controller.searchHistory.remove(query);
          },
        ),
        onTap: () {
          controller.searchFromHistory(query);
        },
      ),
    );
  }
  
  /// 显示清除历史对话框
  void _showClearHistoryDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('清除搜索历史'),
        content: const Text('确定要清除所有搜索历史吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              controller.clearSearchHistory();
              Get.back();
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
}
