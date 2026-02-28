import 'package:flutter/services.dart';

/// 音频播放服务
/// 注意：这是一个简化版本，使用系统音效
/// 完整版本需要集成 audioplayers 包
class AudioPlayerService {
  /// 播放开始铃声
  Future<void> playStartBell() async {
    try {
      await SystemSound.play(SystemSoundType.click);
      print('🔔 Played start bell');
    } catch (e) {
      print('❌ Error playing start bell: $e');
    }
  }

  /// 播放结束铃声
  Future<void> playEndBell() async {
    try {
      // 播放两次以示区别
      await SystemSound.play(SystemSoundType.click);
      await Future.delayed(const Duration(milliseconds: 200));
      await SystemSound.play(SystemSoundType.click);
      print('🔔 Played end bell');
    } catch (e) {
      print('❌ Error playing end bell: $e');
    }
  }

  /// 播放中间提示音
  Future<void> playIntervalBell() async {
    try {
      await SystemSound.play(SystemSoundType.click);
      print('🔔 Played interval bell');
    } catch (e) {
      print('❌ Error playing interval bell: $e');
    }
  }

  /// 播放错误音效
  Future<void> playError() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
      print('⚠️ Played error sound');
    } catch (e) {
      print('❌ Error playing error sound: $e');
    }
  }

  /// 播放成功音效
  Future<void> playSuccess() async {
    try {
      await SystemSound.play(SystemSoundType.click);
      print('✅ Played success sound');
    } catch (e) {
      print('❌ Error playing success sound: $e');
    }
  }

  // TODO: 在未来版本中集成 audioplayers 包
  // 以支持自定义音频文件播放
  // 
  // Future<void> playCustomSound(String assetPath) async {
  //   final player = AudioPlayer();
  //   await player.play(AssetSource(assetPath));
  // }
}
