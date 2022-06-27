import 'package:colombo_rocco/screens/profilepage.dart';
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
          icon: const Icon(Icons.logout,color: Color.fromARGB(255, 6, 6, 6)),
          tooltip: 'Logout',
          onPressed: () {
            logout(context);
          },
        ),
      ]),
       drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 167, 192, 3),
              ),
              child:
                Text('Home',style: TextStyle(fontSize: 27),),
                 
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('To ProfilePage',style: TextStyle(fontSize: 20)),
              onTap: () {
                  Navigator.pushNamed(context, '/profilepage/');
              }
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('To CalendarPage',style: TextStyle(fontSize: 20)),
              onTap: () {
                  Navigator.pushNamed(context, '/calendarpage/');
              }
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text('To NotePage',style: TextStyle(fontSize: 20)),
              onTap: () {
                  Navigator.pushNamed(context, '/notepage/');
              }
            ),
             ListTile(
              leading: Icon(Icons.graphic_eq_sharp),
              title: Text('To RelationPage',style: TextStyle(fontSize: 20)),
              onTap: () {
                  Navigator.pushNamed(context, '/relation/');
              }
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('To ProfiloPage',style: TextStyle(fontSize: 20)),
              onTap: () {
                  Navigator.pushNamed(context, '/profile');
              }
            ),
          ],
        ),
       ),
    );
  }
  
}
