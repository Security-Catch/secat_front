import 'package:flutter/material.dart';
import 'package:front/src/widget/common/appBarArea.dart';
import 'package:front/src/widget/reportPart/reportBody.dart';

class reportPage extends StatefulWidget {
  const reportPage({super.key});

  @override
  State<reportPage> createState() => _reportPageState();
}

class _reportPageState extends State<reportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarArea(
        appBar: AppBar(),
      ),
      resizeToAvoidBottomInset: false,
      body: reportBodyArea(
          screenTitle: '스미싱 신고하기',
          hiddenMessage: '스미싱 문자로 의심되는 문자를 신고해주세요',
          buttonName: '신고하기',
          type: '신고'),
    );
  }
}
