import 'package:get/get.dart';
import '../controllers/create_event_controller.dart';

/// 创建事件绑定
class CreateEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateEventController>(
      () => CreateEventController(),
    );
  }
}
