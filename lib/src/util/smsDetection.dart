import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front/src/util/notification.dart';
import 'package:front/src/widget/alarmButtonPart/alarmButtonPart.dart';
import 'package:front/src/widget/common/activeClass.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class FlutterSmsDetection {
  FlutterSmsDetection._();

  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    /// OPTIONAL, using custom notification channel id
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'my_foreground', // id
      'MY FOREGROUND SERVICE', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.low, // importance must be at low or higher level
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (Platform.isIOS || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          iOS: DarwinInitializationSettings(),
          android: AndroidInitializationSettings('ic_bg_service_small'),
        ),
      );
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        notificationChannelId: 'my_foreground',
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    final log = preferences.getStringList('log') ?? <String>[];
    log.add(DateTime.now().toIso8601String());
    await preferences.setStringList('log', log);

    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("hello", "world");

    /// OPTIONAL when use custom notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
    }

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          /// OPTIONAL for use custom notification
          /// the notification id must be equals with AndroidConfiguration when you call configure() method.
          flutterLocalNotificationsPlugin.show(
            888,
            'COOL SERVICE',
            'Awesome ${DateTime.now()}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'my_foreground',
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );

          // if you don't using custom notification, uncomment this
          service.setForegroundNotificationInfo(
            title: "Security Catch",
            content: "작동 중\n ${DateTime.now()}",
          );
        }
      }

      /// you can see this log in logcat
      // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

      // test using external plugin
      final deviceInfo = DeviceInfoPlugin();
      String? device;
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        device = androidInfo.model;
      }

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        device = iosInfo.model;
      }

      service.invoke(
        'update',
        {
          "current_date": DateTime.now().toIso8601String(),
          "device": device,
        },
      );
    });
  }

  static checkHandleSMS(String from, String message) async {
    try {
      final url = Uri.parse("http://200.5.60.236:3000/smishing/check/")
          .replace(queryParameters: {
        'message': message,
      });

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final code = jsonResponse['code'];

        if (code == 200) {
          // 정상적으로 작동할 때
          print(jsonResponse['result']);
          bool _active = jsonResponse['result'];
          final prefs = await SharedPreferences.getInstance();
          bool alarmState = prefs.getBool('alarmState') ?? true;
          print("ggam : alarm state ${alarmState}");

          if (!_active && alarmState) {
            String fullMessage = from + "으로 온 연락\n" + message;
            // FlutterLocalNotification.showFullScreenNotification();

            await openMessageAlert(from, jsonResponse['message'], fullMessage);
            // FlutterLocalNotification.showNotification(
            //     from, message, jsonResponse['message'], fullMessage);
            // return _active;
          }
        } else {
          print('서버 에러: ${jsonResponse['error'] ?? '에러 정보가 없습니다.'}');
        }
      } else {
        // 상태 코드가 200이 아닌 경우
        print('응답 에러: ${response.statusCode}');
        print('응답 본문: ${response.body}'); // 응답 전체를 출력해서 구조 확인
        try {
          // 에러 메시지가 'error' 필드에 있는지 확인
          final errorResponse = jsonDecode(response.body);
          print(
              '에러 메시지: ${errorResponse['error'] ?? '서버가 에러 메시지를 보내지 않았습니다.'}');
          FlutterLocalNotification.showErrorNotification(
              "서버 메시지", errorResponse['error'] ?? '서버가 에러 메시지를 보내지 않았습니다.');
        } catch (jsonError) {
          // JSON 파싱 에러 처리
          print('응답을 JSON으로 파싱하는 중 에러 발생: $jsonError');
        }
      }
    } catch (e) {
      print('네트워크 또는 서버 에러 발생: $e');
    }
  }

  static onBackgroundMessage(SmsMessage message) {
    String m = message.body ?? "Error reading message body";
    String from = message.address ?? "Error reading message address";

    checkHandleSMS(from, m);

    // if (!_active) {
    //   FlutterLocalNotification.showNotification(from, m);
    // }
    debugPrint("onBackgroundMessage called $m - $from");
  }

  static openMessageAlert(
      String phoneNumber, String titleContent, String messageContent) async {
    MethodChannel _channel = const MethodChannel("secat.jhl.dev/alert");
    _channel.invokeMethod('notinog', {
      'message_title_content': titleContent,
      'message': messageContent,
      'phone_number': phoneNumber
    });
  }
}
