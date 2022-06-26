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
      appBar: AppBar(title: const Text('Note Page')),
      body: Center(child: Consumer<DatabaseRepository>(
        builder: (context, dbr, child) {
          return FutureBuilder(
              initialData: null,
              future: dbr.findSleepByfirstday(DateTime.now().subtract(const Duration(days: 7))),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      )),
    );
  }
}
