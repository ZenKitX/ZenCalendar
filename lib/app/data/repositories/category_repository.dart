import '../models/event_category.dart';
import '../providers/local_storage_provider.dart';

/// 分类仓库
class CategoryRepository {
  final LocalStorageProvider _storage;

  CategoryRepository(this._storage);

  static const String _categoriesKey = 'custom_categories';

  /// 获取所有分类（预定义 + 自定义）
  Future<List<EventCategory>> getAllCategories() async {
    final customCategories = await getCustomCategories();
    return [
      ...EventCategory.defaultCategories,
      ...customCategories,
    ];
  }

  /// 获取自定义分类
  Future<List<EventCategory>> getCustomCategories() async {
    try {
      final data = await _storage.getData(_categoriesKey);
      if (data == null) return [];

      final list = data as List<dynamic>;
      return list
          .map((json) => EventCategory.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading custom categories: $e');
      return [];
    }
  }

  /// 添加自定义分类
  Future<void> addCategory(EventCategory category) async {
    final categories = await getCustomCategories();
    categories.add(category);
    await _saveCustomCategories(categories);
  }

  /// 更新分类
  Future<void> updateCategory(EventCategory category) async {
    final categories = await getCustomCategories();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      categories[index] = category;
      await _saveCustomCategories(categories);
    }
  }

  /// 删除分类
  Future<void> deleteCategory(String categoryId) async {
    final categories = await getCustomCategories();
    categories.removeWhere((c) => c.id == categoryId);
    await _saveCustomCategories(categories);
  }

  /// 根据 ID 获取分类
  Future<EventCategory?> getCategoryById(String categoryId) async {
    final allCategories = await getAllCategories();
    try {
      return allCategories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }

  /// 保存自定义分类
  Future<void> _saveCustomCategories(List<EventCategory> categories) async {
    final data = categories.map((c) => c.toJson()).toList();
    await _storage.saveData(_categoriesKey, data);
  }
}
