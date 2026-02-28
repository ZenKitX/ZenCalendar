import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_search_controller.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_filters_widget.dart';
import 'widgets/search_results_widget.dart';
import 'widgets/search_history_widget.dart';

/// 搜索视图
class SearchView extends GetView<EventSearchController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索事件'),
        actions: [
          // 清除筛选按钮
          Obx(() {
            if (controller.hasActiveFilters) {
              return IconButton(
                icon: const Icon(Icons.filter_alt_off_outlined),
                onPressed: controller.clearFilters,
                tooltip: '清除筛选',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          // 搜索栏
          SearchBarWidget(controller: controller),
          
          // 筛选器
          Obx(() {
            if (controller.isSearching.value) {
              return SearchFiltersWidget(controller: controller);
            }
            return const SizedBox.shrink();
          }),
          
          // 内容区域
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (controller.isSearching.value) {
                return SearchResultsWidget(controller: controller);
              }
              
              return SearchHistoryWidget(controller: controller);
            }),
          ),
        ],
      ),
    );
  }
}
