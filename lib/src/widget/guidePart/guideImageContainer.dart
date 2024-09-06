import 'package:flutter/material.dart';

class GuideImageContainer extends StatelessWidget {
  const GuideImageContainer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          top: MediaQuery.of(context).size.height * 0.025),
      child: Image.asset(imageUrl),
    );
  }
}
