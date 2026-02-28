import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/meditation_controller.dart';

/// 冥想计时器组件
class MeditationTimerWidget extends StatelessWidget {
  final MeditationController controller;

  const MeditationTimerWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 圆形进度指示器
            Obx(() => _buildCircularProgress(context)),
            
            const SizedBox(height: 32),
            
            // 时长选择器
            Obx(() {
              if (controller.meditationState.value == MeditationState.idle) {
                return _buildDurationSelector(context);
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 24),
            
            // 控制按钮
            Obx(() => _buildControlButtons(context)),
          ],
        ),
      ),
    );
  }

  /// 构建圆形进度指示器
  Widget _buildCircularProgress(BuildContext context) {
    final state = controller.meditationState.value;
    final isActive = state == MeditationState.running || state == MeditationState.paused;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景圆环
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
          ),
          
          // 进度圆环
          if (isActive)
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: controller.progress,
                strokeWidth: 12,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          
          // 中心内容
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive) ...[
                Text(
                  controller.formattedRemainingTime,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  state == MeditationState.paused ? '已暂停' : '冥想中',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
              ] else if (state == MeditationState.completed) ...[
                Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  '完成',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ] else ...[
                Icon(
                  Icons.self_improvement,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  '开始冥想',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// 构建时长选择器
  Widget _buildDurationSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择时长',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.presetDurations.map((duration) {
            final isSelected = controller.selectedDuration.value == duration;
            
            return ChoiceChip(
              label: Text('$duration 分钟'),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  controller.selectDuration(duration);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建控制按钮
  Widget _buildControlButtons(BuildContext context) {
    final state = controller.meditationState.value;

    if (state == MeditationState.idle || state == MeditationState.completed) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: controller.startMeditation,
          icon: const Icon(Icons.play_arrow),
          label: const Text('开始'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }

    return Row(
      children: [
        // 停止按钮
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.stopMeditation,
            icon: const Icon(Icons.stop),
            label: const Text('停止'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 暂停/恢复按钮
        Expanded(
          child: FilledButton.icon(
            onPressed: state == MeditationState.running
                ? controller.pauseMeditation
                : controller.resumeMeditation,
            icon: Icon(
              state == MeditationState.running ? Icons.pause : Icons.play_arrow,
            ),
            label: Text(state == MeditationState.running ? '暂停' : '继续'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
