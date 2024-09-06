import 'package:flutter/material.dart';

class CallToReportTutorial extends StatelessWidget {
  const CallToReportTutorial({super.key, required this.detailText});

  final String detailText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12),
      child: Text(
        detailText,
        style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio * 4),
      ),
    );
  }
}
