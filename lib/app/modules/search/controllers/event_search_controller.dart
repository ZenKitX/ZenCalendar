import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/event_category.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../services/haptic_service.dart';

/// 事件搜索控制器
class EventSearchController extends GetxController {
  // 依赖注入
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 响应式状态
  final searchQuery = ''.obs;
  final searchResults = <EventModel>[].obs;
  final allEvents = <EventModel>[].obs;
  final categories = <EventCategory>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;
  
  // 筛选条件
  final selectedCategoryId = Rxn<String>();
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final searchHistory = <String>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    print('EventSearchController initialized');
    _loadInitialData();
    _loadSearchHistory();
  }
  
  /// 加载初始数据
  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      
      // 加载所有事件
      allEvents.value = await _eventRepository.getAll();
      
      // 加载分类（使用预定义分类）
      categories.value = EventCategory.defaultCategories;
      
      print('✅ Loaded ${allEvents.length} events for search');
      print('✅ Loaded ${categories.length} categories');
    } catch (e) {
      print('❌ Error loading search data: $e');
      Get.snackbar(
        '错误',
        '加载数据失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 加载搜索历史
  void _loadSearchHistory() {
    // TODO: 从本地存储加载搜索历史
    searchHistory.value = [];
  }
  
  /// 执行搜索
  void search(String query) {
    searchQuery.value = query.trim();
    
    if (searchQuery.value.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }
    
    isSearching.value = true;
    _hapticService.light();
    
    // 添加到搜索历史
    _addToSearchHistory(searchQuery.value);
    
    // 执行搜索
    _performSearch();
  }
  
  /// 执行搜索逻辑
  void _performSearch() {
    final query = searchQuery.value.toLowerCase();
    
    // 筛选事件
    var results = allEvents.where((event) {
      // 文本搜索
      final matchesText = event.title.toLowerCase().contains(query) ||
          (event.description?.toLowerCase().contains(query) ?? false);
      
      if (!matchesText) return false;
      
      // 分类筛选
      if (selectedCategoryId.value != null) {
        if (event.categoryId != selectedCategoryId.value) return false;
      }
      
      // 日期范围筛选
      if (startDate.value != null) {
        if (event.startTime.isBefore(startDate.value!)) return false;
      }
      
      if (endDate.value != null) {
        if (event.startTime.isAfter(endDate.value!)) return false;
      }
      
      return true;
    }).toList();
    
    // 按时间排序（最近的在前）
    results.sort((a, b) => b.startTime.compareTo(a.startTime));
    
    searchResults.value = results;
    print('🔍 Found ${results.length} results for "$query"');
  }
  
  /// 清除搜索
  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
    _hapticService.light();
  }
  
  /// 设置分类筛选
  void setCategoryFilter(String? categoryId) {
    selectedCategoryId.value = categoryId;
    _hapticService.light();
    
    if (isSearching.value) {
      _performSearch();
    }
  }
  
  /// 设置日期范围筛选
  void setDateRangeFilter(DateTime? start, DateTime? end) {
    startDate.value = start;
    endDate.value = end;
    _hapticService.light();
    
    if (isSearching.value) {
      _performSearch();
    }
  }
  
  /// 清除所有筛选
  void clearFilters() {
    selectedCategoryId.value = null;
    startDate.value = null;
    endDate.value = null;
    _hapticService.light();
    
    if (isSearching.value) {
      _performSearch();
    }
  }
  
  /// 添加到搜索历史
  void _addToSearchHistory(String query) {
    if (query.isEmpty) return;
    
    // 移除重复项
    searchHistory.remove(query);
    
    // 添加到开头
    searchHistory.insert(0, query);
    
    // 限制历史记录数量
    if (searchHistory.length > 10) {
      searchHistory.removeRange(10, searchHistory.length);
    }
    
    // TODO: 保存到本地存储
  }
  
  /// 从历史记录搜索
  void searchFromHistory(String query) {
    search(query);
  }
  
  /// 清除搜索历史
  void clearSearchHistory() {
    searchHistory.clear();
    _hapticService.light();
    // TODO: 从本地存储清除
  }
  
  /// 刷新数据
  Future<void> refresh() async {
    await _loadInitialData();
    
    if (isSearching.value) {
      _performSearch();
    }
  }
  
  /// 获取分类名称
  String getCategoryName(String? categoryId) {
    if (categoryId == null) return '未分类';
    
    final category = categories.firstWhereOrNull(
      (c) => c.id == categoryId,
    );
    
    return category?.name ?? '未知分类';
  }
  
  /// 获取分类颜色
  int getCategoryColor(String? categoryId) {
    if (categoryId == null) return 0xFF9CA3AF;
    
    final category = categories.firstWhereOrNull(
      (c) => c.id == categoryId,
    );
    
    return category?.color.value ?? 0xFF9CA3AF;
  }
  
  /// 是否有活动筛选
  bool get hasActiveFilters {
    return selectedCategoryId.value != null ||
        startDate.value != null ||
        endDate.value != null;
  }
  
  /// 获取筛选描述
  String get filterDescription {
    final filters = <String>[];
    
    if (selectedCategoryId.value != null) {
      filters.add(getCategoryName(selectedCategoryId.value));
    }
    
    if (startDate.value != null || endDate.value != null) {
      if (startDate.value != null && endDate.value != null) {
        filters.add('${_formatDate(startDate.value!)} - ${_formatDate(endDate.value!)}');
      } else if (startDate.value != null) {
        filters.add('从 ${_formatDate(startDate.value!)}');
      } else if (endDate.value != null) {
        filters.add('到 ${_formatDate(endDate.value!)}');
      }
    }
    
    return filters.join(' · ');
  }
  
  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
