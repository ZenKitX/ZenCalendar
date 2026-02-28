import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/calendar/bindings/create_event_binding.dart';
import '../modules/calendar/bindings/edit_event_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/calendar/views/create_event_view.dart';
import '../modules/calendar/views/edit_event_view.dart';
import '../modules/calendar/views/event_detail_view.dart';
import '../modules/intention/bindings/intention_binding.dart';
import '../modules/intention/views/intention_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/advanced_settings_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/meditation/bindings/meditation_binding.dart';
import '../modules/meditation/views/meditation_view.dart';

part 'app_routes.dart';

/// GetX 路由配置
class AppPages {
  AppPages._();

  /// 初始路由
  static const INITIAL = Routes.HOME;

  /// 所有路由
  static final routes = [
    // 主页面（带底部导航）
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 日历页面（独立访问）
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 创建事件页面
    GetPage(
      name: _Paths.CREATE_EVENT,
      page: () => const CreateEventView(),
      binding: CreateEventBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 编辑事件页面
    GetPage(
      name: _Paths.EDIT_EVENT,
      page: () => const EditEventView(),
      binding: EditEventBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 事件详情页面
    GetPage(
      name: _Paths.EVENT_DETAIL,
      page: () => const EventDetailView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 意图页面
    GetPage(
      name: _Paths.INTENTION,
      page: () => const IntentionView(),
      binding: IntentionBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 设置页面
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 高级设置页面
    GetPage(
      name: _Paths.ADVANCED_SETTINGS,
      page: () => const AdvancedSettingsView(),
      binding: SettingsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 搜索页面
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    // 冥想页面
    GetPage(
      name: _Paths.MEDITATION,
      page: () => const MeditationView(),
      binding: MeditationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
