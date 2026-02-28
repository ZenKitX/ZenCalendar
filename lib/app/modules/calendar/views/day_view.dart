import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/day_controller.dart';
import 'widgets/day_calendar_widget.dart';

/// 日视图页面
class DayView extends StatelessWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DayController>(tag: 'day');
    
    return Obx(() {
      if (controller.isLoading.value && controller.events.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        children: [
          // 日视图日历
          Expanded(
            child: DayCalendarWidget(
              controller: controller,
              onEventTap: (event) async {
                final result = await Get.toNamed('/event/${event.id}');
                
                // 如果删除或编辑了事件，重新加载
                if (result == true) {
                  controller.loadEvents();
                }
              },
            ),
          ),
        ],
      );
    });
  }
}