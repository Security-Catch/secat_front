import 'package:flutter/material.dart';
import 'package:front/src/widget/reportPart/reportAppBar.dart';
import 'package:front/src/widget/reportPart/reportBody.dart';

class checkPage extends StatefulWidget {
  const checkPage({super.key});

  @override
  State<checkPage> createState() => _checkPageState();
}

class _checkPageState extends State<checkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reportAppBarArea(
        appBar: AppBar(),
      ),
      body: reportBodyArea(
          screenTitle: '메시지 검사하기',
          hiddenMessage: '검사하고 싶은 메시지를 입력해주세요',
          buttonName: '검사하기',
          type: '검사'),
    );
  }
}
