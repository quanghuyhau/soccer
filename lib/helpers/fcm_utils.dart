import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:soccer/di/environment/build_config.dart';
// import 'package:soccer/firebase_options_dev.dart';
// import 'package:soccer/firebase_options_prod.dart';
// import 'package:soccer/main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FCMService {
  FCMService._();

  static FCMService I = FCMService._();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'atm_soundbox_channel',
    'ATM Sound Box Channel',
    importance: Importance.max,
    showBadge: false,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initialize() async {
    await Firebase.initializeApp(
      // options: env == CustomEnv.uat
      //     ? DefaultFirebaseOptionsDev.currentPlatform
      //     : DefaultFirebaseOptionsProd.currentPlatform,
    );
    await _initializeFirebaseMessaging();
  }

  Future _initializeFirebaseMessaging() async {
    await requestPermission();
    await _configNatives();
    await _configLocalNotification();
    _registerMessageListener();
  }

  Future requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future _configNatives() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _configLocalNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    const initializationSettingsIOs = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          final jsonData = json.decode(notificationResponse.payload ?? '');
          // Xử lý sự kiện ấn vào thông báo từ foreground
          _handleClickMessage(jsonData);
        }
      },
    );
  }

  void _registerMessageListener() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = json.encode(message.data);
      final android = message.notification?.android;

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        (!message.data.containsKey('sound') || message.data['sound'] == null)
            ? 'shopnow_channel'
            : message.data['sound'],
        'ShopNow Channel',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
      );
      final iosNotificationDetails = DarwinNotificationDetails(
        badgeNumber: 0,
        sound: (!message.data.containsKey('sound') ||
                message.data['sound'] == null)
            ? null
            : message.data['sound'],
      );
      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosNotificationDetails,
      );

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformChannelSpecifics,
          payload: data,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Xử lý sự kiện ấn vào thông báo từ background
      _handleClickMessage(message.data);
    });

    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
  }

  void getInitialFCMMessage() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _firebaseMessagingBackgroundHandler(message);
        // sự kiện ấn vào thông báo từ terminate
        _handleClickMessage(message.data);
      }
    });
  }

  Future<String?> getToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (_) {}
    return null;
  }

  _handleClickMessage(Map<String, dynamic> data) async {

  }
}

