import 'package:flutter/material.dart';

class appBarArea extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const appBarArea({super.key, required this.appBar});

  @override
  Widget build(BuildContext context) {
    double uniHeightValue = MediaQuery.of(context).devicePixelRatio;

    return AppBar(
      title: Container(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width * 0.07,
            top: MediaQuery.of(context).size.height * 0.012,
            bottom: MediaQuery.of(context).size.height * 0.012),
        // decoration: BoxDecoration(
        //   color: const Color.fromRGBO(0, 0, 0, 0.5),
        //   borderRadius: BorderRadius.circular(30),
        // ),
        child: Text(
          'Security Catch',
          style: TextStyle(
            fontFamily: "SB",
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontSize: uniHeightValue * 6,
          ),
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
