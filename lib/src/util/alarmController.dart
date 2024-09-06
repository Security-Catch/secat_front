import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmController extends GetxController {
  // 상태를 관리할 변수를 정의합니다.
  var alarmState = true.obs;
  var isNotificationEnabled = false.obs;

  // 사용자 정보 업데이트 메서드
  void updateState() {
    if (isNotificationEnabled.value) {
      alarmState.value = !alarmState.value;
    }
    // else {
    //   requestNotificationPermission();
    // }
  }

  void updateNotificationStatus(bool status) {
    isNotificationEnabled.value = status;
    alarmState.value = isNotificationEnabled.value;
  }

  void requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      // 권한이 허용된 경우 처리
      updateNotificationStatus(true);
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // 권한이 거부된 경우 처리
      updateNotificationStatus(false);
      print("Notification permission denied.");

      // 권한 거부 시 경고 메시지 표시
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPermissionDeniedDialog();
      });
    }
  }

  void showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Notification Permission Required'),
        content: Text('알림을 허용하지 않으면 앱을 사용할 수 없습니다. 앱을 종료합니다.'),
        actions: <Widget>[
          TextButton(
            child: Text('종료'),
            onPressed: () {
              // 앱 종료
              SystemNavigator.pop(); // Android에서 앱을 종료하는 코드
            },
          ),
          TextButton(
            child: Text('다시 시도'),
            onPressed: () {
              // 다시 알림 권한 요청
              Get.back(); // AlertDialog 닫기
              requestNotificationPermission();
            },
          ),
        ],
      ),
      barrierDismissible: false, // 대화 상자를 강제로 닫지 못하게 함
    );
  }
}
