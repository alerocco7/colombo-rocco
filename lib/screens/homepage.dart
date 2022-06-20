import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colombo_rocco/screens/login.dart';
import 'package:colombo_rocco/utils/strings.dart';
import 'package:fitbitter/fitbitter.dart';

class HomePage extends StatelessWidget {
  static const route = '/homepage/';
  static const routename = 'Homepage';

  void logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    Navigator.of(context).pushReplacementNamed('/login/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 167, 192, 3),title: Text('HomePage',style: TextStyle(color: Color.fromARGB(255, 6, 6, 6)),), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            logout(context);
          },
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
                child: Text('To ProfilePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/profilepage/');
                }),
            ElevatedButton(
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
                child: Text('To CalendarPage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/calendarpage/');
                }),
            ElevatedButton(
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
                child: Text('To NotePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/notepage/');
                }),
            
          ],
        ),
      ),
    );
  }
}
