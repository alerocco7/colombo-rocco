import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';

class RelationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Relation Page')),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: Text('To ProfilePage'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
                child: Text('prova'),
                onPressed: () async {
                  DateTime day =
                      DateTime.now().subtract(const Duration(days: 30));
                  List prova = await Provider.of<DatabaseRepository>(context,
                          listen: false)
                      .findAllSleep();
                  for (var i = 0; i < prova.length; i++) {
                    print(prova.elementAt(i).day.toString());
                    print(prova.elementAt(i).deep.toString());
                    print(prova.elementAt(i).wake.toString());
                    print(prova.elementAt(i).light.toString());
                    print(prova.elementAt(i).rem.toString());
                    print('calorie $prova.elementAt(i).calories.toString()');
                  }
                })
          ]),
        ));
  }
}
