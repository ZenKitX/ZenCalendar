import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/event_search_controller.dart';

/// 搜索筛选器组件
class SearchFiltersWidget extends StatelessWidget {
  final EventSearchController controller;

  const SearchFiltersWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 筛选标题
          Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 20,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Text(
                '筛选条件',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 筛选按钮
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // 分类筛选
              _buildFilterChip(
                context,
                label: '分类',
                icon: Icons.category_outlined,
                onTap: () => _showCategoryFilter(context),
              ),
              
              // 日期范围筛选
              _buildFilterChip(
                context,
                label: '日期范围',
                icon: Icons.date_range_outlined,
                onTap: () => _showDateRangeFilter(context),
              ),
            ],
          ),
          
          // 活动筛选显示
          Obx(() {
            if (controller.hasActiveFilters) {
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_alt,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.filterDescription,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
  
  /// 构建筛选芯片
  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 显示分类筛选对话框
  void _showCategoryFilter(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('选择分类'),
        content: Obx(() {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 全部分类选项
                RadioListTile<String?>(
                  title: const Text('全部分类'),
                  value: null,
                  groupValue: controller.selectedCategoryId.value,
                  onChanged: (value) {
                    controller.setCategoryFilter(value);
                    Get.back();
                  },
                ),
                
                const Divider(),
                
                // 分类列表
                ...controller.categories.map((category) {
                  return RadioListTile<String>(
                    title: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: category.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(category.name),
                      ],
                    ),
                    value: category.id,
                    groupValue: controller.selectedCategoryId.value,
                    onChanged: (value) {
                      controller.setCategoryFilter(value);
                      Get.back();
                    },
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
  
  /// 显示日期范围筛选对话框
  void _showDateRangeFilter(BuildContext context) async {
    final now = DateTime.now();
    final initialDateRange = DateTimeRange(
      start: controller.startDate.value ?? now.subtract(const Duration(days: 30)),
      end: controller.endDate.value ?? now.add(const Duration(days: 30)),
    );
    
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      controller.setDateRangeFilter(picked.start, picked.end);
    }
  }
}
