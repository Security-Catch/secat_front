import 'package:flutter/material.dart';
import 'package:front/src/widget/common/pageTitle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class reportBodyArea extends StatefulWidget {
  const reportBodyArea(
      {super.key,
      required this.screenTitle,
      required this.hiddenMessage,
      required this.buttonName,
      required this.type});

  final String screenTitle;
  final String hiddenMessage;
  final String buttonName;
  final String type;

  @override
  State<reportBodyArea> createState() => _reportBodyAreaState();
}

class _reportBodyAreaState extends State<reportBodyArea> {
  final TextEditingController _textController = new TextEditingController();

  bool _active = false;

  // _setActive() {
  //   setState(() {
  //     _active = !_active;
  //   });
  // }

  TextButton myButton(String text, Color textColor) {
    return TextButton(
      onPressed: () {
        _textController.clear();
        Navigator.pop(context);
        if (text == '신고하기') handleReportSubmitted(text);
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "Happiness-Sans-Bold",
          fontSize: MediaQuery.of(context).devicePixelRatio * 4,
          color: textColor,
        ),
      ),
    );
  }

  Text myText(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Happiness-Sans-Bold",
        fontSize: MediaQuery.of(context).devicePixelRatio * 5,
        color: textColor,
      ),
    );
  }

  Image myImage(String imageUrl) {
    return Image.asset(
      imageUrl,
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.width * 0.2,
    );
  }

  Future<void> check() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: myImage('asset/reportDoneLogo.png'),
              content: myText(
                  '신고해주셔서 감사합니다\n신고된 메시지는 스미싱 검사 데이터로 사용됩니다\n더 나은 씨캣이 되도록 노력하겠습니다',
                  Colors.black),
              actions: <Widget>[
                myButton('확인', Colors.black),
              ]);
        });
  }

  void handleCheckSubmitted(String text) async {
    final url = Uri.parse("http://192.168.0.11:3000/smishing/check/")
        .replace(queryParameters: {
      'message': text,
    });
    final response = await http.get(
      url,
    );
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['result']);
    _active = jsonResponse['result'];

    String imageUrl = _active ? 'asset/safeLogo.png' : 'asset/dangerLogo.png';
    String message = jsonResponse['message'];
    Color textColor = _active ? Colors.green : Colors.red;
    Color checkColor = _active ? Colors.black : Colors.grey;

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: myImage(imageUrl),
              content: myText(message, textColor),
              actions: <Widget>[
                myButton("확인", checkColor),
                if (!_active) myButton('신고하기', Colors.black),
              ]);
        });
  }

  void handleReportSubmitted(String text) async {
    final url = Uri.parse("http://192.168.0.11:3000/smishing/report/")
        .replace(queryParameters: {
      'message': text,
    });
    final response = await http.get(
      url,
    );
    var jsonResponse = jsonDecode(response.body);
    print(jsonResponse['isSucess']);
    if (jsonResponse['isSucess']) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                backgroundColor: Colors.white,
                title: myImage('asset/reportDoneLogo.png'),
                content: myText(
                    '신고해주셔서 감사합니다\n신고해주신 메시지는 스미싱 검사 데이터로 사용됩니다\n더 나은 씨캣이 되도록 노력하겠습니다',
                    Colors.black),
                actions: <Widget>[
                  myButton('확인', Colors.black),
                ]);
          });
    }
  }

  void handleNullSubmitted() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              // title: myText("", Colors.black),
              content: myText('메시지를 입력해주세요', Colors.black),
              actions: <Widget>[
                myButton('확인', Colors.black),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pageTitle(title: widget.screenTitle),
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).devicePixelRatio * 10,
              left: MediaQuery.of(context).size.width * 0.03,
              right: MediaQuery.of(context).size.width * 0.03),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(249, 229, 134, 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _textController,
            onSubmitted: widget.type == '신고'
                ? handleReportSubmitted
                : handleCheckSubmitted,
            decoration: InputDecoration(
              hintText: widget.hiddenMessage,
              contentPadding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              border: InputBorder.none,
            ),
            style: TextStyle(
                fontSize: MediaQuery.of(context).devicePixelRatio * 5),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!_textController.text.isEmpty) {
              widget.type == '신고'
                  ? handleReportSubmitted(_textController.text)
                  : handleCheckSubmitted(_textController.text);
              // _setActive();
            } else
              handleNullSubmitted();
          },
          child: Center(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).devicePixelRatio * 50,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              padding:
                  EdgeInsets.all(MediaQuery.of(context).devicePixelRatio * 6),
              height: MediaQuery.of(context).devicePixelRatio * 23,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffF9E586),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.buttonName,
                style: TextStyle(
                  fontFamily: "Happiness-Sans-Bold",
                  fontSize: MediaQuery.of(context).devicePixelRatio * 7,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
