import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:colombo_rocco/utils/predictionFunc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colombo_rocco/repository/databaseRepository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class RelationPage extends StatefulWidget {
  @override
  State<RelationPage> createState() => _RelationPageState();
}

class _RelationPageState extends State<RelationPage> {
  List<SalesData> chartData = [];

  @override
  void initState() {
    chartData =
        getChartData([Sleep(DateTime.now(), 10, 20, 30, 40, 0)], [0, 1]); //data inizialitazion with random values
    super.initState();
  }

  //Scatter chart representing the relation between calories and sleep efficiency(real and predicted) 
  @override
  Widget build(BuildContext context) {
   

    return Scaffold(body: Center(
        child: Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          initialData: null,
          future: dbr.findAllSleep(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<Sleep?>;
              List<double> parametri = predictionPar(data);
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
              return Scaffold(
                appBar: AppBar(
                   backgroundColor: Color.fromARGB(255, 167, 192, 3),
          title: Text('EFFICIENCY(CALORIES)',
              style: TextStyle(color: Color.fromARGB(255, 6, 6, 6),
              fontSize: 20))),
                
                  body: SfCartesianChart(
                plotAreaBorderWidth: 0,
               
                primaryXAxis: NumericAxis(
                  minimum: mincal,
                  maximum: (maxcal!+100),
                 
                  title: AxisTitle(

                      text: '____spent calories (kcal)____',
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                          backgroundColor: Color.fromARGB(255, 167, 192, 3),
                          fontSize: 20)),
                  labelIntersectAction: AxisLabelIntersectAction.hide,
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.black),
                ),
                legend: Legend(isVisible: false),
                primaryYAxis: NumericAxis(
                 minimum: 10,
                 maximum: 100,
                    title: AxisTitle(
                        text:
                            '_____sleep efficiency vs sleep efficiency prediction____',
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                          backgroundColor: Color.fromARGB(255, 167, 192, 3),
                          fontSize: 20)),
                    labelFormat: '{value}%', 
                    labelStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.black),
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 10)),
                tooltipBehavior: TooltipBehavior(
                    enable: true, header: '', canShowMarker: false),
                series: <ScatterSeries<SalesData, num>>[
                  ScatterSeries<SalesData, num>(
                      dataSource: chartData,
                      xValueMapper: (SalesData chartdata, _) =>
                          chartdata.calorie,
                      yValueMapper: (SalesData data, _) => data.timeEff,
                      markerSettings: const MarkerSettings(
                         
                          width: 15,
                          height: 15,
                          shape: DataMarkerType.diamond),
                      name: 'time efficiency'),
                  ScatterSeries<SalesData, num>(
                      dataSource: chartData,
                      xValueMapper: (SalesData chartdata, _) =>
                          chartdata.calorie,
                      yValueMapper: (SalesData data, _) => data.timeEffpred,
                      markerSettings: const MarkerSettings(
                          width: 10, height: 5, shape: DataMarkerType.circle),
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

//Useful class for manage data for the chart
class SalesData {
  final double? calorie;
  final double timeEff;
  final double timeEffpred;
  SalesData(this.calorie, this.timeEff, this.timeEffpred);
}