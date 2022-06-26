import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:colombo_rocco/utils/phases.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:colombo_rocco/utils/strings.dart';

class HomePage extends StatefulWidget {
  static const route = '/homepage/';
  static const routename = 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    Navigator.of(context).pushReplacementNamed('/login/');
  }

  late List<Phases> chartData;
  @override
  void initState() {
    chartData = getChartData(Sleep(DateTime.now(), 10, 20, 30, 40));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomePage'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
            logout(context);
          },
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Welcome back',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 30,
                    color: Color.fromARGB(255, 1, 63, 199))),
            Consumer<DatabaseRepository>(builder: (context, dbr, child) {
              return FutureBuilder(
                  initialData: null,
                  future: dbr.findAllSleep(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData ) {
                      final data = snapshot.data as List<Sleep?>;
                      if (data.length == 0) {
                        return Column(
                          children: [
                          Text('Fetch your data to proceed'),
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
              final sleepData =
                  await fitbitSleepDataManager //platform exception
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
            child: const Text('Tap to download 100 days sleep data'))]
          );
           }  else {
                      chartData = getChartData(data.last);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Date:' + data.last!.day.toString()),
                          Text('Deep(min): ' + data.last!.deep.toString()),
                          Text('Rem(min): ' + data.last!.rem.toString()),
                          Text('Light(min): ' + data.last!.light.toString()),
                          Text('Wake(min): ' + data.last!.wake.toString()),
                         
                          SfCircularChart(
                            title: ChartTitle(text: 'Minutes spent in each phases last night'),
                            legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, backgroundColor: Color.fromARGB(255, 27, 207, 14), textStyle: TextStyle(fontSize: 25), iconHeight: 30, iconWidth: 25),
                            series: <CircularSeries>[
                            PieSeries<Phases, String>(
                                dataSource: chartData,
                                xValueMapper: (Phases data, _) => data.phase,
                                yValueMapper: (Phases data, _) => data.time,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true)),
                          ]),
                        ],
                      );}
            } 
 
             else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            }),
            ElevatedButton(
                child: const Text('To ProfilePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/profilepage/');
                }),
            ElevatedButton(
                child: const Text('To CalendarPage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/calendarpage/');
                }),
            ElevatedButton(
                child: const Text('To NotePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/notepage/');
                }),
          ],
        ),
      ),
    );
  }
}
