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

StreamController<String> streamController = StreamController.broadcast();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //register to background MethodChannel

  FlutterLocalNotification.onBackgroundNotificationresponse();

  await FlutterSmsDetection.initializeService();

  Get.put(AlarmController());

  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }
