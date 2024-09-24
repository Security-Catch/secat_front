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
        fontSize: MediaQuery.of(context).devicePixelRatio * 4.8,
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
    try {
      final url = Uri.parse("http://118.221.127.42:8000/detect")
          .replace(queryParameters: {
        'message': text,
      });

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        // var jsonResponse = jsonDecode(response.body);
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final code = jsonResponse['code'];

        if (code == 200) {
          var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
          print(jsonResponse['result']);
          _active = jsonResponse['result'];

          String imageUrl =
              _active ? 'asset/safeLogo.png' : 'asset/dangerLogo.png';
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
        } else {
          print('서버 에러: ${jsonResponse['error'] ?? '에러 정보가 없습니다.'}');
          await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                    content: myText(
                        '서버 에러: ${jsonResponse['error'] ?? '에러 정보가 없습니다.'}',
                        Colors.black),
                    actions: <Widget>[
                      myButton("확인", Colors.black),
                    ]);
              });
        }
      } else {
        // 상태 코드가 200이 아닌 경우
        print('응답 에러: ${response.statusCode}');
        print('응답 본문: ${response.body}'); // 응답 전체를 출력해서 구조 확인
        try {
          // 에러 메시지가 'error' 필드에 있는지 확인
          final errorResponse = jsonDecode(response.body);
          print(
              '에러 메시지: ${errorResponse['error'] ?? '서버가 에러 메시지를 보내지 않았습니다.'}');
          await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                    content: myText(
                        errorResponse['error'] ?? '서버가 에러 메시지를 보내지 않았습니다.',
                        Colors.black),
                    actions: <Widget>[
                      myButton("확인", Colors.black),
                    ]);
              });
        } catch (jsonError) {
          // JSON 파싱 에러 처리
          print('응답을 JSON으로 파싱하는 중 에러 발생: $jsonError');
        }
      }
    } catch (e) {
      print('네트워크 또는 서버 에러 발생: $e');
    }
  }

  void handleReportSubmitted(String text) async {
    try {
      final url = Uri.parse("http://118.221.127.42:8000/detect")
          .replace(queryParameters: {
        'message': text,
      });

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        final code = jsonResponse['code'];

        if (code == 200) {
          var jsonResponse = jsonDecode(response.body);
          print(jsonResponse);
          _active = jsonResponse['isSuccess'];
          if (_active) {
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
        } else {
          print('서버 에러: ${jsonResponse['error'] ?? '에러 정보가 없습니다.'}');
          await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                    content: myText(
                        '서버 에러: ${jsonResponse['error'] ?? '에러 정보가 없습니다.'}',
                        Colors.black),
                    actions: <Widget>[
                      myButton("확인", Colors.black),
                    ]);
              });
        }
      } else {
        // 상태 코드가 200이 아닌 경우
        print('응답 에러: ${response.statusCode}');
        print('응답 본문: ${response.body}'); // 응답 전체를 출력해서 구조 확인
        try {
          // 에러 메시지가 'error' 필드에 있는지 확인
          final errorResponse = jsonDecode(response.body);
          print(
              '에러 메시지: ${errorResponse['error'] ?? '서버가 에러 메시지를 보내지 않았습니다.'}');
          await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                    content: myText(
                        errorResponse['error'] ?? '서버가 에러 메시지를 보내지 않았습니다.',
                        Colors.black),
                    actions: <Widget>[
                      myButton("확인", Colors.black),
                    ]);
              });
        } catch (jsonError) {
          // JSON 파싱 에러 처리
          print('응답을 JSON으로 파싱하는 중 에러 발생: $jsonError');
        }
      }
    } catch (e) {
      print('네트워크 또는 서버 에러 발생: $e');
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
