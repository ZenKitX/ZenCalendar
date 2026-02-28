import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../models/intention_model.dart';

/// 本地存储提供者
/// 
/// 使用 SharedPreferences 进行数据持久化
class LocalStorageProvider {
  final SharedPreferences _prefs;

  LocalStorageProvider(this._prefs);

  // ==================== Events ====================

  static const String _eventsKey = 'events';

  /// 获取所有事件
  Future<List<EventModel>> getEvents() async {
    try {
      final String? eventsJson = _prefs.getString(_eventsKey);
      if (eventsJson == null || eventsJson.isEmpty) {
        return [];
      }

      final List<dynamic> eventsList = json.decode(eventsJson);
      return eventsList
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }

  /// 保存所有事件
  Future<void> saveEvents(List<EventModel> events) async {
    try {
      final String eventsJson = json.encode(
        events.map((e) => e.toJson()).toList(),
      );
      await _prefs.setString(_eventsKey, eventsJson);
    } catch (e) {
      print('Error saving events: $e');
      rethrow;
    }
  }

  /// 清除所有事件
  Future<void> clearEvents() async {
    await _prefs.remove(_eventsKey);
  }

  // ==================== Intentions ====================

  static const String _intentionsKey = 'intentions';

  /// 获取所有意图
  Future<List<IntentionModel>> getIntentions() async {
    try {
      final String? intentionsJson = _prefs.getString(_intentionsKey);
      if (intentionsJson == null || intentionsJson.isEmpty) {
        return [];
      }

      final List<dynamic> intentionsList = json.decode(intentionsJson);
      return intentionsList
          .map((i) => IntentionModel.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading intentions: $e');
      return [];
    }
  }

  /// 保存所有意图
  Future<void> saveIntentions(List<IntentionModel> intentions) async {
    try {
      final String intentionsJson = json.encode(
        intentions.map((i) => i.toJson()).toList(),
      );
      await _prefs.setString(_intentionsKey, intentionsJson);
    } catch (e) {
      print('Error saving intentions: $e');
      rethrow;
    }
  }

  /// 清除所有意图
  Future<void> clearIntentions() async {
    await _prefs.remove(_intentionsKey);
  }

  // ==================== Settings ====================

  static const String _themeKey = 'theme_mode';
  static const String _hapticKey = 'haptic_enabled';
  static const String _audioKey = 'audio_enabled';
  static const String _quotesKey = 'quotes_enabled';

  /// 获取所有设置
  Future<Map<String, dynamic>> getSettings() async {
    return {
      'themeMode': _prefs.getString('themeMode'),
      'notificationsEnabled': _prefs.getBool('notificationsEnabled'),
      'eventReminders': _prefs.getBool('eventReminders'),
      'intentionReminders': _prefs.getBool('intentionReminders'),
      'hapticEnabled': getHapticEnabled(),
      'audioEnabled': getAudioEnabled(),
      'quotesEnabled': getQuotesEnabled(),
    };
  }

  /// 保存单个设置
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  /// 获取主题模式
  ThemeMode getThemeMode() {
    final int? themeIndex = _prefs.getInt(_themeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }

  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeKey, mode.index);
  }

  /// 获取触觉反馈开关
  bool getHapticEnabled() {
    return _prefs.getBool(_hapticKey) ?? true;
  }

  /// 设置触觉反馈开关
  Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool(_hapticKey, enabled);
  }

  /// 获取音频开关
  bool getAudioEnabled() {
    return _prefs.getBool(_audioKey) ?? true;
  }

  /// 设置音频开关
  Future<void> setAudioEnabled(bool enabled) async {
    await _prefs.setBool(_audioKey, enabled);
  }

  /// 获取禅语开关
  bool getQuotesEnabled() {
    return _prefs.getBool(_quotesKey) ?? true;
  }

  /// 设置禅语开关
  Future<void> setQuotesEnabled(bool enabled) async {
    await _prefs.setBool(_quotesKey, enabled);
  }

  // ==================== 工具方法 ====================

  /// 清除所有数据
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  /// 获取所有键
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  /// 检查键是否存在
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// 获取通用数据（用于分类等）
  Future<dynamic> getData(String key) async {
    final String? jsonStr = _prefs.getString(key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return null;
    }
    try {
      return json.decode(jsonStr);
    } catch (e) {
      return null;
    }
  }

  /// 保存通用数据（用于分类等）
  Future<void> saveData(String key, dynamic data) async {
    try {
      final String jsonStr = json.encode(data);
      await _prefs.setString(key, jsonStr);
    } catch (e) {
      rethrow;
    }
  }
}
