import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  static const route = '/profilepage/';
  static const routename = 'Profilepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
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