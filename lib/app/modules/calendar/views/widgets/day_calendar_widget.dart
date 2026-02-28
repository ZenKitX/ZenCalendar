import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/day_controller.dart';
import '../../../../data/models/event_model.dart';

/// 日视图日历组件
class DayCalendarWidget extends StatelessWidget {
  final DayController controller;
  final Function(EventModel)? onEventTap;
  
  const DayCalendarWidget({
    super.key,
    required this.controller,
    this.onEventTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // 日期导航栏
          _buildDayNavigation(context),
          
          const SizedBox(height: 16),
          
          // 全天事件区域
          if (controller.allDayEvents.isNotEmpty)
            _buildAllDayEventsSection(context),
          
          // 时间轴视图
          Expanded(
            child: _buildTimeAxisView(context),
          ),
        ],
      );
    });
  }
  
  /// 构建日期导航栏
  Widget _buildDayNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: controller.previousDay,
            icon: const Icon(Icons.chevron_left),
            tooltip: '上一天',
          ),
          
          Expanded(
            child: Text(
              controller.dayTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          IconButton(
            onPressed: controller.nextDay,
            icon: const Icon(Icons.chevron_right),
            tooltip: '下一天',
          ),
        ],
      ),
    );
  }
  
  /// 构建全天事件区域
  Widget _buildAllDayEventsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '全天事件',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          ...controller.allDayEvents.map((event) => _buildAllDayEventCard(context, event)),
        ],
      ),
    );
  }
  
  /// 构建全天事件卡片
  Widget _buildAllDayEventCard(BuildContext context, EventModel event) {
    return GestureDetector(
      onTap: () => onEventTap?.call(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(width: 8),
            
            Expanded(
              child: Text(
                event.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建时间轴视图
  Widget _buildTimeAxisView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // 时间标签列
          _buildTimeLabels(context),
          
          // 分隔线
          Container(
            width: 1,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          
          // 事件区域
          Expanded(
            child: _buildEventsArea(context),
          ),
        ],
      ),
    );
  }
  
  /// 构建时间标签列
  Widget _buildTimeLabels(BuildContext context) {
    return Container(
      width: 60,
      child: ListView.builder(
        controller: controller.scrollController,
        itemCount: DayController.endHour - DayController.startHour,
        itemBuilder: (context, index) {
          final hour = DayController.startHour + index;
          
          return Container(
            height: DayController.hourHeight,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          );
        },
      ),
    );
  }
  
  /// 构建事件区域
  Widget _buildEventsArea(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // 计算点击位置对应的时间
        final yPosition = details.localPosition.dy;
        controller.createEventAtTime(yPosition);
      },
      child: Stack(
        children: [
          // 时间网格背景
          _buildTimeGrid(context),
          
          // 当前时间线
          if (controller.isToday(controller.selectedDate.value))
            _buildCurrentTimeLine(context),
          
          // 事件卡片
          ..._buildEventCards(context),
        ],
      ),
    );
  }
  
  /// 构建时间网格背景
  Widget _buildTimeGrid(BuildContext context) {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: DayController.endHour - DayController.startHour,
      itemBuilder: (context, index) {
        return Container(
          height: DayController.hourHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }
  
  /// 构建当前时间线
  Widget _buildCurrentTimeLine(BuildContext context) {
    final position = controller.currentTimeLinePosition;
    if (position < 0) return const SizedBox.shrink();
    
    return Positioned(
      top: position,
      left: 0,
      right: 0,
      child: Container(
        height: 2,
        color: Theme.of(context).colorScheme.error,
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                height: 2,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建事件卡片列表
  List<Widget> _buildEventCards(BuildContext context) {
    return controller.timedEvents.map((event) {
      final startY = controller.getYPositionForTime(event.startTime);
      final endY = controller.getYPositionForTime(event.endTime);
      final height = endY - startY;
      
      return Positioned(
        top: startY,
        left: 8,
        right: 8,
        height: height.clamp(30.0, double.infinity), // 最小高度30
        child: GestureDetector(
          onTap: () => onEventTap?.call(event),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (height > 40) // 只有在高度足够时才显示时间
                  Text(
                    '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                
                if (height > 60 && event.description.isNotEmpty) // 显示描述
                  Expanded(
                    child: Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
  
  /// 格式化时间
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}