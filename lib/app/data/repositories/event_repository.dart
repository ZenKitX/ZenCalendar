import '../models/event_model.dart';
import '../providers/local_storage_provider.dart';

/// 事件仓库
/// 
/// 负责事件数据的 CRUD 操作
class EventRepository {
  final LocalStorageProvider _storageProvider;

  EventRepository(this._storageProvider);

  /// 获取所有事件
  Future<List<EventModel>> getAll() async {
    return await _storageProvider.getEvents();
  }

  /// 根据日期获取事件
  Future<List<EventModel>> getByDate(DateTime date) async {
    final events = await getAll();
    return events.where((event) => event.isOnDate(date)).toList();
  }

  /// 根据日期范围获取事件
  Future<List<EventModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final events = await getAll();
    return events.where((event) {
      return event.startTime.isAfter(startDate) &&
          event.startTime.isBefore(endDate);
    }).toList();
  }

  /// 根据月份获取事件
  Future<List<EventModel>> getByMonth(int year, int month) async {
    final events = await getAll();
    return events.where((event) {
      return event.startTime.year == year && event.startTime.month == month;
    }).toList();
  }

  /// 根据 ID 获取事件
  Future<EventModel?> getById(String id) async {
    final events = await getAll();
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 创建事件
  Future<void> create(EventModel event) async {
    final events = await getAll();
    events.add(event);
    await _storageProvider.saveEvents(events);
  }

  /// 更新事件
  Future<void> update(EventModel event) async {
    final events = await getAll();
    final index = events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      events[index] = event.copyWith(updatedAt: DateTime.now());
      await _storageProvider.saveEvents(events);
    } else {
      throw Exception('Event not found: ${event.id}');
    }
  }

  /// 删除事件
  Future<void> delete(String id) async {
    final events = await getAll();
    events.removeWhere((event) => event.id == id);
    await _storageProvider.saveEvents(events);
  }

  /// 批量删除事件
  Future<void> deleteMultiple(List<String> ids) async {
    final events = await getAll();
    events.removeWhere((event) => ids.contains(event.id));
    await _storageProvider.saveEvents(events);
  }

  /// 清除所有事件
  Future<void> clear() async {
    await _storageProvider.clearEvents();
  }

  /// 获取事件数量
  Future<int> count() async {
    final events = await getAll();
    return events.length;
  }

  /// 搜索事件
  Future<List<EventModel>> search(String query) async {
    if (query.isEmpty) return [];

    final events = await getAll();
    final lowerQuery = query.toLowerCase();

    return events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
          (event.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// 获取即将到来的事件
  Future<List<EventModel>> getUpcoming({int limit = 10}) async {
    final now = DateTime.now();
    final events = await getAll();

    final upcomingEvents = events
        .where((event) => event.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return upcomingEvents.take(limit).toList();
  }

  /// 获取过去的事件
  Future<List<EventModel>> getPast({int limit = 10}) async {
    final now = DateTime.now();
    final events = await getAll();

    final pastEvents = events
        .where((event) => event.endTime.isBefore(now))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    return pastEvents.take(limit).toList();
  }
}
