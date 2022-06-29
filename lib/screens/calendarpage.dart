import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:colombo_rocco/utils/predictionFunc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  String? thisorthat;

  double? a;
  double? b;

  @override
  void initState() {
    final giorno = DateTime.now().day;
    final mese = DateTime.now().month;
    final anno = DateTime.now().year;
    _selectedDate = DateTime(anno, mese, giorno);
    thisorthat = 'last';
    a = 0;
    b = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getparametri();
    //The page is composed of a form. An action in the AppBar is used to validate and save the information provided by the user.
    //A FAB is showed to provide the "delete" functinality. It is showed only if the meal already exists.
    return Scaffold(
      appBar: AppBar(
          title: Text(DateFormat.yMMMMd().format(_selectedDate)),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 167, 192, 3)),
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
                  return Center(
                      child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color.fromARGB(255, 167, 192, 3),
                    child: Text(
                        'In the selected day no sleep data were collected, please try to choose another day',
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center),
                  ));
                } else {
                  var chartData = getChartData(data);
                  int tot = (data.deep!.toDouble() +
                          data.rem!.toDouble() +
                          data.light!.toDouble() +
                          data.wake!.toDouble())
                      .round();
                  double mintot = tot / 2;
                  int oreTot = (mintot ~/ 60);
                  double minuti = mintot - oreTot * 60;
                  double eff = sleepEfficiency(data);

                  int prediction = predictionFunc(data.caloriesDaybefore,
                      a!, b!).round();

                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Color.fromARGB(255, 167, 192, 3),
                        child: Column(children: [
                          Text(
                              'In ${DateFormat.yMMMMd().format(_selectedDate)} you slept $oreTot hour ${minuti.round()} minutes',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              'The day before you spent ${data.caloriesDaybefore} kcal.',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              'Based on your data, for this night',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500)),
                            Text(
                              'the sleep efficiency prediction was $prediction%,',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              'instead $thisorthat night ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500)),
                          Text(
                              'your effective efficiency was $eff%',
                                 style: TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500)),
                        ]),
                      ),
                      SfCircularChart(
                          title: ChartTitle(
                              text:
                                  'How you slept $thisorthat night                                   (minutes spent in each phase)',
                              backgroundColor:
                                  Color.fromARGB(255, 155, 202, 243)),
                          legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              backgroundColor:
                                  Color.fromARGB(255, 155, 202, 243),
                              textStyle: TextStyle(fontSize: 25),
                              iconHeight: 30,
                              iconWidth: 25),
                          palette: [
                            Color.fromARGB(255, 70, 160, 239),
                            Color.fromARGB(255, 23, 137, 237),
                            Color.fromARGB(255, 3, 83, 154),
                            Color.fromARGB(255, 1, 56, 105)
                          ],
                          series: <CircularSeries>[
                            PieSeries<Phases, String>(
                                dataSource: chartData,
                                xValueMapper: (Phases data, _) => data.phase,
                                yValueMapper: (Phases data, _) => data.time,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true)),
                          ]),
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
        firstDate: DateTime(2020),
        lastDate: DateTime.now());

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      if (picked ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        setState(() {
          thisorthat = 'last';
        });
      } else {
        setState(() {
          thisorthat = 'that';
        });
      }
    }
    //Here, I'm using setState to update the _selectedDate field and rebuild the UI.
  }

  void _getparametri() async {
    final sp = await SharedPreferences.getInstance();
    final double? apar = sp.getDouble('apar');
    final double? bpar = sp.getDouble('bpar');

    setState(() {
      a = apar;
      b = bpar;
    });
  }
}
