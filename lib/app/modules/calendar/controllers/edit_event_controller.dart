import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../services/haptic_service.dart';

/// 编辑事件控制器
class EditEventController extends GetxController {
  final EventRepository _eventRepository = Get.find<EventRepository>();
  final HapticService _hapticService = Get.find<HapticService>();
  
  // 表单控制器
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // 响应式状态
  final event = Rx<EventModel?>(null);
  final selectedDate = DateTime.now().obs;
  final startTime = TimeOfDay.now().obs;
  final endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0).obs;
  final isAllDay = false.obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadEvent();
  }
  
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
  
  /// 加载事件数据
  Future<void> _loadEvent() async {
    try {
      // 从路由参数获取事件 ID
      final eventId = Get.parameters['id'];
      if (eventId == null) {
        Get.back();
        return;
      }
      
      isLoading.value = true;
      final loadedEvent = await _eventRepository.getById(eventId);
      
      if (loadedEvent == null) {
        Get.back();
        Get.snackbar(
          '错误',
          '事件不存在',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // 设置表单数据
      event.value = loadedEvent;
      titleController.text = loadedEvent.title;
      descriptionController.text = loadedEvent.description ?? '';
      selectedDate.value = loadedEvent.startTime;
      startTime.value = TimeOfDay.fromDateTime(loadedEvent.startTime);
      endTime.value = TimeOfDay.fromDateTime(loadedEvent.endTime);
      isAllDay.value = loadedEvent.isAllDay;
    } catch (e) {
      print('❌ Error loading event: $e');
      Get.back();
      Get.snackbar(
        '错误',
        '加载事件失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 选择日期
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    
    if (picked != null) {
      selectedDate.value = picked;
      _hapticService.selection();
    }
  }
  
  /// 选择开始时间
  Future<void> selectStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime.value,
    );
    
    if (picked != null) {
      startTime.value = picked;
      _hapticService.selection();
      
      // 自动调整结束时间
      if (_timeToMinutes(endTime.value) <= _timeToMinutes(picked)) {
        final newEndHour = (picked.hour + 1) % 24;
        endTime.value = TimeOfDay(hour: newEndHour, minute: picked.minute);
      }
    }
  }
  
  /// 选择结束时间
  Future<void> selectEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime.value,
    );
    
    if (picked != null) {
      if (_timeToMinutes(picked) > _timeToMinutes(startTime.value)) {
        endTime.value = picked;
        _hapticService.selection();
      } else {
        _hapticService.error();
        Get.snackbar(
          '时间错误',
          '结束时间必须晚于开始时间',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  
  /// 切换全天事件
  void toggleAllDay() {
    isAllDay.value = !isAllDay.value;
    _hapticService.light();
  }
  
  /// 更新事件
  Future<void> updateEvent() async {
    if (event.value == null) return;
    
    // 验证标题
    if (titleController.text.trim().isEmpty) {
      _hapticService.error();
      Get.snackbar(
        '验证失败',
        '请输入事件标题',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      // 构建开始和结束时间
      final start = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        isAllDay.value ? 0 : startTime.value.hour,
        isAllDay.value ? 0 : startTime.value.minute,
      );
      
      final end = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        isAllDay.value ? 23 : endTime.value.hour,
        isAllDay.value ? 59 : endTime.value.minute,
      );
      
      // 更新事件模型
      final updatedEvent = event.value!.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        startTime: start,
        endTime: end,
        isAllDay: isAllDay.value,
      );
      
      // 保存到仓库
      await _eventRepository.update(updatedEvent);
      
      _hapticService.success();
      Get.back(result: true); // 返回 true 表示更新成功
      
      Get.snackbar(
        '成功',
        '事件已更新',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error updating event: $e');
      _hapticService.error();
      Get.snackbar(
        '错误',
        '更新事件失败',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  /// 将 TimeOfDay 转换为分钟数
  int _timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}
