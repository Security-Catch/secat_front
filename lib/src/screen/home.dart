import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:front/src/screen/detail/guidePage.dart';
import 'package:front/src/screen/detail/homeDetail.dart';
import 'package:front/src/screen/detail/settingPage.dart';
import 'package:front/src/util/notification.dart';
import 'package:front/src/util/smsDetection.dart';
import 'package:front/src/widget/common/appBarArea.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:telephony/telephony.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool get isiOS =>
      foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  String _message = "";
  final telephony = Telephony.instance;

  @override
  void initState() {
    if (!isiOS) {
      initPlatformState();
      // Future.delayed(const Duration(seconds: 3),
      FlutterLocalNotification.init();
      FlutterLocalNotification.requestNotificationPermission();
    }
    super.initState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
      String m = message.body ?? "Error reading message body";
      String from = message.address ?? "Error reading message address";
      debugPrint("onForegroundMessage called $m - $from");
      FlutterSmsDetection.checkHandleSMS(from, m);
      // FlutterLocalNotification.showNotification(from, m);
    });
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage,
          onBackgroundMessage: FlutterSmsDetection.onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  void dispose() {
    // streamController.close();
    super.dispose();
  }

  Container _homeBodyContainer(String title, String type) {
    double uniHeightValue = MediaQuery.of(context).devicePixelRatio;
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xff7F7F7F), width: 1)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: uniHeightValue * 5,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => type == '가이드' ? GuidePage() : SettingPage(),
            ),
          );
        },
      ),
    );
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
            _homeBodyContainer('피싱 대응 가이드', '가이드'),
            _homeBodyContainer('설정', '설정'),
          ]),
        ),
      ),
      body: HomeDetail(),
    );
  }
}
