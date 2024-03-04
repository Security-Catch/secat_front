import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallToReportContainer extends StatefulWidget {
  const CallToReportContainer(
      {super.key, required this.phone, required this.message});

  final String phone;
  final String message;

  @override
  State<CallToReportContainer> createState() => _CallToReportContainerState();
}

class _CallToReportContainerState extends State<CallToReportContainer> {
  @override
  Widget build(BuildContext context) {
    bool _hasCallSupport = false;
    Future<void>? _launched;
    void initState() {
      super.initState();
      canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
        setState(() {
          _hasCallSupport = result;
        });
      });
    }

    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _launched = _makePhoneCall(widget.phone);
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 45, right: 45, top: 15, bottom: 10),
        // padding: EdgeInsets.only(left: 30),
        height: MediaQuery.of(context).devicePixelRatio * 18,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular((15)))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 23,
              height: 23,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Image.asset('asset/callIcon.png'),
            ),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: widget.phone,
                  style: TextStyle(
                      color: Color(0xff46CC6B),
                      fontSize: MediaQuery.of(context).devicePixelRatio * 5,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: widget.message,
                  style: TextStyle(
                    // color: Color(0xff46CC6B),
                    fontSize: MediaQuery.of(context).devicePixelRatio * 5,
                  ))
            ])),
          ],
        ),
      ),
    );
  }
}
