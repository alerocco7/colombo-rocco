import 'package:colombo_rocco/screens/calendarpage.dart';
import 'package:colombo_rocco/screens/homepage.dart';
import 'package:colombo_rocco/screens/notepage.dart';
import 'package:colombo_rocco/screens/profilepage.dart';
import 'package:flutter/material.dart';

import 'package:colombo_rocco/screens/login.dart';

void main() {
  runApp(const MyApp());
} //main

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This specifies the app entrypoint
      initialRoute: '/login/',
      //This maps names to the set of routes within the app
      routes: {
        '/login/': (context) => Login(),
        '/homepage/':(context) => HomePage(),
        '/profilepage/':(context) => ProfilePage(),
        '/notepage/': (context) => NotePage(),
        '/calendarpage/': (context) => CalendarPage(),
      },
    );
  } //build
}//MyApp