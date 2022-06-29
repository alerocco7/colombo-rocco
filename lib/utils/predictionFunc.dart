import 'dart:math';

import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<double> predictionPar(List<Sleep?> lista) {
  int N = lista.length - 1;
  List<int?> sleepEff = [];
  List<double?> calories = [];
  double? c = 0;
  double Sx = 0;
  double Sy = 0;
  double Sxy = 0;
  double Sxq = 0;
  double media_sleepeff = 0;
  double top_deep = 150;
  for (var i = 0; i < lista.length - 2; i++) {
    //last day doesn't have sleep data yet
    int? d = lista.elementAt(i)!.deep;

    c = lista.elementAt(i)!.caloriesDaybefore;

    int eff = 100 * (d! / (2 * top_deep)).round();
    calories.add(c);
    sleepEff.add(eff);
    Sx = Sx + c!;
    Sy = Sy + eff;
    Sxy = Sxy + c * eff;
    Sxq = Sxq + pow(c, 2);
  }
  media_sleepeff = Sy / (lista.length - 1);
  double a = (N * Sxy - Sx * Sy) / (N * Sxq - pow(Sx, 2));
  double b = (Sy * Sxq - Sx * Sxy) / (N * Sxq - pow(Sx, 2));

  _sharedPrefPar(a,b);

  List<double> parametri = [a, b, media_sleepeff];
  return parametri;

  // y=ax+b
}

void _sharedPrefPar(double a, double b) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setDouble('apar', a);
  await sp.setDouble('bpar', b);
}

double predictionFunc(double? calorie, double a, double b) {
  return (calorie! * a + b);
}

double sleepEfficiency(Sleep? sleep) {
  double top_deep = 150;
  return (sleep!.deep! / (2) / (top_deep) * 100).round().toDouble();
}
