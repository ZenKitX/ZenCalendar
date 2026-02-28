import 'package:flutter/material.dart';

/// 统计卡片
class StatsCard extends StatelessWidget {
  final Map<String, int> stats;
  final double completionRate;

  const StatsCard({
    super.key,
    required this.stats,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '完成统计',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 进度条
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 统计数据
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                label: '总计',
                value: stats['total']!,
                icon: Icons.list_alt,
                color: Theme.of(context).colorScheme.primary,
              ),
              _buildStatItem(
                context,
                label: '已完成',
                value: stats['completed']!,
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
              _buildStatItem(
                context,
                label: '待完成',
                value: stats['pending']!,
                icon: Icons.pending_outlined,
                color: Colors.orange,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 完成率
          Center(
            child: Text(
              '完成率: ${(completionRate * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
