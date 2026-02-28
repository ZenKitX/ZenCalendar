import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/backup_info.dart';
import '../models/event_model.dart';
import '../models/intention_model.dart';

/// 备份服务
class BackupService {
  /// 创建备份
  Future<BackupInfo> createBackup(
    List<EventModel> events,
    List<IntentionModel> intentions,
  ) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final filename = _generateFilename(now);

    // 准备备份数据
    final data = {
      'version': '1.0',
      'backupDate': now.toIso8601String(),
      'events': events.map((e) => e.toJson()).toList(),
      'intentions': intentions.map((i) => i.toJson()).toList(),
    };

    // 保存到文件
    final directory = await _getBackupDirectory();
    final file = File('${directory.path}/$filename');
    final content = jsonEncode(data);
    await file.writeAsString(content);

    // 创建备份信息
    final backupInfo = BackupInfo(
      id: id,
      filename: filename,
      createdAt: now,
      eventCount: events.length,
      intentionCount: intentions.length,
      fileSize: content.length,
    );

    // 保存备份信息索引
    await _saveBackupInfo(backupInfo);

    return backupInfo;
  }

  /// 列出所有备份
  Future<List<BackupInfo>> listBackups() async {
    try {
      final directory = await _getBackupDirectory();
      final indexFile = File('${directory.path}/backups_index.json');

      if (!await indexFile.exists()) {
        return [];
      }

      final content = await indexFile.readAsString();
      final data = jsonDecode(content) as List<dynamic>;
      return data
          .map((json) => BackupInfo.fromJson(json as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Error listing backups: $e');
      return [];
    }
  }

  /// 恢复备份
  Future<Map<String, dynamic>> restoreBackup(String filename) async {
    try {
      final directory = await _getBackupDirectory();
      final file = File('${directory.path}/$filename');

      if (!await file.exists()) {
        throw Exception('备份文件不存在');
      }

      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      return data;
    } catch (e) {
      throw Exception('恢复备份失败: $e');
    }
  }

  /// 删除备份
  Future<void> deleteBackup(String filename) async {
    try {
      final directory = await _getBackupDirectory();
      final file = File('${directory.path}/$filename');

      if (await file.exists()) {
        await file.delete();
      }

      // 更新索引
      final backups = await listBackups();
      backups.removeWhere((b) => b.filename == filename);
      await _saveBackupIndex(backups);
    } catch (e) {
      print('Error deleting backup: $e');
    }
  }

  /// 清理旧备份（保留最近 N 个）
  Future<void> cleanOldBackups({int keepCount = 7}) async {
    try {
      final backups = await listBackups();
      if (backups.length <= keepCount) return;

      final toDelete = backups.skip(keepCount).toList();
      for (final backup in toDelete) {
        await deleteBackup(backup.filename);
      }
    } catch (e) {
      print('Error cleaning old backups: $e');
    }
  }

  /// 获取备份目录
  Future<Directory> _getBackupDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/ZenCalendar/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  /// 生成备份文件名
  String _generateFilename(DateTime date) {
    final timestamp =
        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}_'
        '${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}${date.second.toString().padLeft(2, '0')}';
    return 'ZenCalendar_backup_$timestamp.json';
  }

  /// 保存备份信息到索引
  Future<void> _saveBackupInfo(BackupInfo info) async {
    final backups = await listBackups();
    backups.add(info);
    await _saveBackupIndex(backups);
  }

  /// 保存备份索引
  Future<void> _saveBackupIndex(List<BackupInfo> backups) async {
    try {
      final directory = await _getBackupDirectory();
      final indexFile = File('${directory.path}/backups_index.json');
      final data = backups.map((b) => b.toJson()).toList();
      await indexFile.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error saving backup index: $e');
    }
  }
}
