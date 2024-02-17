import 'package:flutter/material.dart';
import 'package:front/src/widget/common/appBarArea.dart';
import 'package:front/src/widget/common/pageTitle.dart';

class editAuthorityPhoneNum extends StatefulWidget {
  const editAuthorityPhoneNum({super.key});

  @override
  State<editAuthorityPhoneNum> createState() => _editAuthorityPhoneNumState();
}

class _editAuthorityPhoneNumState extends State<editAuthorityPhoneNum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarArea(appBar: AppBar()),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageTitle(title: "번호 수정"),
          ],
        ));
  }
}
