/// 呼吸模式模型
class BreathingPattern {
  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int pauseSeconds;
  
  const BreathingPattern({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.pauseSeconds,
  });
  
  /// 一个完整呼吸周期的总时长（秒）
  int get cycleDuration => inhaleSeconds + holdSeconds + exhaleSeconds + pauseSeconds;
  
  /// 预设呼吸模式
  static const List<BreathingPattern> presets = [
    BreathingPattern(
      id: '4-7-8',
      name: '4-7-8 呼吸法',
      description: '放松身心，改善睡眠',
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
      pauseSeconds: 0,
    ),
    BreathingPattern(
      id: 'box',
      name: '方块呼吸',
      description: '平衡身心，提升专注',
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      pauseSeconds: 4,
    ),
    BreathingPattern(
      id: 'deep',
      name: '深呼吸',
      description: '缓解压力，恢复能量',
      inhaleSeconds: 6,
      holdSeconds: 0,
      exhaleSeconds: 6,
      pauseSeconds: 0,
    ),
    BreathingPattern(
      id: 'calm',
      name: '平静呼吸',
      description: '快速放松，减轻焦虑',
      inhaleSeconds: 5,
      holdSeconds: 5,
      exhaleSeconds: 5,
      pauseSeconds: 0,
    ),
  ];
  
  /// 根据 ID 获取预设模式
  static BreathingPattern? getPresetById(String id) {
    try {
      return presets.firstWhere((pattern) => pattern.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// JSON 序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'inhaleSeconds': inhaleSeconds,
      'holdSeconds': holdSeconds,
      'exhaleSeconds': exhaleSeconds,
      'pauseSeconds': pauseSeconds,
    };
  }
  
  /// JSON 反序列化
  factory BreathingPattern.fromJson(Map<String, dynamic> json) {
    return BreathingPattern(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      inhaleSeconds: json['inhaleSeconds'] as int,
      holdSeconds: json['holdSeconds'] as int,
      exhaleSeconds: json['exhaleSeconds'] as int,
      pauseSeconds: json['pauseSeconds'] as int,
    );
  }
  
  @override
  String toString() {
    return 'BreathingPattern(id: $id, name: $name, cycle: ${cycleDuration}s)';
  }
}
