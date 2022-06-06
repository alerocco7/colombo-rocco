import 'package:flutter/material.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:colombo_rocco/utils/strings.dart';

class ProfilePage extends StatelessWidget {
  static const route = '/profilepage/';
  static const routename = 'Profilepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              child: Text('To Homepage'),
              onPressed: () {
                Navigator.pop(context);
              }),
          ElevatedButton(
              child: Text('To Relation'),
              onPressed: () {
                Navigator.pushNamed(context, '/relation/');
              }),
          ElevatedButton(
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
                type: 'steps',
              );

              //Fetch data
              final stepsData = await fitbitActivityTimeseriesDataManager
                  .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
                date: DateTime.now().subtract(Duration(days: 1)),
                userID: userId,
                resource: fitbitActivityTimeseriesDataManager.type,
              )) as List<FitbitActivityTimeseriesData>;

              // Use them as you want
              final snackBar = SnackBar(
                  content: Text(
                      'Yesterday you walked ${stepsData[0].value} steps!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text('Tap to download steps data'),
          ),
          ElevatedButton(
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
              final sleepData = await fitbitSleepDataManager
                  .fetch(FitbitSleepAPIURL.withUserIDAndDateRange(
                startDate: DateTime.now().subtract(Duration(days: 7)),
                endDate: DateTime
                    .now(), //if we want data from 1 week we are not in the right URL, we have to change it
                userID: userId,
              )) as List<FitbitSleepData>;
            },
            child: Text('Tap to download sleep data'),
          ),
          ElevatedButton(
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
