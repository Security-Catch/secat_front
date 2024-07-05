import 'package:flutter/material.dart';
import 'package:front/src/screen/detail/checkPage.dart';
import 'package:front/src/screen/detail/reportPage.dart';

class homeContainer extends StatelessWidget {
  const homeContainer(
      {super.key,
      required this.imageUrl,
      required this.buttonName,
      required this.type});

  final String imageUrl;
  final String buttonName;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => type == '검사' ? checkPage() : reportPage(),
            ));
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Image.asset(imageUrl,
                  width: MediaQuery.of(context).devicePixelRatio * 10,
                  height: MediaQuery.of(context).devicePixelRatio * 10),
              padding:
                  EdgeInsets.all(MediaQuery.of(context).devicePixelRatio * 6),
            ),
            Text(buttonName,
                style: TextStyle(
                    fontFamily: "Happiness-Sans-Bold",
                    fontSize: MediaQuery.of(context).devicePixelRatio * 8))
          ],
        ),
      ),
    );
  }
}
