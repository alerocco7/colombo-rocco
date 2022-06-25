import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:colombo_rocco/screens/login.dart';
import 'package:colombo_rocco/utils/strings.dart';
import 'package:fitbitter/fitbitter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:colombo_rocco/utils/phases.dart';

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
      appBar: AppBar(title: Text('HomePage'), actions: <Widget>[
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
                      final data = snapshot.data as List<Sleep?>;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Date:' + data.last!.day.toString()),
                          Text('Deep(min): ' + data.last!.deep.toString()),
                          Text('Rem(min): ' + data.last!.rem.toString()),
                          Text('Light(min): ' + data.last!.light.toString()),
                          Text('Wake(min): ' + data.last!.wake.toString()),
                          SfCircularChart(series: <CircularSeries>[
                            PieSeries<Phases, String>(
                                dataSource: chartData,
                                xValueMapper: (Phases data, _) => data.phase,
                                yValueMapper: (Phases data, _) => data.time,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true)),
                          ]),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            }),
            ElevatedButton(
                child: Text('To ProfilePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/profilepage/');
                }),
            ElevatedButton(
                child: Text('To CalendarPage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/calendarpage/');
                }),
            ElevatedButton(
                child: Text('To NotePage'),
                onPressed: () {
                  Navigator.pushNamed(context, '/notepage/');
                }),
          ],
        ),
      ),
    );
  }
}
