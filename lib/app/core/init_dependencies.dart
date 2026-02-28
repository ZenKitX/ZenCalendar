import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/providers/local_storage_provider.dart';
import '../data/repositories/event_repository.dart';
import '../data/repositories/intention_repository.dart';
import '../data/repositories/quote_repository.dart';
import '../services/haptic_service.dart';

/// 初始化依赖注入
/// 
/// 在应用启动时调用，注册所有全局依赖
Future<void> initDependencies() async {
  // 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // 注册 Provider
  Get.put<LocalStorageProvider>(
    LocalStorageProvider(prefs),
    permanent: true,
  );
  
  // 注册 Repository
  Get.put<EventRepository>(
    EventRepository(Get.find<LocalStorageProvider>()),
    permanent: true,
  );
  
  Get.put<IntentionRepository>(
    IntentionRepository(Get.find<LocalStorageProvider>()),
    permanent: true,
  );
  
  Get.put<QuoteRepository>(
    QuoteRepository(),
    permanent: true,
  );
  
  // 注册 Services
  Get.put<HapticService>(
    HapticService(),
    permanent: true,
  );
  
  print('✅ Dependencies initialized');
}
