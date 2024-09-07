import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/src/util/alarmController.dart';
import 'package:front/src/util/notification.dart';
import 'package:front/src/widget/common/activeClass.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmButton extends StatefulWidget {
  const AlarmButton({super.key});

  @override
  State<AlarmButton> createState() => _AlarmButtonState();
}

class _AlarmButtonState extends State<AlarmButton> {
  late SharedPreferences prefs;
  bool alarmState = true; // 기본값을 true로 설정

  @override
  void initState() {
    super.initState();
    _loadAlarmState(); // 상태 로드
  }

  // SharedPreferences에서 알람 상태를 불러오는 함수
  Future<void> _loadAlarmState() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      alarmState = prefs.getBool('alarmState') ?? true; // 기본값 true
    });
  }

  Future<void> _setActive() async {
    setState(() {
      alarmState = !alarmState;
    });
    await prefs.setBool('alarmState', alarmState); // 상태 저장
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
