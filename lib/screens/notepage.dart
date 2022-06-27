import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotePage extends StatelessWidget {
  static const route = '/notepage/';
  static const routename = 'Noteepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(backgroundColor: Color.fromARGB(255, 167, 192, 3),title: Text('Note Page',style: TextStyle(color: Color.fromARGB(255, 6, 6, 6)),)),
      body: Center(child: Consumer<DatabaseRepository>(
        builder: (context, dbr, child) {
          return FutureBuilder(
              initialData: null,
              future: dbr.findSleepByfirstday(DateTime.now().subtract(Duration(days: 7))),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List<Sleep?>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data.elementAt(2)!.day.toString()),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      )),
    );
  }
}
