import 'package:get/get.dart';
import '../../../data/models/intention_model.dart';
import '../../../data/models/zen_quote_model.dart';
import '../../../data/repositories/intention_repository.dart';
import '../../../data/repositories/quote_repository.dart';
import '../../../services/haptic_service.dart';

/// Intention 控制器
class IntentionController extends GetxController {
  final IntentionRepository _intentionRepository = Get.find<IntentionRepository>();
  final QuoteRepository _quoteRepository = Get.find<QuoteRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 响应式状态
  final todayIntention = Rx<IntentionModel?>(null);
  final allIntentions = <IntentionModel>[].obs;
  final dailyQuote = Rx<ZenQuoteModel?>(null);
  final isLoading = false.obs;
  final selectedDate = DateTime.now().obs;
  
  @override
  void onInit() {
    super.onInit();
    print('IntentionController initialized');
    loadTodayIntention();
    loadDailyQuote();
    loadAllIntentions();
  }
  
  /// 加载今天的意图
  Future<void> loadTodayIntention() async {
    try {
      isLoading.value = true;
      todayIntention.value = await _intentionRepository.getToday();
      print('✅ Loaded today intention: ${todayIntention.value?.text ?? "none"}');
    } catch (e) {
      print('❌ Error loading today intention: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 加载所有意图
  Future<void> loadAllIntentions() async {
    try {
      allIntentions.value = await _intentionRepository.getAll();
      // 按日期倒序排列
      allIntentions.sort((a, b) => b.date.compareTo(a.date));
      print('✅ Loaded ${allIntentions.length} intentions');
    } catch (e) {
      print('❌ Error loading intentions: $e');
    }
  }
  
  /// 加载每日禅语
  void loadDailyQuote() {
    dailyQuote.value = _quoteRepository.getDailyQuote();
  }
  
  /// 创建今天的意图
  Future<void> createTodayIntention(String text) async {
    if (text.trim().isEmpty) {
      _hapticService.error();
      Get.snackbar(
        '验证失败',
        '请输入意图内容',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final intention = IntentionModel.create(
        text: text.trim(),
        date: DateTime.now(),
      );
      
      await _intentionRepository.create(intention);
      await loadTodayIntention();
      await loadAllIntentions();
      
      _hapticService.success();
      Get.back();
      
      Get.snackbar(
        '成功',
        '今日意图已设定',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error creating intention: $e');
      _hapticService.error();
      
      if (e.toString().contains('already exists')) {
        Get.snackbar(
          '提示',
          '今天已经设定过意图了',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          '错误',
          '创建意图失败',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  
  /// 更新意图
  Future<void> updateIntention(String id, String text) async {
    if (text.trim().isEmpty) {
      _hapticService.error();
      Get.snackbar(
        '验证失败',
        '请输入意图内容',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final intention = await _intentionRepository.getById(id);
      if (intention == null) {
        throw Exception('Intention not found');
      }
      
      final updated = intention.copyWith(text: text.trim());
      await _intentionRepository.update(updated);
      
      await loadTodayIntention();
      await loadAllIntentions();
      
      _hapticService.success();
      Get.back();
      
      Get.snackbar(
        '成功',
        '意图已更新',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error updating intention: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '更新意图失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 切换完成状态
  Future<void> toggleCompletion(String id) async {
    try {
      final intention = await _intentionRepository.getById(id);
      if (intention == null) return;
      
      if (intention.isCompleted) {
        await _intentionRepository.markAsIncomplete(id);
      } else {
        await _intentionRepository.markAsCompleted(id);
      }
      
      await loadTodayIntention();
      await loadAllIntentions();
      
      _hapticService.selection();
    } catch (e) {
      print('❌ Error toggling completion: $e');
      _hapticService.error();
    }
  }
  
  /// 删除意图
  Future<void> deleteIntention(String id) async {
    try {
      await _intentionRepository.delete(id);
      await loadTodayIntention();
      await loadAllIntentions();
      
      _hapticService.success();
      Get.snackbar(
        '成功',
        '意图已删除',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error deleting intention: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '删除意图失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  /// 获取完成统计
  Map<String, int> get completionStats {
    final total = allIntentions.length;
    final completed = allIntentions.where((i) => i.isCompleted).length;
    final pending = total - completed;
    
    return {
      'total': total,
      'completed': completed,
      'pending': pending,
    };
  }
  
  /// 获取完成率
  double get completionRate {
    final stats = completionStats;
    if (stats['total']! == 0) return 0.0;
    return stats['completed']! / stats['total']!;
  }
}
