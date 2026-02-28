import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/meditation_controller.dart';

/// 冥想统计组件
class MeditationStatsWidget extends StatelessWidget {
  final MeditationController controller;

  const MeditationStatsWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          // 总时长
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.timer_outlined,
              label: '总时长',
              value: controller.formattedTotalDuration,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 总次数
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.repeat,
              label: '总次数',
              value: '${controller.totalCount.value} 次',
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // 连续天数
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.local_fire_department,
              label: '连续',
              value: '${controller.streakDays.value} 天',
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      );
    });
  }

  /// 构建统计卡片
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
