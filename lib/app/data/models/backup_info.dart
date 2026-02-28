import 'package:equatable/equatable.dart';

/// 备份信息模型
class BackupInfo extends Equatable {
  final String id;
  final String filename;
  final DateTime createdAt;
  final int eventCount;
  final int intentionCount;
  final int fileSize; // 字节

  const BackupInfo({
    required this.id,
    required this.filename,
    required this.createdAt,
    required this.eventCount,
    required this.intentionCount,
    required this.fileSize,
  });

  /// 从 JSON 创建
  factory BackupInfo.fromJson(Map<String, dynamic> json) {
    return BackupInfo(
      id: json['id'] as String,
      filename: json['filename'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      eventCount: json['eventCount'] as int,
      intentionCount: json['intentionCount'] as int,
      fileSize: json['fileSize'] as int,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'createdAt': createdAt.toIso8601String(),
      'eventCount': eventCount,
      'intentionCount': intentionCount,
      'fileSize': fileSize,
    };
  }

  /// 格式化文件大小
  String get formattedSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// 格式化创建时间
  String get formattedDate {
    return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')} '
        '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        id,
        filename,
        createdAt,
        eventCount,
        intentionCount,
        fileSize,
      ];
}
