
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colombo_rocco/screens/login.dart';

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
      appBar: AppBar(title: Text('HomePage'), actions: <Widget>[
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
                child: Text('To ProfilePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/profilepage/');
                }),
            ElevatedButton(
                child: Text('To CalendarPage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/calendarpage/');
                }),
            ElevatedButton(
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
