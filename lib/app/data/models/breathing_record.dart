/// 呼吸练习记录模型
class BreathingRecord {
  final String id;
  final DateTime date;
  final String patternId;
  final String patternName;
  final int cycles;
  final int durationSeconds;
  
  BreathingRecord({
    required this.id,
    required this.date,
    required this.patternId,
    required this.patternName,
    required this.cycles,
    required this.durationSeconds,
  });
  
  /// 格式化时长显示
  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0) {
      return '$minutes 分 $seconds 秒';
    }
    return '$seconds 秒';
  }
  
  /// JSON 序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'patternId': patternId,
      'patternName': patternName,
      'cycles': cycles,
      'durationSeconds': durationSeconds,
    };
  }
  
  /// JSON 反序列化
  factory BreathingRecord.fromJson(Map<String, dynamic> json) {
    return BreathingRecord(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      patternId: json['patternId'] as String,
      patternName: json['patternName'] as String,
      cycles: json['cycles'] as int,
      durationSeconds: json['durationSeconds'] as int,
    );
  }
  
  @override
  String toString() {
    return 'BreathingRecord(id: $id, pattern: $patternName, cycles: $cycles, duration: ${formattedDuration})';
  }
}
