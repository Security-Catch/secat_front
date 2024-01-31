import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:front/src/screen/detail/homeDetail.dart';
import 'package:front/src/screen/guidePage.dart';
import 'package:front/src/screen/settingPage.dart';
import 'package:front/src/util/notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    FlutterLocalNotification.init();

    Future.delayed(const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission());

    void initState() {
      super.initState();
      FlutterLocalNotification.requestNotificationPermission(); // 알림 권한 요청
    }

    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double uniHeightValue = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Security Catch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffFFD400),
              fontSize: uniHeightValue * 6,
            ),
          ),
        ),
        centerTitle: false,
      ),
      endDrawer: Drawer(
        child: Container(
          color: const Color(0xffECE6CC),
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.13,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                margin: EdgeInsets.all(0),
                // DrawerHeader가 SizedBox에 마진 없이 들어가야함
                child: Text(
                  '메뉴',
                  style: TextStyle(
                    fontSize: uniHeightValue * 6,
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xff7F7F7F), width: 1)),
              ),
              child: ListTile(
                title: Text(
                  '피싱 대응 가이드',
                  style: TextStyle(
                    fontSize: uniHeightValue * 5,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuidePage(),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xff7F7F7F), width: 1)),
              ),
              child: ListTile(
                title: Text(
                  '설정',
                  style: TextStyle(
                    fontSize: uniHeightValue * 5,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
      body: HomeDetail(),
    );
  }
}
