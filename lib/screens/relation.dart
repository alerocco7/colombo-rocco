import 'package:flutter/material.dart';

class RelationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //this is not a meterial app but just a scaffold
      appBar: AppBar(title: Text('Relation Page')),
      body: Center(
        child: ElevatedButton(
          child: Text('To ProfilePage'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}