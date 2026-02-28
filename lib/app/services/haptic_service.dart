import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// 触觉反馈服务
/// 
/// 提供分级的触觉反馈，营造自然的交互体验
class HapticService {
  bool _isEnabled = true;
  
  bool get isEnabled => _isEnabled;
  
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }
  
  /// 轻柔的触觉反馈 - 用于日期选择、轻触操作
  Future<void> light() async {
    if (!_isEnabled) return;
    
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 10, amplitude: 50);
      } else {
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      await HapticFeedback.lightImpact();
    }
  }
  
  /// 中等触觉反馈 - 用于按钮点击、事件创建
  Future<void> medium() async {
    if (!_isEnabled) return;
    
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 15, amplitude: 80);
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }
  
  /// 强触觉反馈 - 用于删除操作、重要确认
  Future<void> heavy() async {
    if (!_isEnabled) return;
    
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 20, amplitude: 120);
      } else {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }
  
  /// 选择反馈 - 用于主题切换、选项选择
  Future<void> selection() async {
    if (!_isEnabled) return;
    
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 8, amplitude: 40);
      } else {
        await HapticFeedback.selectionClick();
      }
    } catch (e) {
      await HapticFeedback.selectionClick();
    }
  }
  
  /// 成功反馈 - 用于操作成功提示
  Future<void> success() async {
    if (!_isEnabled) return;
    
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // 两次短震动表示成功
        await Vibration.vibrate(duration: 10, amplitude: 60);
        await Future.delayed(const Duration(milliseconds: 50));
        await Vibration.vibrate(duration: 10, amplitude: 60);
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }
  
  /// 错误反馈 - 用于操作失败提示
  Future<void> error() async {
    if (!_isEnabled) return;
    
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // 长震动表示错误
        await Vibration.vibrate(duration: 30, amplitude: 100);
      } else {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }
}
