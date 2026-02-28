import '../models/event_model.dart';
import '../providers/local_storage_provider.dart';
import '../services/recurrence_service.dart';

/// 事件仓库
/// 
/// 负责事件数据的 CRUD 操作，包括重复事件的处理
class EventRepository {
  final LocalStorageProvider _storageProvider;
  final RecurrenceService _recurrenceService;

  EventRepository(this._storageProvider, this._recurrenceService);

  /// 获取所有事件（包括重复事件实例）
  Future<List<EventModel>> getAll() async {
    final masterEvents = await _storageProvider.getEvents();
    final allEvents = <EventModel>[];
    
    // 添加所有主事件（非重复事件实例）
    allEvents.addAll(masterEvents.where((e) => !e.isRecurringInstance));
    
    // 为有重复规则的事件生成实例
    final now = DateTime.now();
    final rangeStart = now.subtract(const Duration(days: 30)); // 过去30天
    final rangeEnd = now.add(const Duration(days: 365)); // 未来1年
    
    for (final event in masterEvents) {
      if (event.hasRecurrence && !event.isRecurringInstance) {
        final instances = _recurrenceService.generateRecurringInstances(
          event,
          rangeStart,
          rangeEnd,
        );
        allEvents.addAll(instances);
      }
    }
    
    return allEvents;
  }

  /// 获取主事件（不包括重复事件实例）
  Future<List<EventModel>> getMasterEvents() async {
    final events = await _storageProvider.getEvents();
    return events.where((e) => !e.isRecurringInstance).toList();
  }

  /// 根据日期获取事件（包括重复事件实例）
  Future<List<EventModel>> getByDate(DateTime date) async {
    final events = await getAll();
    return events.where((event) => event.isOnDate(date)).toList();
  }

  /// 根据日期范围获取事件（包括重复事件实例）
  Future<List<EventModel>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final masterEvents = await getMasterEvents();
    final allEvents = <EventModel>[];
    
    // 添加非重复事件
    allEvents.addAll(masterEvents.where((event) => 
        !event.hasRecurrence &&
        event.startTime.isAfter(startDate) &&
        event.startTime.isBefore(endDate)));
    
    // 为重复事件生成指定范围内的实例
    for (final event in masterEvents) {
      if (event.hasRecurrence) {
        final instances = _recurrenceService.generateRecurringInstances(
          event,
          startDate,
          endDate,
        );
        allEvents.addAll(instances);
      }
    }
    
    return allEvents;
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
    final events = await getMasterEvents();
    events.add(event);
    await _storageProvider.saveEvents(events);
  }

  /// 更新事件
  Future<void> update(EventModel event) async {
    final events = await getMasterEvents();
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
    final events = await getMasterEvents();
    final eventToDelete = events.firstWhere((e) => e.id == id, orElse: () => throw Exception('Event not found'));
    
    if (eventToDelete.isRecurringInstance && eventToDelete.originalEventId != null) {
      // 如果删除的是重复事件实例，添加到例外列表
      await _addRecurrenceException(eventToDelete.originalEventId!, eventToDelete.startTime);
    } else {
      // 删除主事件
      events.removeWhere((event) => event.id == id);
      await _storageProvider.saveEvents(events);
    }
  }

  /// 删除重复事件系列
  Future<void> deleteRecurringSeries(String masterEventId) async {
    final events = await getMasterEvents();
    events.removeWhere((event) => event.id == masterEventId);
    await _storageProvider.saveEvents(events);
  }

  /// 添加重复事件例外
  Future<void> _addRecurrenceException(String masterEventId, DateTime exceptionDate) async {
    final events = await getMasterEvents();
    final index = events.indexWhere((e) => e.id == masterEventId);
    
    if (index != -1) {
      final masterEvent = events[index];
      if (masterEvent.recurrenceRule != null) {
        final updatedRule = _recurrenceService.addException(
          masterEvent.recurrenceRule!,
          exceptionDate,
        );
        
        events[index] = masterEvent.copyWith(
          recurrenceRule: updatedRule,
          updatedAt: DateTime.now(),
        );
        
        await _storageProvider.saveEvents(events);
      }
    }
  }

  /// 批量删除事件
  Future<void> deleteMultiple(List<String> ids) async {
    final events = await getMasterEvents();
    events.removeWhere((event) => ids.contains(event.id));
    await _storageProvider.saveEvents(events);
  }

  /// 清除所有事件
  Future<void> clear() async {
    await _storageProvider.clearEvents();
  }

  /// 搜索事件（包括重复事件实例）
  Future<List<EventModel>> search(String query) async {
    if (query.isEmpty) return [];

    final events = await getAll();
    final lowerQuery = query.toLowerCase();

    return events.where((event) {
      return event.title.toLowerCase().contains(lowerQuery) ||
          (event.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// 获取即将到来的事件（包括重复事件实例）
  Future<List<EventModel>> getUpcoming({int limit = 10}) async {
    final now = DateTime.now();
    final events = await getAll();

    final upcomingEvents = events
        .where((event) => event.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return upcomingEvents.take(limit).toList();
  }

  /// 获取过去的事件（包括重复事件实例）
  Future<List<EventModel>> getPast({int limit = 10}) async {
    final now = DateTime.now();
    final events = await getAll();

    final pastEvents = events
        .where((event) => event.endTime.isBefore(now))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    return pastEvents.take(limit).toList();
  }

  /// 获取所有事件（别名方法）
  Future<List<EventModel>> getAllEvents() async {
    return await getAll();
  }

  /// 创建事件（别名方法）
  Future<void> createEvent(EventModel event) async {
    return await create(event);
  }

  /// 检查重复事件是否在指定范围内有实例
  Future<bool> hasRecurringInstancesInRange(
    String masterEventId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final masterEvent = await getById(masterEventId);
    if (masterEvent == null || !masterEvent.hasRecurrence) {
      return false;
    }

    return _recurrenceService.hasInstancesInRange(masterEvent, startDate, endDate);
  }

  /// 获取重复事件的下 N 个实例
  Future<List<EventModel>> getNextRecurringInstances(
    String masterEventId,
    int count,
  ) async {
    final masterEvent = await getById(masterEventId);
    if (masterEvent == null || !masterEvent.hasRecurrence) {
      return [];
    }

    return _recurrenceService.getNextInstances(masterEvent, count);
  }
}
