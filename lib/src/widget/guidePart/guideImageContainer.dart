import 'package:flutter/material.dart';

class GuideImageContainer extends StatelessWidget {
  const GuideImageContainer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
      child: Image.asset(imageUrl),
    );
  }
}
