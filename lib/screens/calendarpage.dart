import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:intl/intl.dart';

//This is the class that implement the page to be used to edit existing meals and add new meals.
//This is a StatefulWidget since it needs to rebuild when the form fields change.
class calendarPage extends StatefulWidget {
  //We are passing the Meal to be edited. If it is null, the business logic will know that we are adding a new
  //Meal instead.

  //MealPage constructor
  calendarPage({Key? key}) : super(key: key);

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
                  return Center(
                      child: Text(
                          'In the selected day no sleep data were collected, please try to choose another day',
                          textScaleFactor: 1.5, textAlign: TextAlign.center) );
                } else {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${DateFormat.yMMMMd().format(data.day)}'),
                      Text('${data.deep}'),
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
                  return Center(
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

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
    //Here, I'm using setState to update the _selectedDate field and rebuild the UI.
  }
}
