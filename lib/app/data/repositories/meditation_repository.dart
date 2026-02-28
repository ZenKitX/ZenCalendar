import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meditation_record.dart';

/// 冥想记录仓库
class MeditationRepository {
  static const String _keyMeditationRecords = 'meditation_records';
  final SharedPreferences _prefs;

  MeditationRepository(this._prefs);

  /// 获取所有冥想记录
  Future<List<MeditationRecord>> getAll() async {
    try {
      final jsonString = _prefs.getString(_keyMeditationRecords);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => MeditationRecord.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error loading meditation records: $e');
      return [];
    }
  }

  /// 根据 ID 获取冥想记录
  Future<MeditationRecord?> getById(String id) async {
    final records = await getAll();
    try {
      return records.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 创建冥想记录
  Future<void> create(MeditationRecord record) async {
    final records = await getAll();
    records.add(record);
    await _saveAll(records);
    print('✅ Created meditation record: ${record.id}');
  }

  /// 更新冥想记录
  Future<void> update(MeditationRecord record) async {
    final records = await getAll();
    final index = records.indexWhere((r) => r.id == record.id);
    
    if (index != -1) {
      records[index] = record;
      await _saveAll(records);
      print('✅ Updated meditation record: ${record.id}');
    }
  }

  /// 删除冥想记录
  Future<void> delete(String id) async {
    final records = await getAll();
    records.removeWhere((record) => record.id == id);
    await _saveAll(records);
    print('✅ Deleted meditation record: $id');
  }

  /// 获取指定日期范围的记录
  Future<List<MeditationRecord>> getByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final records = await getAll();
    return records.where((record) {
      return record.startTime.isAfter(startDate) &&
          record.startTime.isBefore(endDate);
    }).toList();
  }

  /// 获取今天的记录
  Future<List<MeditationRecord>> getToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getByDateRange(startOfDay, endOfDay);
  }

  /// 获取本周的记录
  Future<List<MeditationRecord>> getThisWeek() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7));
    
    return getByDateRange(startOfWeekDay, endOfWeek);
  }

  /// 获取本月的记录
  Future<List<MeditationRecord>> getThisMonth() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    
    return getByDateRange(startOfMonth, endOfMonth);
  }

  /// 获取总冥想时长（分钟）
  Future<int> getTotalDuration() async {
    final records = await getAll();
    return records.fold<int>(
      0,
      (sum, record) => sum + record.durationMinutes,
    );
  }

  /// 获取总冥想次数
  Future<int> getTotalCount() async {
    final records = await getAll();
    return records.length;
  }

  /// 获取连续打卡天数
  Future<int> getStreakDays() async {
    final records = await getAll();
    if (records.isEmpty) return 0;

    // 按日期分组
    final Map<String, List<MeditationRecord>> recordsByDate = {};
    for (final record in records) {
      final dateKey = '${record.startTime.year}-${record.startTime.month}-${record.startTime.day}';
      recordsByDate.putIfAbsent(dateKey, () => []).add(record);
    }

    // 获取所有日期并排序
    final dates = recordsByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 降序排列

    if (dates.isEmpty) return 0;

    // 检查今天是否有记录
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';
    
    if (!dates.contains(today)) return 0;

    // 计算连续天数
    int streak = 1;
    DateTime currentDate = now;
    
    for (int i = 1; i < dates.length; i++) {
      final previousDate = currentDate.subtract(const Duration(days: 1));
      final previousDateKey = '${previousDate.year}-${previousDate.month}-${previousDate.day}';
      
      if (dates[i] == previousDateKey) {
        streak++;
        currentDate = previousDate;
      } else {
        break;
      }
    }

    return streak;
  }

  /// 清除所有记录
  Future<void> clearAll() async {
    await _prefs.remove(_keyMeditationRecords);
    print('✅ Cleared all meditation records');
  }

  /// 保存所有记录
  Future<void> _saveAll(List<MeditationRecord> records) async {
    final jsonList = records.map((record) => record.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _prefs.setString(_keyMeditationRecords, jsonString);
  }
}
