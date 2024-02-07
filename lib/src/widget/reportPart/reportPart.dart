import 'package:flutter/material.dart';
import 'package:front/src/widget/reportPart/reportHomeContainer.dart';

class ReportPart extends StatelessWidget {
  const ReportPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.35,
        // margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(249, 229, 134, 0.5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            homeContainer(
              imageUrl: 'asset/checkLogo.png',
              buttonName: '메시지 검사하기',
              type: '검사',
            ),
            homeContainer(
                imageUrl: 'asset/reportLogo.png',
                buttonName: '스미싱 신고하기',
                type: '신고')
          ],
        ));
  }
}
