import 'package:flutter/material.dart';
import '../../../../data/models/intention_model.dart';

/// 意图历史列表
class IntentionHistoryList extends StatelessWidget {
  final List<IntentionModel> intentions;
  final Function(String) onToggleCompletion;
  final Function(String) onEdit;
  final Function(String) onDelete;

  const IntentionHistoryList({
    super.key,
    required this.intentions,
    required this.onToggleCompletion,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (intentions.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: intentions.map((intention) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildIntentionCard(context, intention),
        );
      }).toList(),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无历史记录',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  /// 构建意图卡片
  Widget _buildIntentionCard(BuildContext context, IntentionModel intention) {
    final isToday = intention.isToday;
    final isCompleted = intention.isCompleted;

    return Dismissible(
      key: Key(intention.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除意图'),
            content: const Text('确定要删除这条意图吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
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
      },
      onDismissed: (direction) {
        onDelete(intention.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isToday
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // 完成状态复选框
            Checkbox(
              value: isCompleted,
              onChanged: (_) => onToggleCompletion(intention.id),
              shape: const CircleBorder(),
            ),
            
            const SizedBox(width: 12),
            
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 日期
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(intention.date),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      if (isToday) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '今天',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 意图文本
                  Text(
                    intention.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : null,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // 完成时间
                  if (isCompleted && intention.completedAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '完成于 ${_formatTime(intention.completedAt!)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // 编辑按钮
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => onEdit(intention.id),
              tooltip: '编辑',
            ),
          ],
        ),
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate.isAtSameMomentAs(today)) {
      return '今天';
    } else if (targetDate.isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return '昨天';
    } else if (targetDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return '明天';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
