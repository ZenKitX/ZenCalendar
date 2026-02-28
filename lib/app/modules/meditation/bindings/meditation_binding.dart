import 'package:get/get.dart';
import '../controllers/meditation_controller.dart';

/// 冥想模块依赖绑定
class MeditationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeditationController>(
      () => MeditationController(),
    );
  }
}
