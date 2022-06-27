import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';

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
  DateTime _selectedDate = DateTime.now().subtract(Duration(days: 1));

  Sleep? prova = Sleep(DateTime.now(), 0, 0, 0, 0);

  @override
  void initState() {
    
    _selectedDate = DateTime.now();
    Sleep? prova = Sleep(DateTime.now(), 0, 0, 0, 0);


    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    //Print the route display name for debugging
    print('${calendarPage.routeDisplayName} built');

    //The page is composed of a form. An action in the AppBar is used to validate and save the information provided by the user.
    //A FAB is showed to provide the "delete" functinality. It is showed only if the meal already exists.
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 167, 192, 3),title: Text(calendarPage.routeDisplayName,style: TextStyle(color: Color.fromARGB(255,6,6,6)),)),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Consumer<DatabaseRepository>(builder: (context, dbr, child) {
          //The logic is to query the DB for the entire list of Todo using dbr.findAllTodos()
          //and then populate the ListView accordingly.
          //We need to use a FutureBuilder since the result of dbr.findAllTodos() is a Future.
          return FutureBuilder(
              initialData: prova,
              future: dbr.findSleepByday(_selectedDate),
              builder: (context, snapshot) {
                final data = snapshot.data as Sleep?;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${data!.day}'),
                    Text('${data.deep}'),
                  ],
                );
              });
        }),

        ElevatedButton(
          onPressed: () async {
            _selectDate(context);
            Sleep? prova = await
                Provider.of<DatabaseRepository>(context, listen: false)
                    .findSleepByday(_selectedDate);
          },
          child: const Text('SELECT THE DAY'),
          style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
        ) //else
      ]
          //   child: ElevatedButton(
          //                  onPressed: () {
          //                 _selectDate(context);
          //             },
          //              child: const Text('SELECT THE DAY'),
          //           )
          ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
      //Here, I'm using setState to update the _selectedDate field and rebuild the UI.

     
  } }
