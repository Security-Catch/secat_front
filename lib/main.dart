import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/src/app.dart';
import 'package:front/src/util/alarmController.dart';
import 'package:front/src/util/notification.dart';
import 'package:front/src/util/smsDetection.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

StreamController<String> streamController = StreamController.broadcast();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //register to background MethodChannel

  final AlarmController alarmController = Get.put(AlarmController());

  await _requestNotificationPermission(alarmController);

  FlutterLocalNotification.onBackgroundNotificationresponse();

  await FlutterSmsDetection.initializeService();

  // Get.put(AlarmController());

  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }

Future<void> _requestNotificationPermission(
    AlarmController alarmController) async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    // 권한이 허용된 경우 처리
    alarmController.updateNotificationStatus(true);
  } else if (status.isDenied || status.isPermanentlyDenied) {
    // 권한이 거부된 경우 처리
    alarmController.updateNotificationStatus(false);
    print("Notification permission denied.");

    // 권한 거부 시 경고 메시지 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPermissionDeniedDialog(alarmController);
    });
  }
}

// 권한 거부 시 대화 상자 표시 함수
void _showPermissionDeniedDialog(AlarmController alarmController) {
  Get.dialog(
    AlertDialog(
      title: Text('Notification Permission Required'),
      content: Text('알림을 허용하지 않으면 앱을 사용할 수 없습니다. 앱을 종료합니다.'),
      actions: <Widget>[
        TextButton(
          child: Text('종료'),
          onPressed: () {
            // 앱 종료
            SystemNavigator.pop(); // Android에서 앱을 종료하는 코드
          },
        ),
        TextButton(
          child: Text('다시 시도'),
          onPressed: () {
            // 다시 알림 권한 요청
            Get.back(); // AlertDialog 닫기
            _requestNotificationPermission(alarmController);
          },
        ),
      ],
    ),
    barrierDismissible: false, // 대화 상자를 강제로 닫지 못하게 함
  );
}

// 권한을 다시 요청하는 함수
void _retryRequestNotificationPermission(
    AlarmController alarmController) async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    // 권한이 허용된 경우 처리
    print("Notification permission granted.");
  } else {
    // 권한이 거부된 경우 앱을 종료
    SystemNavigator.pop(); // Android에서 앱 종료
  }
}
