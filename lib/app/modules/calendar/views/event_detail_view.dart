import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../services/haptic_service.dart';

/// 事件详情视图
class EventDetailView extends StatefulWidget {
  const EventDetailView({super.key});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> {
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  EventModel? _event;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  /// 加载事件数据
  Future<void> _loadEvent() async {
    try {
      final eventId = Get.parameters['id'];
      if (eventId == null) {
        Get.back();
        return;
      }

      final event = await _eventRepository.getById(eventId);
      
      if (event == null) {
        Get.back();
        Get.snackbar(
          '错误',
          '事件不存在',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      setState(() {
        _event = event;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading event: $e');
      Get.back();
      Get.snackbar(
        '错误',
        '加载事件失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('事件详情'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_event == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('事件详情'),
        ),
        body: const Center(
          child: Text('事件不存在'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('事件详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              _hapticService.light();
              final result = await Get.toNamed(
                '/edit-event/${_event!.id}',
              );
              
              // 如果编辑成功，重新加载事件
              if (result == true) {
                _loadEvent();
              }
            },
            tooltip: '编辑',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context),
            tooltip: '删除',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 标题
          Text(
            _event!.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          
          const SizedBox(height: 24),
          
          // 日期和时间信息
          _buildInfoCard(
            context,
            icon: Icons.calendar_today_outlined,
            title: '日期',
            content: _formatDate(_event!.startTime),
          ),
          
          const SizedBox(height: 12),
          
          if (!_event!.isAllDay)
            _buildInfoCard(
              context,
              icon: Icons.schedule_outlined,
              title: '时间',
              content: _formatTimeRange(_event!.startTime, _event!.endTime),
            ),
          
          if (_event!.isAllDay)
            _buildInfoCard(
              context,
              icon: Icons.access_time_outlined,
              title: '时间',
              content: '全天',
            ),
          
          const SizedBox(height: 12),
          
          _buildInfoCard(
            context,
            icon: Icons.timelapse_outlined,
            title: '时长',
            content: _formatDuration(_event!.startTime, _event!.endTime),
          ),
          
          // 描述（如果有）
          if (_event!.description != null && _event!.description!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              '描述',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _event!.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
          
          // 元数据
          const SizedBox(height: 24),
          Text(
            '元数据',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            context,
            icon: Icons.fingerprint_outlined,
            title: 'ID',
            content: _event!.id,
            isSmall: true,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            context,
            icon: Icons.access_time_outlined,
            title: '创建时间',
            content: _formatDateTime(_event!.createdAt),
            isSmall: true,
          ),
          const SizedBox(height: 8),
          _buildInfoCard(
            context,
            icon: Icons.update_outlined,
            title: '更新时间',
            content: _formatDateTime(_event!.updatedAt),
            isSmall: true,
          ),
        ],
      ),
    );
  }

  /// 构建信息卡片
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    bool isSmall = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: isSmall ? 20 : 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: isSmall
                      ? Theme.of(context).textTheme.bodyMedium
                      : Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay.isAtSameMomentAs(today)) {
      return '今天 - ${date.year}年${date.month}月${date.day}日';
    } else if (selectedDay.isAtSameMomentAs(
        today.add(const Duration(days: 1)))) {
      return '明天 - ${date.year}年${date.month}月${date.day}日';
    } else if (selectedDay.isAtSameMomentAs(
        today.subtract(const Duration(days: 1)))) {
      return '昨天 - ${date.year}年${date.month}月${date.day}日';
    } else {
      return '${date.year}年${date.month}月${date.day}日';
    }
  }

  /// 格式化时间范围
  String _formatTimeRange(DateTime start, DateTime end) {
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  /// 格式化时间
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化时长
  String _formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours 小时 $minutes 分钟';
    } else if (hours > 0) {
      return '$hours 小时';
    } else {
      return '$minutes 分钟';
    }
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${_formatTime(dateTime)}';
  }

  /// 显示删除确认对话框
  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('删除事件'),
        content: Text('确定要删除「${_event!.title}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // 关闭对话框
              
              try {
                await _eventRepository.delete(_event!.id);
                _hapticService.success();
                
                Get.back(result: true); // 返回上一页
                
                Get.snackbar(
                  '成功',
                  '事件已删除',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              } catch (e) {
                print('❌ Error deleting event: $e');
                _hapticService.error();
                Get.snackbar(
                  '错误',
                  '删除事件失败',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
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
