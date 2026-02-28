import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

/// Calendar 模块依赖绑定
class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(
      () => CalendarController(),
    );
  }
}
