import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/src/app.dart';
import 'package:front/src/util/notification.dart';
import 'package:front/src/util/smsDetection.dart';

StreamController<String> streamController = StreamController.broadcast();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterLocalNotification.onBackgroundNotificationresponse();
  await FlutterSmsDetection.initializeService();

  runApp(const MyApp());
}
// void main() {
//   runApp(const MyApp());
// }
