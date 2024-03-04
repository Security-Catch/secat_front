import 'package:flutter/material.dart';
import 'package:front/src/widget/common/appBarArea.dart';
import 'package:front/src/widget/common/pageTitle.dart';
import 'package:front/src/widget/guidePart/callToReport.dart';
import 'package:front/src/widget/guidePart/callToReportTutorial.dart';
import 'package:front/src/widget/guidePart/guideImageContainer.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarArea(
          appBar: AppBar(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const pageTitle(title: "피싱 대응 가이드"),
            Container(
              margin: const EdgeInsets.all(10),
            ),
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                            border: const Border(
                                bottom: BorderSide(color: Colors.black)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 7))
                            ]),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CallToReportContainer(
                                phone: "112", message: " 전화 신고"),
                            CallToReportContainer(
                                phone: "1332", message: " 금융감독원 민원실"),
                            CallToReportTutorial(detailText: "이미 스미싱 피해를 본 경우"),
                            CallToReportContainer(
                                phone: "118", message: " 사이버테러 인터넷진흥원"),
                            CallToReportTutorial(
                                detailText: "스미싱 의심 문자를 받았거나 악성 앱 감염이 의심욀 때"),
                          ],
                        ),
                      ),
                      const pageTitle(title: '스미싱 상황별 대응방법'),
                      const GuideImageContainer(imageUrl: 'asset/guide-1.png'),
                      const GuideImageContainer(imageUrl: 'asset/guide-2.png'),
                      const GuideImageContainer(imageUrl: 'asset/guide-3.png'),
                      Container(
                        decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.black)),
                        ),
                        padding: const EdgeInsets.only(bottom: 30),
                      ),
                      const pageTitle(title: '악성앱 스미싱 피해 흐름도'),
                      const GuideImageContainer(imageUrl: 'asset/guide-4.png'),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                      ),
                    ],
                  )),
            )
          ],
        ));
  }
}
