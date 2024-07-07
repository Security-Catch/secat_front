import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/src/screen/home.dart';
import 'package:get/route_manager.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Home(),
    );
  }


}
