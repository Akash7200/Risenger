import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:risenger/firebase_options.dart';
import 'package:risenger/services/alert_service.dart';
import 'package:risenger/services/auth_service.dart';
import 'package:risenger/services/media_service.dart';
import 'package:risenger/services/navigation_service.dart';
import 'package:risenger/services/storage_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
}

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(
    AuthService(),
  );
  getIt.registerSingleton<NavigationService>(
    NavigationService(),
  );
  getIt.registerSingleton<AlertService>(
    AlertService(),
  );
  getIt.registerSingleton<MediaService>(
    MediaService(),
  );
  getIt.registerSingleton<StorageService>(
    StorageService(),
  );
}

