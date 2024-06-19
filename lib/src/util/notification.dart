import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FlutterLocalNotification {
  FlutterLocalNotification._();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    DarwinInitializationSettings iosInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResopnse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResopnse,
    );
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static requestNotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showFullScreenNotification(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Turn off your screen'),
        content: const Text(
            'to see the full-screen intent in 5 seconds, press OK and TURN '
            'OFF your screen'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await flutterLocalNotificationsPlugin.zonedSchedule(
                  0,
                  'scheduled title',
                  'scheduled body',
                  tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                  const NotificationDetails(
                      android: AndroidNotificationDetails(
                          'full screen channel id', 'full screen channel name',
                          channelDescription: 'full screen channel description',
                          priority: Priority.high,
                          importance: Importance.high,
                          fullScreenIntent: true)),
                  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                  uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime);

              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  static Future<void> showNotification(
    String from,
    String m,
    String result,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      autoCancel: false,
      ongoing: true,
      styleInformation: BigTextStyleInformation(m),
      // visibility: NotificationVisibility.private,
      fullScreenIntent: true,
      // setAsGroupSummary: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'id_2',
          '확인',
        ),
        AndroidNotificationAction(
          "navigationActionId",
          '메시지 확인',
          titleColor: Color.fromARGB(255, 255, 0, 0),
          showsUserInterface: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
          cancelNotification: false,
        ),
      ],

      groupKey: 'com.android.example.WORK_EMAIL',
      // styleInformation: DefaultStyleInformation(true, true),
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    // int groupNotificationCount = 1;

    await Future.delayed(const Duration(seconds: 6));
    await flutterLocalNotificationsPlugin.show(Random().nextInt(1000000),
        "Security Catch", "$m\n $result", notificationDetails,
        payload: "$from");

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            onlyAlertOnce: true,
            groupKey: 'com.android.example.WORK_EMAIL',
            setAsGroupSummary: true);

    // 플랫폼별 설정 - 현재 안드로이드만 적용됨
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    // 그룹용 알림 출력
    // 이때는 ID를 0으로 고정시켜 새로 생성되지 않게 한다.
    await flutterLocalNotificationsPlugin.show(
        0, '', '', platformChannelSpecifics);
  }

  static void onDidReceiveNotificationResopnse(
      NotificationResponse notificationResponse) async {
    final String payload = notificationResponse.payload ?? "";
    if (notificationResponse.payload != null ||
        notificationResponse.payload!.isNotEmpty) {
      print('FOREGROUND PAYLOAD : $payload');
      // streamController.add(payload);
      String cont = 'sms:' + payload;
      final url = Uri.parse(cont);
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        print("Can't launch $url");
      }
    }
  }

  // static void onBackgroundNotificationresponse(
  //     NotificationResponse notificationResponse) async {
  //   final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  //       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //   if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
  //     final String payload = notificationResponse.payload ?? "";
  //     if (notificationResponse.payload != null ||
  //         notificationResponse.payload!.isNotEmpty) {
  //       print("BACKGROUND PAYLOAD: $payload");
  //       streamController.add(payload);
  //     }
  //   }
  // }

  static void onBackgroundNotificationresponse() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      String payload =
          notificationAppLaunchDetails!.notificationResponse?.payload ?? "";
      print("BACKGROUND PAYLOAD : $payload");
      String cont = 'sms:' + payload;
      final url = Uri.parse(cont);
      if (await canLaunchUrl(url)) {
        launchUrl(url);
      } else {
        print("Can't launch $url");
      }
      // streamController.add(payload);
    }
  }
}
