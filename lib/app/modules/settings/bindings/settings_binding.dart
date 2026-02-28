import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

/// Settings 模块依赖绑定
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
