import 'package:get/get.dart';

class AlarmController extends GetxController {
  // 상태를 관리할 변수를 정의합니다.
  var alarmState = true.obs;

  // 사용자 정보 업데이트 메서드
  void updateState() {
    alarmState.value = !alarmState.value;
    print("alamrStateCheck : ${alarmState.value}");
  }
}
