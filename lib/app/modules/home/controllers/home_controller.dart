import 'package:get/get.dart';

/// Home 控制器
class HomeController extends GetxController {
  // 当前选中的页面索引
  final currentIndex = 0.obs;
  
  /// 切换页面
  void changePage(int index) {
    currentIndex.value = index;
  }
}
