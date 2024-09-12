import 'dart:async';
import 'package:flutter/material.dart';
import 'package:front/src/util/notification.dart';
import 'package:front/src/widget/common/activeClass.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmButton extends StatefulWidget {
  const AlarmButton({super.key});

  @override
  State<AlarmButton> createState() => _AlarmButtonState();
}

class _AlarmButtonState extends State<AlarmButton> with WidgetsBindingObserver {
  bool alarmState = true; // 기본값을 true로 설정

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    _loadAlarmState(); // 상태 로드
  }

  // SharedPreferences에서 알람 상태를 불러오는 함수
  void _loadAlarmState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alarmState = prefs.getBool('alarmState') ?? true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 전환될 때 상태 저장
      print('ggam : 앱이 백그라운드로 전환되었습니다.');
      _saveAlarmState();
    } else if (state == AppLifecycleState.resumed) {
      // 다시 포그라운드로 돌아올 때 상태 로드
      print('ggam : 앱이 포그라운드로 돌아왔습니다.');
      _loadAlarmState();
    }
  }

  Future<void> _saveAlarmState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setBool('alarmState', alarmState);
    await prefs.reload();
    if (!success) {
      print("ggam : SharedPreferences 저장 실패 back ${alarmState}");
    } else {
      print("ggam : SharedPreferences 저장 성공 back ${alarmState}");
    }
  }

  Future<void> _setActive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alarmState = !alarmState;
      prefs.setBool('alarmState', alarmState); // 상태 저장 확인
      // prefs.reload();
    });

    // if (!success) {
    //   print("ggam : SharedPreferences 저장 실패 ${alarmState}");
    // } else {
    //   print("ggam : SharedPreferences 저장 성공 ${alarmState}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _setActive();
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: alarmState
                    ? Color(0xffF9E586).withOpacity(0.5)
                    : const Color(0xffD9D9D9).withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 5,
                offset: Offset(0, 3), // 그림자 위치 변경 가능
              ),
            ],
            color:
                alarmState ? const Color(0xffF9E586) : const Color(0xffD9D9D9),
            borderRadius: const BorderRadius.all(Radius.circular(200)),
          ),
          width: MediaQuery.of(context).size.width - 60,
          height: MediaQuery.of(context).size.width - 60,
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.067),
          alignment: Alignment.center,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.005),
                  child: alarmState
                      ? Image.asset(
                          'asset/mainLogo.png',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.5,
                        )
                      : Image.asset(
                          'asset/secatLogoOff.png',
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                ),
                alarmState
                    ? Text(
                        '씨캣이 스미싱으로부터\n안전하게 지켜드릴게요!',
                        style: TextStyle(
                            fontFamily: "Happiness-Sans-Bold",
                            fontSize:
                                MediaQuery.of(context).devicePixelRatio * 5),
                      )
                    : Text(
                        '씨캣이 스미싱으로부터 안전하게\n지켜드리기 위해 알림을 켜주세요',
                        style: TextStyle(
                            fontFamily: "Happiness-Sans-Bold",
                            fontSize:
                                MediaQuery.of(context).devicePixelRatio * 5),
                      ),
              ]),
        ),
      ),
    );
  }
}
