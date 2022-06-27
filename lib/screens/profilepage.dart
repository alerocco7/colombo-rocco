import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:colombo_rocco/utils/strings.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  static const route = '/profilepage/';
  static const routename = 'Profilepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 167, 192, 3),title: Text('Profile Page',style: TextStyle(color: Color.fromARGB(255, 6, 6, 6)),)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              child: Text('To Homepage'),
              style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
              onPressed: () {
                Navigator.pop(context);
              }),
          ElevatedButton(
              child: Text('To Relation'),
              style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
              onPressed: () {
                Navigator.pushNamed(context, '/relation/');
              }),
          ElevatedButton(
            style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
            onPressed: () async {
              // Authorize the app
              String? userId = await FitbitConnector.authorize(
                  context: context,
                  clientID: Strings.fitbitClientID,
                  clientSecret: Strings.fitbitClientSecret,
                  redirectUri: Strings.fitbitRedirectUri,
                  callbackUrlScheme: Strings.fitbitCallbackScheme);

              //Instantiate a proper data manager
              FitbitActivityTimeseriesDataManager
                  fitbitActivityTimeseriesDataManager =
                  FitbitActivityTimeseriesDataManager(
                clientID: Strings.fitbitClientID,
                clientSecret: Strings.fitbitClientSecret,
                type: 'calories',
              );

              //Fetch data
              final caloriesData = await fitbitActivityTimeseriesDataManager
                  .fetch(FitbitActivityTimeseriesAPIURL.dateRangeWithResource(
                startDate: DateTime.now().subtract(const Duration(days: 100)),
                endDate: DateTime.now(),
                userID: userId,
                resource: fitbitActivityTimeseriesDataManager.type,
              )) as List<FitbitActivityTimeseriesData>;
              print(caloriesData);

              for (var i = 0; i < caloriesData.length - 1; i++) {
                DateTime? data = caloriesData.elementAt(i).dateOfMonitoring;
                double? calorie = caloriesData.elementAt(i).value;
               
                print(Activity(data!, calorie!).calories.toString());
                print(Activity(data, calorie).day.toString());
                await Provider.of<DatabaseRepository>(context, listen: false)
                    .insertActivity(Activity(data, calorie));
              }
              // Use them as you want
              final snackBar = SnackBar(
                  content: Text(
                      'Yesterday you spent ${caloriesData[0].value} calories!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text('Tap to download calories data'),
          ),
          ElevatedButton(
            style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
            onPressed: () async {
              // Authorize the app
              String? userId = await FitbitConnector.authorize(
                  context: context,
                  clientID: Strings.fitbitClientID,
                  clientSecret: Strings.fitbitClientSecret,
                  redirectUri: Strings.fitbitRedirectUri,
                  callbackUrlScheme: Strings.fitbitCallbackScheme);

              //Instantiate a proper data manager
              FitbitSleepDataManager fitbitSleepDataManager =
                  FitbitSleepDataManager(
                clientID: Strings.fitbitClientID,
                clientSecret: Strings.fitbitClientSecret,
              );

              //Fetch data
              final sleepData =  await fitbitSleepDataManager //platform exception
                  .fetch(FitbitSleepAPIURL.withUserIDAndDateRange(
                startDate: DateTime.now().subtract(const Duration(days: 100)),
                endDate: DateTime.now(),
                userID: userId,
              )) as List<FitbitSleepData>;
              print(sleepData);
              DateTime? data = DateTime.now();
              int deepCount = 0;
              int remCount = 0;
              int wakeCount = 0;
              int lightCount = 0;

              for (var i = 0; i < sleepData.length - 1; i++) {
                if (sleepData.elementAt(i).dateOfSleep == data) {
                  if (sleepData.elementAt(i).level == 'deep') {
                    deepCount = deepCount + 1;
                  } else if (sleepData.elementAt(i).level == 'rem') {
                    remCount = remCount + 1;
                  } else if (sleepData.elementAt(i).level == 'wake') {
                    wakeCount = wakeCount + 1;
                  } else if (sleepData.elementAt(i).level == 'light') {
                    lightCount = lightCount + 1;
                  }
                } else {
                  Sleep dormi =
                      Sleep(data!, deepCount, lightCount, remCount, wakeCount);
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertSleepStages(dormi);
                  data = sleepData.elementAt(i).dateOfSleep;
                  deepCount = 0;
                  remCount = 0;
                  wakeCount = 1;
                  lightCount = 0;
                }

              } 
                    await Provider.of<DatabaseRepository>(context, listen: false)
                    .deleteNotSleeping();
            },
            child: Text('Tap to download 100 days sleep data'),
          ),
          ElevatedButton(
            style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
            onPressed: () async {
              // Authorize the app
              String? userId = await FitbitConnector.authorize(
                  context: context,
                  clientID: Strings.fitbitClientID,
                  clientSecret: Strings.fitbitClientSecret,
                  redirectUri: Strings.fitbitRedirectUri,
                  callbackUrlScheme: Strings.fitbitCallbackScheme);

              //Instantiate a proper data manager
              FitbitSleepDataManager fitbitSleepDataManager =
                  FitbitSleepDataManager(
                clientID: Strings.fitbitClientID,
                clientSecret: Strings.fitbitClientSecret,
              );

              //Fetch data
              final sleepTonight = await fitbitSleepDataManager
                  .fetch(FitbitSleepAPIURL.withUserIDAndDay(
                date: DateTime.now(),
                userID: userId,
              )) as List<FitbitSleepData>;

              //print(sleepData);
              //FitbitSleepData dato = sleepData.elementAt(3);
              int deepCount = 0;
              int remCount = 0;
              for (var i = 0; i < sleepTonight.length; i++) {
                if (sleepTonight.elementAt(i).level == 'deep') {
                  deepCount = deepCount + 1;
                }
                if (sleepTonight.elementAt(i).level == 'rem') {
                  remCount = remCount + 1;
                }
              }
              int secondi = 30 * deepCount;
              double minuti = secondi / 60;
              double ore = minuti / 60;
              int remSecondi = 30 * remCount;
              double remMinuti = remSecondi / 60;
              double remOre = remMinuti / 60;
              print(
                  'Stanotte hai speso $secondi secondi in fase deep, $minuti minuti, $ore ore');
              print(
                  'Stanotte hai speso $remSecondi secondi in fase rem, $remMinuti minuti, $remOre ore');
            },
            child: Text('Tap to download today sleep data'),
          ),
          ElevatedButton(
            style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 34, 34, 34)),),
            onPressed: () async {
              await FitbitConnector.unauthorize(
                clientID: Strings.fitbitClientID,
                clientSecret: Strings.fitbitClientSecret,
              );
            },
            child: Text('Tap to unauthorize'),
          ),
        ]),
      ),
    );
  }
}
