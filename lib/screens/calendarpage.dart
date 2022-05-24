import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  static const route = '/calendarpage/';
  static const routename = 'Calendarpage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar Page')),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('To Homepage'),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
            ]
        ),
      ),
    );
  }
}