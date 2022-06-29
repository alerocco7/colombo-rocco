import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/phases.dart';

//This is the class that implement the page to be used to edit existing meals and add new meals.
//This is a StatefulWidget since it needs to rebuild when the form fields change.
class calendarPage extends StatefulWidget {
  //We are passing the Meal to be edited. If it is null, the business logic will know that we are adding a new
  //Meal instead.

  //MealPage constructor
  const calendarPage({Key? key}) : super(key: key);

  static const route = '/calendarpage/';
  static const routeDisplayName = 'Calendar Page';

  @override
  State<calendarPage> createState() => _calendarPageState();
}

class _calendarPageState extends State<calendarPage> {
 
  DateTime _selectedDate = DateTime.now();

  Sleep? sleepdata;
  Activity? activitydata;
  

  @override
  void initState() {
    final giorno = DateTime.now().day; 
    final mese = DateTime.now().month; 
    final anno = DateTime.now().year; 
    _selectedDate = DateTime(anno,mese,giorno);
    
    

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Print the route display name for debugging
    print('${calendarPage.routeDisplayName} built');

    //The page is composed of a form. An action in the AppBar is used to validate and save the information provided by the user.
    //A FAB is showed to provide the "delete" functinality. It is showed only if the meal already exists.
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat.yMMMMd().format(_selectedDate)),centerTitle: true),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          //The logic is to query the DB for the entire list of Todo using dbr.findAllTodos()
          //and then populate the ListView accordingly.
          //We need to use a FutureBuilder since the result of dbr.findAllTodos() is a Future.
          return FutureBuilder(
              initialData: sleepdata,
              future: dbr.findSleepByday(_selectedDate),
              builder: (context, snapshot) {
                final data = snapshot.data as Sleep?;
                if (data == null) {
                  return const Center(
                      child: Text(
                          'In the selected day no sleep data were collected, please try to choose another day',
                          textScaleFactor: 1.5, textAlign: TextAlign.center) );
                } else {
                  var chartData = getChartData(data);
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(DateFormat.yMMMMd().format(data.day)),
                      Text('${data.deep}'),
                      SfCircularChart(
                                title: ChartTitle(
                                    text:
                                        'How you slept last night                                   (minutes spent in each phases)',backgroundColor: Color.fromARGB(255, 198, 197, 197)),
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    backgroundColor:
                                         Color.fromARGB(255, 155, 202, 243),
                                    textStyle: TextStyle(fontSize: 25),
                                    iconHeight: 30,
                                    iconWidth: 25),
                                    palette: [Color.fromARGB(255, 70, 160, 239), Color.fromARGB(255, 23, 137, 237),Color.fromARGB(255, 3, 83, 154),Color.fromARGB(255, 1, 56, 105)],
                                series: <CircularSeries>[
                                  PieSeries<Phases, String>(
                                      dataSource: chartData,
                                      xValueMapper: (Phases data, _) =>
                                          data.phase,
                                      yValueMapper: (Phases data, _) =>
                                          data.time,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true)),
                                ]),
                    ],
                  ));
                }
              });
        }),

         Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          //The logic is to query the DB for the entire list of Todo using dbr.findAllTodos()
          //and then populate the ListView accordingly.
          //We need to use a FutureBuilder since the result of dbr.findAllTodos() is a Future.
          return FutureBuilder(
              initialData: activitydata,
              future: dbr.findActivityByday(_selectedDate),
              builder: (context, snapshot) {
                final data = snapshot.data as Activity?;
                if (data == null) {
                  return const Center(
                      child: Text(
                          'In the selected day no activity data were collected, please try to choose another day',
                          textScaleFactor: 1.5, textAlign: TextAlign.center) );
                } else {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${data.calories}'),
                    ],
                  ));
                }
              });
        }),

        ElevatedButton(
          onPressed: () async {
            _selectDate(context);
            Sleep? prova =
                await Provider.of<DatabaseRepository>(context, listen: false)
                    .findSleepByday(_selectedDate);
          },
          child: const Text('SELECT THE DAY'),
        ) //else
      ]),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime.now());

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    //Here, I'm using setState to update the _selectedDate field and rebuild the UI.
  }
}
