import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

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

              ElevatedButton(
                child: Text('To Prediction'),
                onPressed: () {
                  Navigator.pushNamed(context, '/prediction/');
                }
              ),
            ]
        ),
      ),
    );
  }
}