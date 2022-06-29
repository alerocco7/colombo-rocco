import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:colombo_rocco/utils/predictionFunc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class RelationPage extends StatefulWidget {
  @override
  State<RelationPage> createState() => _RelationPageState();
}

class _RelationPageState extends State<RelationPage> {
  List<SalesData> chartData = [];

  @override
  void initState() {
    chartData =
        getChartData([Sleep(DateTime.now(), 10, 20, 30, 40, 0)], [0, 1]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<double> parametri =
        ModalRoute.of(context)!.settings.arguments! as List<double>;

    return Scaffold(body: Center(
        child: Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          initialData: null,
          future: dbr.findAllSleep(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<Sleep?>;
              final List<double?> calorie = [];
              chartData = getChartData(data, parametri);
              double? mincal = 10000;
              double? maxcal = 0;
              for (var i = 0; i < data.length - 1; i++) {
                calorie.add(data.elementAt(i)!.caloriesDaybefore);
                if (data.elementAt(i)!.caloriesDaybefore! < mincal!) {
                  mincal = data.elementAt(i)!.caloriesDaybefore;
                }
                if (data.elementAt(i)!.caloriesDaybefore! > maxcal!) {
                  maxcal = data.elementAt(i)!.caloriesDaybefore;
                }
              }
              return SafeArea(
                  child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                title: ChartTitle(
                  text: 'Real sleep efficiency vs predicted sleep efficiency',
                  backgroundColor: Color.fromARGB(117, 216, 216, 212),
                  textStyle: TextStyle(
                      color: Color.fromARGB(255, 37, 169, 4),
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
                primaryXAxis: NumericAxis(
                  minimum: mincal,
                  maximum: maxcal,
                  title: AxisTitle(
                      text: 'spent calories',
                      textStyle: TextStyle(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20)),
                  labelIntersectAction: AxisLabelIntersectAction.multipleRows,
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                legend: Legend(isVisible: false),
                primaryYAxis: NumericAxis(
                    title: AxisTitle(
                        text:
                            'sleep efficiency vs sleep efficiency prediction'),
                    labelFormat: '{value}%',
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0)),
                tooltipBehavior: TooltipBehavior(
                    enable: true, header: '', canShowMarker: false),
                series: <ScatterSeries<SalesData, num>>[
                  ScatterSeries<SalesData, num>(
                      dataSource: chartData,
                      xValueMapper: (SalesData chartdata, _) =>
                          chartdata.calorie,
                      yValueMapper: (SalesData data, _) => data.timeEff,
                      markerSettings: const MarkerSettings(
                          width: 10,
                          height: 10,
                          shape: DataMarkerType.triangle),
                      name: 'time efficiency'),
                  ScatterSeries<SalesData, num>(
                      dataSource: chartData,
                      xValueMapper: (SalesData chartdata, _) =>
                          chartdata.calorie,
                      yValueMapper: (SalesData data, _) => data.timeEffpred,
                      markerSettings: const MarkerSettings(
                          width: 10, height: 10, shape: DataMarkerType.circle),
                      name: 'time efficiency predicted')
                ],
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          });
    })));
  }

  List<SalesData> getChartData(List<Sleep?> lista, List<double> parametri) {
    List<SalesData> chartData = [];
    for (var i = 0; i < lista.length - 1; i++) {
      chartData.add(SalesData(
          lista.elementAt(i)!.caloriesDaybefore,
          sleepEfficiency(lista.elementAt(i)),
          predictionFunc(lista.elementAt(i)!.caloriesDaybefore,
              parametri.elementAt(0), parametri.elementAt(1))));
    }
    return chartData;
  }
}

class SalesData {
  final double? calorie;
  final double timeEff;
  final double timeEffpred;
  SalesData(this.calorie, this.timeEff, this.timeEffpred);
}
