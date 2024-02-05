import 'package:flutter/material.dart';

class reportPage extends StatefulWidget {
  const reportPage({super.key});

  @override
  State<reportPage> createState() => _reportPageState();
}

class _reportPageState extends State<reportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
