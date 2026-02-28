import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/event_model.dart';
import '../models/intention_model.dart';

/// 数据导出服务
class ExportService {
  /// 导出为 JSON
  Future<String> exportToJson(
    List<EventModel> events,
    List<IntentionModel> intentions,
  ) async {
    final data = {
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'events': events.map((e) => e.toJson()).toList(),
      'intentions': intentions.map((i) => i.toJson()).toList(),
    };

    return jsonEncode(data);
  }

  /// 导出为 CSV
  Future<String> exportToCsv(
    List<EventModel> events,
    List<IntentionModel> intentions,
  ) async {
    final buffer = StringBuffer();

    // CSV 头部
    buffer.writeln(
      '类型,ID,日期,标题,描述,开始时间,结束时间,分类ID,标签,完成状态',
    );

    // 导出事件
    for (final event in events) {
      final date = '${event.startTime.year}-${event.startTime.month.toString().padLeft(2, '0')}-${event.startTime.day.toString().padLeft(2, '0')}';
      final startTime = event.isAllDay
          ? ''
          : '${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}';
      final endTime = event.isAllDay
          ? ''
          : '${event.endTime.hour.toString().padLeft(2, '0')}:${event.endTime.minute.toString().padLeft(2, '0')}';
      final tags = event.tags.join(';');

      buffer.writeln(
        '事件,${event.id},$date,"${_escapeCsv(event.title)}","${_escapeCsv(event.description ?? '')}",$startTime,$endTime,${event.categoryId ?? ''},"$tags",',
      );
    }

    // 导出意图
    for (final intention in intentions) {
      final date = '${intention.date.year}-${intention.date.month.toString().padLeft(2, '0')}-${intention.date.day.toString().padLeft(2, '0')}';
      buffer.writeln(
        '意图,${intention.id},$date,"${_escapeCsv(intention.content)}",,,,,${intention.isCompleted}',
      );
    }

    return buffer.toString();
  }

  /// 保存到文件
  Future<File> saveToFile(String content, String filename) async {
    final directory = await _getExportDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsString(content);
    return file;
  }

  /// 获取导出目录
  Future<Directory> _getExportDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/ZenCalendar/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    return exportDir;
  }

  /// CSV 转义
  String _escapeCsv(String value) {
    return value.replaceAll('"', '""');
  }

  /// 生成导出文件名
  String generateFilename(String format) {
    final now = DateTime.now();
    final timestamp =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return 'ZenCalendar_export_$timestamp.$format';
  }
}
