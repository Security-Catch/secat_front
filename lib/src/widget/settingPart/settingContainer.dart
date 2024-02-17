import 'package:flutter/material.dart';

class settingContainer extends StatelessWidget {
  const settingContainer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).devicePixelRatio * 7),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).devicePixelRatio * 6.5, left: 15),
      height: MediaQuery.of(context).devicePixelRatio * 20,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 7))
          ]),
      child: Text(
        text,
        style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio * 6),
      ),
    );
  }
}
