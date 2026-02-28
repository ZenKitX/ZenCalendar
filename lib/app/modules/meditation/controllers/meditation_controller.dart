import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/meditation_record.dart';
import '../../../data/repositories/meditation_repository.dart';
import '../../../data/services/audio_player_service.dart';
import '../../../services/haptic_service.dart';

/// 冥想状态
enum MeditationState {
  idle,      // 空闲
  running,   // 运行中
  paused,    // 暂停
  completed, // 完成
}

/// 冥想控制器
class MeditationController extends GetxController {
  // 依赖注入
  final MeditationRepository _repository = Get.find<MeditationRepository>();
  final AudioPlayerService _audioService = Get.find<AudioPlayerService>();
  final HapticService _hapticService = Get.find<HapticService>();

  // 响应式状态
  final meditationState = MeditationState.idle.obs;
  final selectedDuration = 10.obs; // 默认 10 分钟
  final remainingSeconds = 0.obs;
  final elapsedSeconds = 0.obs;
  final records = <MeditationRecord>[].obs;
  final isLoading = false.obs;

  // 统计数据
  final totalDuration = 0.obs;
  final totalCount = 0.obs;
  final streakDays = 0.obs;

  // 计时器
  Timer? _timer;
  DateTime? _startTime;

  // 预设时长选项（分钟）
  final List<int> presetDurations = [5, 10, 15, 20, 30];

  @override
  void onInit() {
    super.onInit();
    print('MeditationController initialized');
    loadRecords();
    loadStats();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  /// 加载冥想记录
  Future<void> loadRecords() async {
    try {
      isLoading.value = true;
      records.value = await _repository.getAll();
      // 按时间倒序排列
      records.sort((a, b) => b.startTime.compareTo(a.startTime));
      print('✅ Loaded ${records.length} meditation records');
    } catch (e) {
      print('❌ Error loading meditation records: $e');
      Get.snackbar(
        '错误',
        '加载冥想记录失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载统计数据
  Future<void> loadStats() async {
    try {
      totalDuration.value = await _repository.getTotalDuration();
      totalCount.value = await _repository.getTotalCount();
      streakDays.value = await _repository.getStreakDays();
      print('✅ Loaded meditation stats');
    } catch (e) {
      print('❌ Error loading meditation stats: $e');
    }
  }

  /// 选择时长
  void selectDuration(int minutes) {
    if (meditationState.value != MeditationState.idle) return;
    
    selectedDuration.value = minutes;
    _hapticService.light();
  }

  /// 开始冥想
  void startMeditation() {
    if (meditationState.value != MeditationState.idle) return;

    meditationState.value = MeditationState.running;
    remainingSeconds.value = selectedDuration.value * 60;
    elapsedSeconds.value = 0;
    _startTime = DateTime.now();

    // 播放开始铃声
    _audioService.playStartBell();
    _hapticService.medium();

    // 启动计时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        elapsedSeconds.value++;
      } else {
        _completeMeditation();
      }
    });

    print('🧘 Started meditation: ${selectedDuration.value} minutes');
  }

  /// 暂停冥想
  void pauseMeditation() {
    if (meditationState.value != MeditationState.running) return;

    meditationState.value = MeditationState.paused;
    _timer?.cancel();
    _hapticService.light();

    print('⏸️ Paused meditation');
  }

  /// 恢复冥想
  void resumeMeditation() {
    if (meditationState.value != MeditationState.paused) return;

    meditationState.value = MeditationState.running;
    _hapticService.light();

    // 重新启动计时器
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
        elapsedSeconds.value++;
      } else {
        _completeMeditation();
      }
    });

    print('▶️ Resumed meditation');
  }

  /// 停止冥想
  void stopMeditation() {
    if (meditationState.value == MeditationState.idle) return;

    _timer?.cancel();
    
    // 如果冥想时间超过 1 分钟，保存记录
    if (elapsedSeconds.value >= 60) {
      _saveMeditationRecord();
    }

    _resetState();
    _hapticService.medium();

    print('⏹️ Stopped meditation');
  }

  /// 完成冥想
  void _completeMeditation() {
    _timer?.cancel();
    meditationState.value = MeditationState.completed;

    // 播放结束铃声
    _audioService.playEndBell();
    _hapticService.success();

    // 保存记录
    _saveMeditationRecord();

    // 显示完成提示
    Get.snackbar(
      '完成',
      '恭喜！你完成了 ${selectedDuration.value} 分钟的冥想',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    print('✅ Completed meditation: ${selectedDuration.value} minutes');

    // 3 秒后重置状态
    Future.delayed(const Duration(seconds: 3), () {
      _resetState();
    });
  }

  /// 保存冥想记录
  Future<void> _saveMeditationRecord() async {
    if (_startTime == null) return;

    try {
      final endTime = DateTime.now();
      final record = MeditationRecord.create(
        startTime: _startTime!,
        endTime: endTime,
      );

      await _repository.create(record);
      await loadRecords();
      await loadStats();

      print('✅ Saved meditation record');
    } catch (e) {
      print('❌ Error saving meditation record: $e');
    }
  }

  /// 重置状态
  void _resetState() {
    meditationState.value = MeditationState.idle;
    remainingSeconds.value = 0;
    elapsedSeconds.value = 0;
    _startTime = null;
  }

  /// 删除记录
  Future<void> deleteRecord(String id) async {
    try {
      await _repository.delete(id);
      await loadRecords();
      await loadStats();

      _hapticService.success();
      Get.snackbar(
        '成功',
        '记录已删除',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error deleting meditation record: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '删除记录失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// 获取今天的记录
  Future<List<MeditationRecord>> getTodayRecords() async {
    return await _repository.getToday();
  }

  /// 获取本周的记录
  Future<List<MeditationRecord>> getThisWeekRecords() async {
    return await _repository.getThisWeek();
  }

  /// 获取本月的记录
  Future<List<MeditationRecord>> getThisMonthRecords() async {
    return await _repository.getThisMonth();
  }

  /// 格式化剩余时间
  String get formattedRemainingTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 获取进度百分比
  double get progress {
    if (selectedDuration.value == 0) return 0;
    final totalSeconds = selectedDuration.value * 60;
    return elapsedSeconds.value / totalSeconds;
  }

  /// 格式化总时长
  String get formattedTotalDuration {
    if (totalDuration.value < 60) {
      return '${totalDuration.value} 分钟';
    } else {
      final hours = totalDuration.value ~/ 60;
      final minutes = totalDuration.value % 60;
      if (minutes == 0) {
        return '$hours 小时';
      }
      return '$hours 小时 $minutes 分钟';
    }
  }
}
