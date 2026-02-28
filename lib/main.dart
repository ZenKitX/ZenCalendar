import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/config/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/core/init_dependencies.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化依赖注入
  await initDependencies();
  
  runApp(const ZenCalendarApp());
}

class ZenCalendarApp extends StatelessWidget {
  const ZenCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ZenCalendar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
