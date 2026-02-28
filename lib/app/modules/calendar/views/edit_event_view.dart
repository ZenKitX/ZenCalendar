import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_event_controller.dart';

/// 编辑事件视图
class EditEventView extends GetView<EditEventController> {
  const EditEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑事件'),
        actions: [
          Obx(() => controller.isLoading.value
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
                  onPressed: controller.updateEvent,
                  child: const Text('保存'),
                )),
        ],
      ),
      body: Obx(() {
        if (controller.event.value == null && controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 标题输入
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: '标题',
                hintText: '输入事件标题',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            
            const SizedBox(height: 16),
            
            // 描述输入
            TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(
                labelText: '描述（可选）',
                hintText: '输入事件描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            
            const SizedBox(height: 24),
            
            // 日期选择
            Obx(() => ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('日期'),
                  subtitle: Text(_formatDate(controller.selectedDate.value)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => controller.selectDate(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                )),
            
            const SizedBox(height: 12),
            
            // 全天事件开关
            Obx(() => SwitchListTile(
                  secondary: const Icon(Icons.access_time_outlined),
                  title: const Text('全天'),
                  value: controller.isAllDay.value,
                  onChanged: (_) => controller.toggleAllDay(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                )),
            
            const SizedBox(height: 12),
            
            // 时间选择
            Obx(() {
              if (controller.isAllDay.value) {
                return const SizedBox.shrink();
              }
              
              return Column(
                children: [
                  // 开始时间
                  ListTile(
                    leading: const Icon(Icons.schedule_outlined),
                    title: const Text('开始时间'),
                    subtitle: Text(controller.startTime.value.format(context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => controller.selectStartTime(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 结束时间
                  ListTile(
                    leading: const Icon(Icons.schedule_outlined),
                    title: const Text('结束时间'),
                    subtitle: Text(controller.endTime.value.format(context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => controller.selectEndTime(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        );
      }),
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
    } else {
      return '${date.year}年${date.month}月${date.day}日';
    }
  }
}
