import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../calendar/bindings/calendar_binding.dart';
import '../../calendar/views/calendar_view.dart';
import '../../intention/bindings/intention_binding.dart';
import '../../intention/views/intention_view.dart';
import '../../settings/bindings/settings_binding.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/home_controller.dart';

/// Home 视图 - 主页面，包含底部导航栏
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // 预加载所有页面的绑定
    CalendarBinding().dependencies();
    IntentionBinding().dependencies();
    SettingsBinding().dependencies();

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: const [
              CalendarView(),
              IntentionView(),
              SettingsView(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.currentIndex.value,
            onDestinationSelected: controller.changePage,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: '日历',
              ),
              NavigationDestination(
                icon: Icon(Icons.wb_sunny_outlined),
                selectedIcon: Icon(Icons.wb_sunny),
                label: '意图',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: '设置',
              ),
            ],
          ),
        ));
  }
}
