import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:colombo_rocco/utils/predictionFunc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  //SharedPreferences method to persist username and password
  void logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    Navigator.of(context).pushReplacementNamed('/login/');
  }

  //CircularChart data initialization
  late List<Phases> chartData;

  @override
  void initState() {
    chartData = getChartData(Sleep(
        DateTime.now(), 10, 20, 30, 40, 0)); //initialization with random values
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 167, 192, 3),
          title: Text(DateFormat.yMMMMd().format(DateTime.now()),
              style: TextStyle(color: Color.fromARGB(255, 6, 6, 6))),
          actions: <Widget>[
            IconButton(
              icon:
                  const Icon(Icons.logout, color: Color.fromARGB(255, 6, 6, 6)),
              tooltip: 'Logout',
              onPressed: () {
                logout(context);
              },
            ),
          ]),
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(108, 109, 107, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 167, 192, 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      'a page',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ],
                )),
            ListTile(
                leading: Icon(Icons.account_box),
                title: Text('Your profile',
                    style:
                        TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                onTap: () {
                  Navigator.pushNamed(context, '/profilepage/');
                }),
            ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text('Calendar archive',
                    style:
                        TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                onTap: () {
                  Navigator.pushNamed(context, '/calendarpage/');
                }),
            ListTile(
                leading: Icon(Icons.graphic_eq_sharp),
                title: Text('Calories & sleep efficiency relation',
                    style:
                        TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                onTap: () {
                  Navigator.pushNamed(context, '/relation/');
                }),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Stack(
              children: <Widget>[
                Text(
                  'AppredicT',
                  style: TextStyle(
                    fontSize: 60,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 8
                      ..color = Color.fromARGB(255, 167, 192, 3),
                  ),
                ),
                Text(
                  'AppredicT',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Consumer<DatabaseRepository>(builder: (context, dbr, child) {
              return FutureBuilder(
                  initialData: null,
                  future: dbr.findAllSleep(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as List<Sleep?>;
                      final today = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day);
                      if (data.isEmpty || data.last!.day != today) { //in first access, database is empty || at the first daily access, you must update your data
                        return Column(children: [
                          SizedBox(height: 140),
                          const Text('Update your data to proceed',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 6, 6, 6),
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic)),
                          SizedBox(height: 13),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(185, 6, 6, 6),
                                  fixedSize: const Size(200, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35))),
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

                                //variables initialization
                                DateTime? date = today;
                                int deepCount = 0;
                                int remCount = 0;
                                int wakeCount = 0;
                                int lightCount = 0;
                                
                                //database filling with the last data (if calories are present and sleep data not yet)
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

                                  //database filling, we have two lists (sleepData and caloriesData), 
                                  //the first for cycle counts the sleep phases,
                                  //whenever the day changes the other for cycle 
                                  //look for the corresponding Calories value (of the day before)
                                  //and breaks when it founds it.
                                  //Then the Sleep object is created and inserted in the database.
                                  //After this the counters are updated and the next day is considered

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
                                  //there are some wrong data fetched, where all the phases are 0
                                  //we descard it
                                  await Provider.of<DatabaseRepository>(context,
                                          listen: false)
                                      .deleteNotSleeping();
                                }
                              },
                              child: Text('Update'))
                        ]);
                      } else { //when data are updated, the page is filled with some data visualization and a circular chart
                        chartData = getChartData(data.last);
                        int tot = (data.last!.deep!.toDouble() +
                                data.last!.rem!.toDouble() +
                                data.last!.light!.toDouble() +
                                data.last!.wake!.toDouble())
                            .round();
                        int deep_perc =
                            ((data.last!.deep!.toDouble() / (tot)) * 100)
                                .round();
                        int rem_perc =
                            (data.last!.rem!.toDouble() / (tot) * 100).round();
                        int light_perc =
                            (data.last!.light!.toDouble() / (tot) * 100)
                                .round();
                        int wake_perc =
                            (data.last!.wake!.toDouble() / (tot) * 100).round();
                        double mintot = tot / 2;
                        int oreTot = (mintot ~/ 60);
                        double minuti = mintot - oreTot * 60;
                        double eff = sleepEfficiency(data.last);
                        List<double> parametri = predictionPar(
                            data); //List with linear prediction parameters(i=0,1) and sleepEffMean(i=2)

                        double SleepEffMean = parametri.elementAt(2);
                        double sleepEffresp2Mean =
                            sleepEfficiency(data.last) - SleepEffMean;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Here some data for you...',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 6, 6, 6))),
                            SizedBox(height: 15),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color.fromARGB(255, 167, 192, 3),
                              child: Column(
                                children: [
                                  Text(
                                    'Yesterday you spent ${data.last!.caloriesDaybefore!.toInt()} kcal',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      'Tonight you slept: ' +
                                          oreTot.toString() +
                                          ' hours ${minuti.round()} minutes',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 5),
                                  Text(
                                      '- Deep sleep: ' +
                                          deep_perc.toString() +
                                          ' % of your rest',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 5),
                                  Text(
                                      '- Rem sleep: ' +
                                          rem_perc.toString() +
                                          ' % of your rest',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 5),
                                  Text(
                                      '- Light sleep: ' +
                                          light_perc.toString() +
                                          ' % of your rest',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 5),
                                  Text(
                                      '- Wake sleep: ' +
                                          wake_perc.toString() +
                                          ' % of your rest',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('EFFICIENCY:  ${eff.toInt()}/100',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            _printEff2mean(sleepEffresp2Mean),
                            SizedBox(
                              height: 6.5,
                            ),
                            SfCircularChart(
                                title: ChartTitle(
                                    text: 'MINUTES SPENT IN EACH PHASE',
                                    backgroundColor:
                                        Color.fromARGB(255, 155, 202, 243),
                                    textStyle: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 0, 0, 255))),
                                legend: Legend(
                                    isVisible: true,
                                    overflowMode: LegendItemOverflowMode.wrap,
                                    backgroundColor:
                                        Color.fromARGB(255, 155, 202, 243),
                                    textStyle: TextStyle(fontSize: 20),
                                    iconHeight: 25,
                                    iconWidth: 25),
                                palette: [
                                  Color.fromARGB(255, 148, 205, 255),
                                  Color.fromARGB(255, 23, 137, 237),
                                  Color.fromARGB(255, 3, 83, 154),
                                  Color.fromARGB(255, 1, 56, 105)
                                ],
                                series: <CircularSeries>[
                                  RadialBarSeries<Phases, String>(
                                    maximumValue: 370,
                                    trackColor: Color.fromARGB(255, 61, 74, 83),
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
          ],
        ),
      ),
    );
  }
}

//Based on the different input (positiv or negative) this function returns two different Text Widgets
Widget _printEff2mean(double sleepEffresp2Mean) {
  if (sleepEffresp2Mean > 0) {
    return Text(
        '${sleepEffresp2Mean.toInt()}% more respect to your mean efficiency',
        style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold));
  } else if (sleepEffresp2Mean == 0) {
    return SizedBox(height: 1); // if is equal to the mean return nothing
  } else {
    return Text(
        '${sleepEffresp2Mean.abs().toInt()}% less respect to your mean efficiency',
        style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold));
  }
}
