import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Home 绑定
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
