import 'package:flutter/material.dart';

class NotePage extends StatelessWidget {
  static const route = '/notepage/';
  static const routename = 'Noteepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Note Page')),
      body: Center(
        child: ElevatedButton(
          child: Text('To Homepage'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}