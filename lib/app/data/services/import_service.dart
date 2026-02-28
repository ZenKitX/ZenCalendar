import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import '../models/event_model.dart';
import '../models/intention_model.dart';

/// 导入结果
class ImportResult {
  final List<EventModel> events;
  final List<IntentionModel> intentions;
  final List<String> errors;

  ImportResult({
    required this.events,
    required this.intentions,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => errors.isEmpty;
}

/// 数据导入服务
class ImportService {
  /// 从 JSON 导入
  Future<ImportResult> importFromJson(String filePath) async {
    final errors = <String>[];
    final events = <EventModel>[];
    final intentions = <IntentionModel>[];

    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      // 验证版本
      if (data['version'] != '1.0') {
        errors.add('不支持的文件版本: ${data['version']}');
        return ImportResult(
          events: events,
          intentions: intentions,
          errors: errors,
        );
      }

      // 导入事件
      if (data['events'] != null) {
        final eventList = data['events'] as List<dynamic>;
        for (var i = 0; i < eventList.length; i++) {
          try {
            final event = EventModel.fromJson(
              eventList[i] as Map<String, dynamic>,
            );
            events.add(event);
          } catch (e) {
            errors.add('事件 #${i + 1} 解析失败: $e');
          }
        }
      }

      // 导入意图
      if (data['intentions'] != null) {
        final intentionList = data['intentions'] as List<dynamic>;
        for (var i = 0; i < intentionList.length; i++) {
          try {
            final intention = IntentionModel.fromJson(
              intentionList[i] as Map<String, dynamic>,
            );
            intentions.add(intention);
          } catch (e) {
            errors.add('意图 #${i + 1} 解析失败: $e');
          }
        }
      }
    } catch (e) {
      errors.add('文件读取失败: $e');
    }

    return ImportResult(
      events: events,
      intentions: intentions,
      errors: errors,
    );
  }

  /// 从 CSV 导入
  Future<ImportResult> importFromCsv(String filePath) async {
    final errors = <String>[];
    final events = <EventModel>[];
    final intentions = <IntentionModel>[];

    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final rows = const CsvToListConverter().convert(content);

      // 跳过头部
      for (var i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty) continue;

          final type = row[0].toString();
          if (type == '事件') {
            events.add(_parseEventFromCsv(row));
          } else if (type == '意图') {
            intentions.add(_parseIntentionFromCsv(row));
          }
        } catch (e) {
          errors.add('行 #${i + 1} 解析失败: $e');
        }
      }
    } catch (e) {
      errors.add('CSV 文件读取失败: $e');
    }

    return ImportResult(
      events: events,
      intentions: intentions,
      errors: errors,
    );
  }

  /// 从 CSV 行解析事件
  EventModel _parseEventFromCsv(List<dynamic> row) {
    final id = row[1].toString();
    final date = DateTime.parse(row[2].toString());
    final title = row[3].toString();
    final description = row[4].toString();
    final startTimeStr = row[5].toString();
    final endTimeStr = row[6].toString();
    final categoryId = row[7].toString().isEmpty ? null : row[7].toString();
    final tags = row[8].toString().isEmpty
        ? <String>[]
        : row[8].toString().split(';');

    DateTime startTime;
    DateTime endTime;

    if (startTimeStr.isEmpty) {
      // 全天事件
      startTime = DateTime(date.year, date.month, date.day);
      endTime = DateTime(date.year, date.month, date.day, 23, 59);
    } else {
      final startParts = startTimeStr.split(':');
      final endParts = endTimeStr.split(':');
      startTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );
      endTime = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );
    }

    return EventModel.create(
      title: title,
      description: description.isEmpty ? null : description,
      startTime: startTime,
      endTime: endTime,
      isAllDay: startTimeStr.isEmpty,
      categoryId: categoryId,
      tags: tags,
    ).copyWith(id: id);
  }

  /// 从 CSV 行解析意图
  IntentionModel _parseIntentionFromCsv(List<dynamic> row) {
    final id = row[1].toString();
    final date = DateTime.parse(row[2].toString());
    final content = row[3].toString();
    final isCompleted = row[9].toString() == 'true';

    return IntentionModel.create(
      date: date,
      content: content,
    ).copyWith(
      id: id,
      isCompleted: isCompleted,
    );
  }
}
