import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';

class RelationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Color.fromARGB(255, 167, 192, 3),title: Text('Relation Page',style: TextStyle(color: Color.fromARGB(255, 6, 6, 6)),)),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: Text('To ProfilePage'),
              style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
                child: Text('prova'),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
                onPressed: () async {
                  DateTime day =
                      DateTime.now().subtract(const Duration(days: 30));
                  List<Sleep?> prova = await Provider.of<DatabaseRepository>(
                          context,
                          listen: false)
                      .findSleepByfirstday(day);
                  for (var i = 0; i < prova.length; i++) {
                    
                    double mintot = prova.elementAt(i)!.deep!.toDouble() +
                        prova.elementAt(i)!.light!.toDouble() +
                        prova.elementAt(i)!.rem!.toDouble() +
                        prova.elementAt(i)!.wake!.toDouble();
                    double efficiency = 100 * (prova.elementAt(i)!.deep!.toDouble()) / mintot;
                    
                    print(prova.elementAt(i)!.day.toString());
                    print('efficiency: $efficiency');
                    print(prova.elementAt(i)!.deep.toString());
                    print(prova.elementAt(i)!.wake.toString());
                    print(prova.elementAt(i)!.light.toString());
                    print(prova.elementAt(i)!.rem.toString());
                  }
                  
                }),
                ElevatedButton(
                child: Text('prova2'),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
                onPressed: () async {
                  DateTime oggi = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().subtract(Duration(days: 2)).day);
                  Sleep? prova = await Provider.of<DatabaseRepository>(
                          context,
                          listen: false)
                      .findSleepByday(oggi) ;
                      print(prova!.deep.toString());}),
            ElevatedButton(
                child: Text('calorie'),
                style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
                onPressed: () async {
                  DateTime day =
                      DateTime.now().subtract(const Duration(days: 30));
                  List<Activity?> calorie =
                      await Provider.of<DatabaseRepository>(context,
                              listen: false)
                          .findCaloriesByfirstday(day);
                  for (var i = 0; i < calorie.length; i++) {
                    print(calorie.elementAt(i)!.day.toString());
                    print(calorie.elementAt(i)!.calories.toString());
                  }
                }),
          ]),
        ));
  }
}
