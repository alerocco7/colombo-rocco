import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
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
  void logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    Navigator.of(context).pushReplacementNamed('/login/');
  }

  late List<Phases> chartData;
  @override
  void initState() {
    chartData = getChartData(Sleep(DateTime.now(), 10, 20, 30, 40, 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 167, 192, 3),title: Text('HomePage',style: TextStyle(color: Color.fromARGB(255, 6, 6, 6))), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout,color: Color.fromARGB(255, 6, 6, 6)),
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
              child:
                Text('Choose a page',style: TextStyle(fontSize: 27,fontStyle: FontStyle.italic),),
                 
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('To ProfilePage',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic)),
              onTap: () {
                  Navigator.pushNamed(context, '/profilepage/');
              }
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('To CalendarPage',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic)),
              onTap: () {
                  Navigator.pushNamed(context, '/calendarpage/');
              }
            ),
             ListTile(
              leading: Icon(Icons.graphic_eq_sharp),
              title: Text('To RelationPage',style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic)),
              onTap: () {
                  Navigator.pushNamed(context, '/relation/');
              }
            ),
          ],
        ),
       ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox( height: 15),
            Stack(
              children: <Widget>[
                Text(
                    'AppredicT',
                  style: TextStyle(
                    fontSize: 60,
                    foreground: Paint()
                      ..style=PaintingStyle.stroke
                      ..strokeWidth=8 
                      ..color= Color.fromARGB(255, 167, 192, 3)!,
                  ),
                ),
                Text(
                   'AppredicT',
                  style:TextStyle( 
                    fontSize:60,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),

            SizedBox( height: 20),

            Consumer<DatabaseRepository>(builder: (context, dbr, child) {
              return FutureBuilder(
                  initialData: null,
                  future: dbr.findAllSleep(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as List<Sleep?>;
                      final today = DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day);
                      if (data.isEmpty || data.last!.day != today) {
                        //in first access, database is empty || at the first daily access, you must update your data

                        return Column(children: [
                          SizedBox( height: 140),
                          const Text('Update your data to proceed',style: TextStyle(color: Color.fromARGB(255, 6, 6, 6),fontSize: 20,fontStyle: FontStyle.italic)),
                          SizedBox( height: 13),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(185, 6, 6, 6),
                              fixedSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35))),
                            onPressed: () async {
                            // Authorize the app
                            String? userId = await FitbitConnector.authorize(
                                context: context,
                                clientID: Strings.fitbitClientID,
                                clientSecret: Strings.fitbitClientSecret,
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
                                await fitbitActivityTimeseriesDataManager.fetch(
                                    FitbitActivityTimeseriesAPIURL
                                        .dateRangeWithResource(
                              startDate: DateTime.now()
                                  .subtract(const Duration(days: 100)),
                              endDate: DateTime.now(),
                              userID: userId,
                              resource:
                                  fitbitActivityTimeseriesDataManager.type,
                            )) as List<FitbitActivityTimeseriesData>;

                            print(caloriesData.last);
                            print(caloriesData.elementAt(caloriesData.length-2));
                            print(sleepData.elementAt(0));
                            print(sleepData.elementAt(1));

                            DateTime? date = today;
                            int deepCount = 0;
                            int remCount = 0;
                            int wakeCount = 0;
                            int lightCount = 0;

                            for (var j = 0; j < caloriesData.length - 1; j++) {
                              if (caloriesData.elementAt(j).dateOfMonitoring ==
                                  today) {
                                Sleep soloCalorie = Sleep(
                                    today.add(Duration(days: 1)),
                                    null,
                                    null,
                                    null,
                                    null,
                                    caloriesData.elementAt(j).value);
                                await Provider.of<DatabaseRepository>(context,
                                        listen: false)
                                    .insertSleepStages(soloCalorie);
                                break;
                              }

                              for (var i = 0; i < sleepData.length - 1; i++) {
                                if (sleepData.elementAt(i).dateOfSleep ==
                                    date) {
                                  if (sleepData.elementAt(i).level == 'deep') {
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

                             
                            } },
                            child: Text('Update')
                         )
                        ]);
                      } else {
                        chartData = getChartData(data.last);
                        int tot=(data.last!.deep!.toDouble()+data.last!.rem!.toDouble()+data.last!.light!.toDouble()+data.last!.wake!.toDouble()).round();
                        int deep_perc=((data.last!.deep!.toDouble()/(tot))*100).round();
                        int rem_perc=(data.last!.rem!.toDouble()/(tot)*100).round();
                        int light_perc=(data.last!.light!.toDouble()/(tot)*100).round();
                        int wake_perc=(data.last!.wake!.toDouble()/(tot)*100).round();
                        double top_deep= 180;
                        int eff= (data.last!.deep!.toDouble()/(2)/(top_deep)*100).round();
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('Date: ' + DateFormat.yMMMMd().format(data.last!.day),style: TextStyle(fontSize: 18,color:Color.fromARGB(255, 255, 255, 255),fontStyle: FontStyle.italic)),
                          SizedBox( height: 25),
                          Text('Here some data for you...',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 6, 6))),
                            SizedBox( height: 15),
                            Text('Yesterday you spent ' + data.last!.caloriesDaybefore.toString()+ ' calories',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),),                           
                            SizedBox( height: 5),
                            Text('- Deep sleep: ' + deep_perc.toString() + ' % of you rest',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic)),
                            SizedBox( height: 5),
                            Text('- Rem sleep: ' + rem_perc.toString() + ' % of your rest',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic)),
                            SizedBox( height: 5),
                            Text('- Light sleep: ' + light_perc.toString() + ' % of your rest',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic)),
                            SizedBox( height: 5),
                            Text('- Wake sleep: ' + wake_perc.toString() + ' % of your rest',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic)),
                            SizedBox( height: 5),
                            Text('EFFICENCY: ' + eff.toString()+ '/100',style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 15,
                            ),

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
