import 'package:flutter/material.dart';

class pageTitle extends StatelessWidget {
  const pageTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).devicePixelRatio * 3, left: 45),
      child: Text(
        title,
        style: TextStyle(
            fontSize: MediaQuery.of(context).devicePixelRatio * 5,
            fontFamily: 'Happiness-Sans-Bold',
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
