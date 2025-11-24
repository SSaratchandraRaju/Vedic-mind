import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app/routes/app_pages.dart';
import 'app/ui/theme/app_theme.dart';
import 'app/bindings/app_bindings.dart';
import 'app/data/repositories/firestore_notifications_repository.dart';
// Firestore user settings handled inside ThemeController; notifications repo used directly for FCM persistence.
import 'app/controllers/notifications_controller.dart';
import 'app/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with generated options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up local notifications (for displaying FCM while foreground)
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Request notification permissions (especially for iOS, macOS)
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  // Obtain FCM token
  final token = await messaging.getToken();
  debugPrint('FCM Token: $token');

  // Foreground message handler -> push to Firestore (or queue until auth)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;
    final title = notification?.title ?? 'Notification';
    final body = notification?.body ?? '';
    if (notification != null && android != null) {
      const androidDetails = AndroidNotificationDetails(
        'vedicmind_foreground',
        'Foreground Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );
      const details = NotificationDetails(android: androidDetails);
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        details,
      );
    }
    // Try to dispatch via NotificationsController (preferred)
    if (Get.isRegistered<NotificationsController>()) {
      final ctrl = Get.find<NotificationsController>();
      ctrl.addNotification(title: title, body: body, background: false);
    } else {
      // Fallback: write directly to Firestore if auth user available
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirestoreNotificationsRepository().addNotification(
          userId: user.uid,
          title: title,
          body: body,
          background: false,
        );
      } else {
        // Queue in ThemeController (global singleton) until auth loads
        if (Get.isRegistered<ThemeController>()) {
          Get.find<ThemeController>().queueNotification(title, body);
        }
      }
    }
  });

  // Background handler registration
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // NOTE: We no longer manually call AppBindings().dependencies();
  // Instead we set it as the initialBinding on GetMaterialApp so that
  // all lazyPut services (AuthService, repositories, etc.) are available
  // before any route/controller tries to access them.

  runApp(const VedicMindApp());
}

// Background handler (must be a top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final user = FirebaseAuth.instance.currentUser;
  final title = message.notification?.title ?? 'Notification';
  final body = message.notification?.body ?? '';
  if (user != null) {
    await FirestoreNotificationsRepository().addNotification(
      userId: user.uid,
      title: title,
      body: body,
      background: true,
    );
  } else {
    // No authenticated user in background isolate; ignore or could queue via shared prefs (omitted per removal requirement)
  }
}

class VedicMindApp extends StatelessWidget {
  const VedicMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ThemeController is registered in AppBindings; we wrap GetMaterialApp in Obx.
    return Sizer(
      builder: (context, orientation, deviceType) {
        final themeController = Get.put(ThemeController(), permanent: true);
        return Obx(() => GetMaterialApp(
              title: 'VedicMind',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeController.themeMode.value,
              initialBinding: AppBindings(),
              initialRoute: AppPages.initial,
              getPages: AppPages.pages,
            ));
      },
    );
  }
}
