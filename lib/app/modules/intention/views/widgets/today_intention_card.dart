import 'package:flutter/material.dart';
import '../../../../data/models/intention_model.dart';

/// 今日意图卡片
class TodayIntentionCard extends StatelessWidget {
  final IntentionModel? intention;
  final Function(String) onToggleCompletion;
  final Function(String) onEdit;
  final VoidCallback onCreate;

  const TodayIntentionCard({
    super.key,
    required this.intention,
    required this.onToggleCompletion,
    required this.onEdit,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    if (intention == null) {
      return _buildEmptyCard(context);
    }

    return _buildIntentionCard(context, intention!);
  }

  /// 构建空状态卡片
  Widget _buildEmptyCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.wb_sunny_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '今日意图',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '还没有设定今天的意图',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('设定意图'),
          ),
        ],
      ),
    );
  }

  /// 构建意图卡片
  Widget _buildIntentionCard(BuildContext context, IntentionModel intention) {
    final isCompleted = intention.isCompleted;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isCompleted
              ? [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
                ]
              : [
                  Theme.of(context).colorScheme.surfaceContainerHighest,
                  Theme.of(context).colorScheme.surfaceContainerHigh,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题行
          Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.wb_sunny_outlined,
                color: isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '今日意图',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => onEdit(intention.id),
                tooltip: '编辑',
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 意图内容
          Text(
            intention.text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 1.5,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)
                      : null,
                ),
          ),
          
          const SizedBox(height: 20),
          
          // 完成按钮
          SizedBox(
            width: double.infinity,
            child: isCompleted
                ? OutlinedButton.icon(
                    onPressed: () => onToggleCompletion(intention.id),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('标记为未完成'),
                  )
                : FilledButton.icon(
                    onPressed: () => onToggleCompletion(intention.id),
                    icon: const Icon(Icons.check),
                    label: const Text('标记为完成'),
                  ),
          ),
          
          // 完成时间
          if (isCompleted && intention.completedAt != null) ...[
            const SizedBox(height: 12),
            Center(
              child: Text(
                '完成于 ${_formatTime(intention.completedAt!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
