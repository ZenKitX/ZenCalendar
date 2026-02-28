import 'package:get/get.dart';
import '../controllers/edit_event_controller.dart';

/// 编辑事件绑定
class EditEventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditEventController>(
      () => EditEventController(),
    );
  }
}
