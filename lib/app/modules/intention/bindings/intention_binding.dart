import 'package:get/get.dart';
import '../controllers/intention_controller.dart';

/// Intention 模块依赖绑定
class IntentionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntentionController>(
      () => IntentionController(),
    );
  }
}
