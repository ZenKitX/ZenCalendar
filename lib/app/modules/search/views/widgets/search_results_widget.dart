import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/event_search_controller.dart';
import '../../../../data/models/event_model.dart';

/// 搜索结果组件
class SearchResultsWidget extends StatelessWidget {
  final EventSearchController controller;

  const SearchResultsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.searchResults.isEmpty) {
        return _buildEmptyState(context);
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.searchResults.length,
        itemBuilder: (context, index) {
          final event = controller.searchResults[index];
          return _buildEventCard(context, event);
        },
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
            Icons.search_off_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            '没有找到匹配的事件',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            '尝试使用不同的关键词或调整筛选条件',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// 构建事件卡片
  Widget _buildEventCard(BuildContext context, EventModel event) {
    final categoryColor = Color(controller.getCategoryColor(event.categoryId));
    final categoryName = controller.getCategoryName(event.categoryId);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final result = await Get.toNamed('/event/${event.id}');
          
          if (result == true) {
            controller.refresh();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题和分类
              Row(
                children: [
                  // 分类指示器
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // 标题
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 时间信息
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatEventTime(event),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 分类标签
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  categoryName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              
              // 描述（如果有）
              if (event.description != null && event.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  event.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  /// 格式化事件时间
  String _formatEventTime(EventModel event) {
    final dateFormat = DateFormat('yyyy年M月d日');
    final timeFormat = DateFormat('HH:mm');
    
    if (event.isAllDay) {
      return '${dateFormat.format(event.startTime)} 全天';
    }
    
    final startDate = dateFormat.format(event.startTime);
    final startTime = timeFormat.format(event.startTime);
    final endTime = timeFormat.format(event.endTime);
    
    return '$startDate $startTime - $endTime';
  }
}
