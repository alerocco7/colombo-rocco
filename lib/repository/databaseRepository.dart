import 'package:colombo_rocco/database/database.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  Future<void> deleteNotSleeping() async {
    await database.sleepDao.deleteNotSleeping();
    notifyListeners();
  } //removeNotSleeping

  Future<List<Sleep>> findAllSleep() async {
    final results = await database.sleepDao.findAllSleepstages();
    return results;
    notifyListeners();
  } //findAllSleep

  Future<List<Sleep?>> findSleepByfirstday(DateTime day) async {
    final results = await database.sleepDao.findSleepByfirstday(day);
    return results;
    notifyListeners();
  }//findAfterDay

  //the day is normalized at the hour: 00:00.00 for clarity of the primary key
  Future<void> insertSleepStages(Sleep sleep) async {
    final giorno = sleep.day.day;
    final mese = sleep.day.month;
    final anno = sleep.day.year;
    final data = DateTime(anno, mese, giorno);
    final Sleep sleepCorrectDAta =
        Sleep(data, sleep.deep, sleep.light, sleep.rem, sleep.wake, sleep.caloriesDaybefore);
    await database.sleepDao.insertSleepstages(sleepCorrectDAta);
    notifyListeners();
  } //insertSleep
 
  Future<void> insertSleepList(List<Sleep> lista) async {
   await database.sleepDao.insertSleepList(lista);
   notifyListeners();
  }//insertSleepList

  Future<void> removeSleepStages(Sleep sleep) async {
    await database.sleepDao.deleteSleepstages(sleep);
    notifyListeners();
  } //removeSleep

  //the day is normalized at the hour: 00:00.00 to find the correct primary key
  Future<Sleep?> findSleepByday(DateTime day) {
    final giorno = day.day;
    final mese = day.month;
    final anno = day.year;
    final data = DateTime(anno, mese, giorno);
    final result = database.sleepDao.findSleepByday(data);
    return result;
  }//findByDay
 
} //DatabaseRepository
