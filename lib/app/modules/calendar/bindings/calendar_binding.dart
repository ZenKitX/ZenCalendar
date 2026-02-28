import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';
import '../controllers/week_controller.dart';
import '../controllers/day_controller.dart';

/// Calendar 模块依赖绑定
class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    // 先初始化子控制器
    Get.lazyPut<WeekController>(
      () => WeekController(),
      tag: 'week',
    );
    
    Get.lazyPut<DayController>(
      () => DayController(),
      tag: 'day',
    );
    
    // 最后初始化主控制器
    Get.lazyPut<CalendarController>(
      () => CalendarController(),
    );
  }
}
