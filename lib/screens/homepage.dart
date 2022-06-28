import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:colombo_rocco/utils/predictionFunc.dart';
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
  List<double> parametri = [];
  @override
  void initState() {
    chartData = getChartData(Sleep(DateTime.now(), 10, 20, 30, 40, 0));
    parametri;
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
                    if (snapshot.hasData) {
                      final data = snapshot.data as List<Sleep>;
                      parametri = predictionPar(data);

                      final today = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day);
                      if (data.isEmpty || data.last.day != today) {
                        //in first access, database is empty || at the first daily access, you must update your data

                        return Column(children: [
                          const Text('Update your data to proceed'),
                          ElevatedButton(
                              onPressed: () async {
                                // Authorize the app
                                String? userId =
                                    await FitbitConnector.authorize(
                                        context: context,
                                        clientID: Strings.fitbitClientID,
                                        clientSecret:
                                            Strings.fitbitClientSecret,
                                        redirectUri: Strings.fitbitRedirectUri,
                                        callbackUrlScheme:
                                            Strings.fitbitCallbackScheme);

                                //Instantiate a proper data manager
                                FitbitSleepDataManager fitbitSleepDataManager =
                                    FitbitSleepDataManager(
                                  clientID: Strings.fitbitClientID,
                                  clientSecret: Strings.fitbitClientSecret,
                                );

                                //Fetch data
                                final sleepData =
                                    await fitbitSleepDataManager //platform exception
                                        .fetch(FitbitSleepAPIURL
                                            .withUserIDAndDateRange(
                                  startDate: DateTime.now()
                                      .subtract(const Duration(days: 100)),
                                  endDate: DateTime.now(),
                                  userID: userId,
                                )) as List<FitbitSleepData>;

                                FitbitActivityTimeseriesDataManager
                                    fitbitActivityTimeseriesDataManager =
                                    FitbitActivityTimeseriesDataManager(
                                  clientID: Strings.fitbitClientID,
                                  clientSecret: Strings.fitbitClientSecret,
                                  type: 'calories',
                                );

                                //Fetch data
                                final caloriesData =
                                    await fitbitActivityTimeseriesDataManager
                                        .fetch(FitbitActivityTimeseriesAPIURL
                                            .dateRangeWithResource(
                                  startDate: DateTime.now()
                                      .subtract(const Duration(days: 100)),
                                  endDate: DateTime.now(),
                                  userID: userId,
                                  resource:
                                      fitbitActivityTimeseriesDataManager.type,
                                )) as List<FitbitActivityTimeseriesData>;

                                print(caloriesData.last);
                                print(caloriesData
                                    .elementAt(caloriesData.length - 2));
                                print(sleepData.elementAt(0));
                                print(sleepData.elementAt(1));

                                DateTime? date = today;
                                int deepCount = 0;
                                int remCount = 0;
                                int wakeCount = 0;
                                int lightCount = 0;

                                for (var j = 0;
                                    j < caloriesData.length - 1;
                                    j++) {
                                  if (caloriesData
                                          .elementAt(j)
                                          .dateOfMonitoring ==
                                      today) {
                                    Sleep soloCalorie = Sleep(
                                        today.add(Duration(days: 1)),
                                        null,
                                        null,
                                        null,
                                        null,
                                        caloriesData.elementAt(j).value);
                                    await Provider.of<DatabaseRepository>(
                                            context,
                                            listen: false)
                                        .insertSleepStages(soloCalorie);
                                    break;
                                  }

                                  for (var i = 0;
                                      i < sleepData.length - 1;
                                      i++) {
                                    if (sleepData.elementAt(i).dateOfSleep ==
                                        date) {
                                      if (sleepData.elementAt(i).level ==
                                          'deep') {
                                        deepCount = deepCount + 1;
                                      } else if (sleepData.elementAt(i).level ==
                                          'rem') {
                                        remCount = remCount + 1;
                                      } else if (sleepData.elementAt(i).level ==
                                          'wake') {
                                        wakeCount = wakeCount + 1;
                                      } else if (sleepData.elementAt(i).level ==
                                          'light') {
                                        lightCount = lightCount + 1;
                                      }
                                    } else {
                                      for (var j = 0;
                                          j < caloriesData.length - 1;
                                          j++) {
                                        if (caloriesData
                                                .elementAt(j)
                                                .dateOfMonitoring ==
                                            date!.subtract(Duration(days: 1))) {
                                          double? caloriesDayBefore =
                                              caloriesData.elementAt(j).value;
                                          Sleep dormi = Sleep(
                                              //create the object
                                              date,
                                              deepCount,
                                              lightCount,
                                              remCount,
                                              wakeCount,
                                              caloriesDayBefore);
                                          await Provider.of<DatabaseRepository>(
                                                  context,
                                                  listen: false)
                                              .insertSleepStages(dormi);
                                          break;
                                        }
                                      }

                                      date = sleepData.elementAt(i).dateOfSleep;
                                      deepCount = 0;
                                      remCount = 0;
                                      wakeCount = 1;
                                      lightCount = 0;
                                    }
                                  }
                                  await Provider.of<DatabaseRepository>(context,
                                          listen: false)
                                      .deleteNotSleeping();
                                }
                              },
                              child: Text('Update your data'))
                        ]);
                      } else {
                        chartData = getChartData(data.last);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Yesterday you spent ' +
                                data.last.caloriesDaybefore.toString()),
                            Text('Date:' + data.last.day.toString()),
                            Text('Deep(min): ' + data.last.deep.toString()),
                            Text('Rem(min): ' + data.last.rem.toString()),
                            Text('Light(min): ' + data.last.light.toString()),
                            Text('Wake(min): ' + data.last.wake.toString()),
                            SfCircularChart(
                                title: ChartTitle(
                                    text:
                                        'Minutes spent in each phases last night'),
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    backgroundColor:
                                        Color.fromARGB(255, 144, 238, 229),
                                    textStyle: TextStyle(fontSize: 25),
                                    iconHeight: 30,
                                    iconWidth: 25),
                                palette: [
                                  Color.fromARGB(255, 6, 246, 218),
                                  Color.fromARGB(255, 3, 133, 247),
                                  Color.fromARGB(255, 3, 30, 234),
                                  Color.fromARGB(255, 0, 2, 92)
                                ],
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
                        );
                      }
                    } else {
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
                  Navigator.pushNamed(context, '/calendarpage/',
                      arguments: parametri);
                }),
            ElevatedButton(
                child: const Text('To Relation'),
                onPressed: () {
                  Navigator.pushNamed(context, '/relation/');
                }),
          ],
        ),
      ),
    );
  }
}
