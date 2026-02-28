import 'package:get/get.dart';
import '../controllers/event_search_controller.dart';

/// 搜索模块依赖绑定
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventSearchController>(
      () => EventSearchController(),
    );
  }
}
