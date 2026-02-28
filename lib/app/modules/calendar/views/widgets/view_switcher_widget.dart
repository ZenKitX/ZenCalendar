import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/calendar_view_type.dart';

/// 视图切换器组件
class ViewSwitcherWidget extends StatelessWidget {
  final CalendarViewType currentViewType;
  final Function(CalendarViewType) onViewTypeChanged;
  
  const ViewSwitcherWidget({
    super.key,
    required this.currentViewType,
    required this.onViewTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: CalendarViewType.values.map((viewType) {
          final isSelected = currentViewType == viewType;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onViewTypeChanged(viewType),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      viewType.icon,
                      size: 18,
                      color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      viewType.displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}