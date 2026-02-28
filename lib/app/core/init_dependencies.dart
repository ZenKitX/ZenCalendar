import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/providers/local_storage_provider.dart';
import '../data/repositories/event_repository.dart';
import '../data/repositories/intention_repository.dart';
import '../data/repositories/quote_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/meditation_repository.dart';
import '../data/services/export_service.dart';
import '../data/services/import_service.dart';
import '../data/services/backup_service.dart';
import '../data/services/recurrence_service.dart';
import '../data/services/audio_player_service.dart';
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
  
  // 注册 Services
  Get.put<HapticService>(
    HapticService(),
    permanent: true,
  );
  
  Get.put<RecurrenceService>(
    RecurrenceService(),
    permanent: true,
  );
  
  Get.put<ExportService>(
    ExportService(),
    permanent: true,
  );
  
  Get.put<ImportService>(
    ImportService(),
    permanent: true,
  );
  
  Get.put<BackupService>(
    BackupService(),
    permanent: true,
  );
  
  Get.put<AudioPlayerService>(
    AudioPlayerService(),
    permanent: true,
  );
  
  // 注册 Repository（需要在 Services 之后）
  Get.put<EventRepository>(
    EventRepository(
      Get.find<LocalStorageProvider>(),
      Get.find<RecurrenceService>(),
    ),
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
  
  Get.put<CategoryRepository>(
    CategoryRepository(Get.find<LocalStorageProvider>()),
    permanent: true,
  );
  
  Get.put<MeditationRepository>(
    MeditationRepository(prefs),
    permanent: true,
  );
  
  print('✅ Dependencies initialized');
}
