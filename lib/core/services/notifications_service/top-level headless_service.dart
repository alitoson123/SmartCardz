// top-level headless entry (مهم: not a method)
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_cards/core/services/notifications_service/back_ground_service.dart';
import 'package:smart_cards/firebase_options.dart';

void backgroundFetchHeadlessTopLevel(HeadlessTask task) async {
  String taskId = task.taskId;
  bool timeout = task.timeout;
  if (timeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

  // 1) init firebase in headless isolate (pass options if needed)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2) create service instance and init notifications
  final svc = BackGroundService();
  await svc.initLocalNotifications();

  // 3) run background work
  await svc.backgroundWork();

  BackgroundFetch.finish(taskId);
}
