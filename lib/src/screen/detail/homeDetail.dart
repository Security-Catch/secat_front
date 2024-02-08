import 'package:flutter/material.dart';
import 'package:front/src/widget/alarmButtonPart/alarmButtonPart.dart';
import 'package:front/src/widget/reportPart/reportPart.dart';

class HomeDetail extends StatefulWidget {
  const HomeDetail({super.key});

  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        AlarmButton(),
        Spacer(),
        ReportPart(),
      ],
    ));
  }
}
