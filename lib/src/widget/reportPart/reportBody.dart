import 'package:flutter/material.dart';

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

  _setActive() {
    setState(() {
      _active = !_active;
    });
  }

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
                  '신고해주셔서 감사합니다\n신고해주신 메시지는 스미싱 검사 데이터로 사용됩니다\n더 나은 씨캣이 되도록 노력하겠습니다',
                  Colors.black),
              actions: <Widget>[
                myButton('확인', Colors.black),
              ]);
        });
  }

  void handleCheckSubmitted(String text) async {
    String imageUrl = _active ? 'asset/safeLogo.png' : 'asset/dangerLogo.png';
    String message = _active ? '90% 안전한 문자 입니다' : "90% 스미싱 문자로 의심됩니다";
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
                if (_active) myButton('신고하기', Colors.black),
              ]);
        });
  }

  void handleReportSubmitted(String text) async {
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

  void handleNullSubmitted() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
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
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).devicePixelRatio * 3, left: 45),
          child: Text(
            widget.screenTitle,
            style: TextStyle(
                fontSize: MediaQuery.of(context).devicePixelRatio * 5),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).devicePixelRatio * 10,
              left: 15,
              right: 15),
          padding: EdgeInsets.all(5),
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
              contentPadding: EdgeInsets.all(3),
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
              _setActive();
            } else
              handleNullSubmitted();
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).devicePixelRatio * 50,
                  left: 15,
                  right: 15),
              padding:
                  EdgeInsets.all(MediaQuery.of(context).devicePixelRatio * 6),
              height: MediaQuery.of(context).devicePixelRatio * 20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xffF9E586),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.buttonName,
                style: TextStyle(
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
