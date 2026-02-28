import '../models/intention_model.dart';
import '../providers/local_storage_provider.dart';

/// 意图仓库
/// 
/// 负责每日意图数据的 CRUD 操作
class IntentionRepository {
  final LocalStorageProvider _storageProvider;

  IntentionRepository(this._storageProvider);

  /// 获取所有意图
  Future<List<IntentionModel>> getAll() async {
    return await _storageProvider.getIntentions();
  }

  /// 根据日期获取意图
  Future<IntentionModel?> getByDate(DateTime date) async {
    final intentions = await getAll();
    final targetDate = DateTime(date.year, date.month, date.day);

    try {
      return intentions.firstWhere((intention) {
        final intentionDate = DateTime(
          intention.date.year,
          intention.date.month,
          intention.date.day,
        );
        return intentionDate.isAtSameMomentAs(targetDate);
      });
    } catch (e) {
      return null;
    }
  }

  /// 获取今天的意图
  Future<IntentionModel?> getToday() async {
    return await getByDate(DateTime.now());
  }

  /// 根据 ID 获取意图
  Future<IntentionModel?> getById(String id) async {
    final intentions = await getAll();
    try {
      return intentions.firstWhere((intention) => intention.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 创建意图
  Future<void> create(IntentionModel intention) async {
    // 检查当天是否已有意图
    final existing = await getByDate(intention.date);
    if (existing != null) {
      throw Exception('Intention already exists for this date');
    }

    final intentions = await getAll();
    intentions.add(intention);
    await _storageProvider.saveIntentions(intentions);
  }

  /// 更新意图
  Future<void> update(IntentionModel intention) async {
    final intentions = await getAll();
    final index = intentions.indexWhere((i) => i.id == intention.id);
    if (index != -1) {
      intentions[index] = intention;
      await _storageProvider.saveIntentions(intentions);
    } else {
      throw Exception('Intention not found: ${intention.id}');
    }
  }

  /// 删除意图
  Future<void> delete(String id) async {
    final intentions = await getAll();
    intentions.removeWhere((intention) => intention.id == id);
    await _storageProvider.saveIntentions(intentions);
  }

  /// 清除所有意图
  Future<void> clear() async {
    await _storageProvider.clearIntentions();
  }

  /// 标记意图为完成
  Future<void> markAsCompleted(String id) async {
    final intention = await getById(id);
    if (intention != null) {
      await update(intention.markAsCompleted());
    }
  }

  /// 标记意图为未完成
  Future<void> markAsIncomplete(String id) async {
    final intention = await getById(id);
    if (intention != null) {
      await update(intention.markAsIncomplete());
    }
  }

  /// 获取已完成的意图
  Future<List<IntentionModel>> getCompleted() async {
    final intentions = await getAll();
    return intentions.where((i) => i.isCompleted).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 获取未完成的意图
  Future<List<IntentionModel>> getIncomplete() async {
    final intentions = await getAll();
    return intentions.where((i) => !i.isCompleted).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 获取过期的意图
  Future<List<IntentionModel>> getExpired() async {
    final intentions = await getAll();
    return intentions.where((i) => i.isExpired && !i.isCompleted).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 获取最近的意图
  Future<List<IntentionModel>> getRecent({int limit = 7}) async {
    final intentions = await getAll();
    final sorted = intentions..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  /// 获取意图统计
  Future<Map<String, int>> getStatistics() async {
    final intentions = await getAll();
    return {
      'total': intentions.length,
      'completed': intentions.where((i) => i.isCompleted).length,
      'incomplete': intentions.where((i) => !i.isCompleted).length,
      'expired': intentions.where((i) => i.isExpired && !i.isCompleted).length,
    };
  }

  /// 获取完成率
  Future<double> getCompletionRate() async {
    final intentions = await getAll();
    if (intentions.isEmpty) return 0.0;

    final completed = intentions.where((i) => i.isCompleted).length;
    return completed / intentions.length;
  }

  /// 获取所有意图（别名方法）
  Future<List<IntentionModel>> getAllIntentions() async {
    return await getAll();
  }

  /// 创建意图（别名方法）
  Future<void> createIntention(IntentionModel intention) async {
    return await create(intention);
  }
}
