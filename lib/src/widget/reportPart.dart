import 'package:flutter/material.dart';
import 'package:front/src/screen/detail/checkPage.dart';
import 'package:front/src/screen/detail/reportPage.dart';

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
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => checkPage(),
                    ));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Image.asset('asset/checkLogo.png',
                          width: MediaQuery.of(context).devicePixelRatio * 10,
                          height: MediaQuery.of(context).devicePixelRatio * 10),
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).devicePixelRatio * 6),
                    ),
                    Text('메시지 검사하기',
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).devicePixelRatio * 8))
                  ],
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => reportPage(),
                      ));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Image.asset('asset/reportLogo.png',
                            width: MediaQuery.of(context).devicePixelRatio * 10,
                            height:
                                MediaQuery.of(context).devicePixelRatio * 10),
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).devicePixelRatio * 6),
                      ),
                      Text('스미싱 신고하기',
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).devicePixelRatio * 8))
                    ],
                  ),
                )),
          ],
        ));
  }
}
