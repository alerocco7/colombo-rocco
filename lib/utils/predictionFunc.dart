import 'dart:math';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Function that receive as input all the Sleep instances and returns a List [a,b,mean],
//where a,b are the parameters of the linear model estimated from the data (SleepEfficiency=a*calories+b),
//mean is the mean efficiency over all the data

List<double> predictionPar(List<Sleep?> lista) {
  int N = lista.length - 1; //Number of instances in the database
  
  //Values initialization
  List<int?> sleepEff = [];
  List<double?> calories = [];
  double? c = 0;
  double Sx = 0;
  double Sy = 0;
  double Sxy = 0;
  double Sxq = 0;
  double media_sleepeff = 0;
  double top_deep = 150; //value from literature indicating the optimal time in minutes to spend in deep phase


  for (var i = 0; i < lista.length - 2; i++) {
    //last day doesn't have sleep data 
    int? d = lista.elementAt(i)!.deep;
    c = lista.elementAt(i)!.caloriesDaybefore;

    int eff = 100 * (d! / (2 * top_deep)).round(); //Sleep efficiency percentage 
    calories.add(c);
    sleepEff.add(eff);
    //Values for calcolating the parameters with Least Square Method
    Sx = Sx + c!;
    Sy = Sy + eff;
    Sxy = Sxy + c * eff;
    Sxq = Sxq + pow(c, 2);
  }

  media_sleepeff = Sy / (lista.length - 1);

  // Least Square Method parameters
  double a = (N * Sxy - Sx * Sy) / (N * Sxq - pow(Sx, 2));
  double b = (Sy * Sxq - Sx * Sxy) / (N * Sxq - pow(Sx, 2));

  //Storing the parameters for using them in different pages
  _sharedPrefPar(a,b);

  List<double> parametri = [a, b, media_sleepeff];
  return parametri;

  // y=ax+b
}

//Storing the parameters for using them in different pages
void _sharedPrefPar(double a, double b) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setDouble('apar', a);
  await sp.setDouble('bpar', b);
}

//Function that calculates the sleep efficiency prediction 
double predictionFunc(double? calorie, double a, double b) {
  return (calorie! * a + b);
}

//Function that calculates the real sleep efficiency
double sleepEfficiency(Sleep? sleep) {
  double top_deep = 150;
  return (sleep!.deep! / (2) / (top_deep) * 100).round().toDouble();
}
