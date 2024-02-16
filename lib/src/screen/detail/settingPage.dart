import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/src/screen/detail/editAuthorityPhone.dart';
import 'package:front/src/widget/common/pageTitle.dart';
import 'package:front/src/widget/common/appBarArea.dart';
import 'package:front/src/widget/settingPart/settingContainer.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleReportSubmitted() async {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
                // backgroundColor: Colors.white,
                // title: Text("로그아웃"),
                content: Text("로그아웃 하시겠습니까?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "네",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).devicePixelRatio * 4,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "아니요",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).devicePixelRatio * 4,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ]);
          });
    }

    return Scaffold(
      appBar: appBarArea(
        appBar: AppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageTitle(title: "설정"),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => editAuthorityPhoneNum()));
            },
            child: settingContainer(
              text: "번호 수정",
            ),
          ),
          GestureDetector(
            onTap: () {
              handleReportSubmitted();
            },
            child: settingContainer(
              text: "로그아웃",
            ),
          ),
        ],
      ),
    );
  }
}
