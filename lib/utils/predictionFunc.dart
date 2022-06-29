import 'dart:math';

import 'package:colombo_rocco/database/entities/sleep.dart';

List<double> predictionPar(List<Sleep?> lista) {
  int N = lista.length;
  List<double?> sleepEff = [];
  List<double?> calories = [];
  double? c = 0;
  double Sx = 0;
  double Sy = 0;
  double Sxy = 0;
  double Sxq = 0;
  double media_sleepeff = 0;

  for (var i = 0; i < lista.length - 2; i++) {
    //last day doesn't have sleep data yet
    int? d = lista.elementAt(i)!.deep;
    int? r = lista.elementAt(i)!.rem;
    int? w = lista.elementAt(i)!.wake;
    int? l = lista.elementAt(i)!.light;
    c = lista.elementAt(i)!.caloriesDaybefore;
    double? sleepEfficiency = d! / (d + r! + w! + l!);
    calories.add(c);
    sleepEff.add(sleepEfficiency);
    Sx = Sx + c!;
    Sy = Sy + sleepEfficiency;
    Sxy = Sxy + c * sleepEfficiency;
    Sxq = Sxq + pow(c, 2);
    
  }
  media_sleepeff = Sy / (lista.length -1);
  double a = (N * Sxy - Sx * Sy) / (N * Sxq - pow(Sx, 2));
  double b = (Sy * Sxq - Sx * Sxy) / (N * Sxq - pow(Sx, 2));

  List<double> parametri = [a, b, media_sleepeff];
  return parametri;

  // y=ax+b
}

double predictionFunc(double? calorie, double a, double b) {
  return calorie! * a + b;
}

double sleepEfficiency(Sleep? sleep) {
  return sleep!.deep! /
      (    sleep.deep! +
          sleep.rem!.toDouble() +
          sleep.light!.toDouble() +
          sleep.wake!.toDouble());
}
