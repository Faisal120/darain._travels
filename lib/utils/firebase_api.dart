import 'dart:convert';

import 'package:darain_travels/apiServices/basicConstants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroudMessages(RemoteMessage message) async {
  print("Title ${message.notification?.title}");
  print("Body ${message.notification?.body}");
  print("Payload ${message.notification}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'High_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotification = FlutterLocalNotificationsPlugin();


  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    print("Message is : $message");
  }

  Future initLocalNotification()async{
    const android = AndroidInitializationSettings('@drawable/logo');
    const settings = InitializationSettings(android: android);

    await _localNotification.initialize(
        settings,
    onDidReceiveNotificationResponse: (payload){
      final message = RemoteMessage.fromMap(jsonDecode(payload.toString()));
      handleMessage(message);
    },
    );

    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);

  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      sound: true,
      badge: true,
      alert: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(
        handleBackgroudMessages);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotification.show(
          notification.hashCode, notification.title, notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id,
                  _androidChannel.name,
                  channelDescription: _androidChannel.description,
                icon: '@drawable/logo'
              ),
          ),
      payload: jsonEncode(message.toMap())
      );
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final _FCMToken = await _firebaseMessaging.getToken();
    print("FCM Token $_FCMToken");
    BasicConstants.prefs = await SharedPreferences.getInstance();
    BasicConstants.prefs?.setString("rFCMToken", _FCMToken!);
    initPushNotification();
    initLocalNotification();
  }
}