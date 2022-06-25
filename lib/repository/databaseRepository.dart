import 'package:colombo_rocco/database/database.dart';
import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:flutter/material.dart';

class DatabaseRepository extends ChangeNotifier {
  //The state of the database is just the AppDatabase
  final AppDatabase database;

  //Default constructor
  DatabaseRepository({required this.database});

  //This method wraps the findAllTodos() method of the DAO
  Future<List<Activity>> findAllSteps() async {
    final results = await database.activityDao.findAllSteps();
    return results;
    notifyListeners();
  } //findAllTodos

  //This method wraps the insertTodo() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> insertActivity(Activity calories) async {
    await database.activityDao.insertActivity(calories);
    notifyListeners();
  } //insertTodo

  Future<List<double?>?> findCalorieByfirstday(DateTime day) async {
    final results = await database.activityDao.findCalorieByfirstday(day);
    return results;
    notifyListeners();
  }

  //This method wraps the deleteTodo() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> removeActivity(Activity calories) async {
    await database.activityDao.deleteActivity(calories);
    notifyListeners();
  } //removeTodo

  Future<void> deleteNotSleeping() async {
    await database.sleepDao.deleteNotSleeping();
    notifyListeners();
  } //removeTodo

  Future<List<Sleep>> findAllSleep() async {
    final results = await database.sleepDao.findAllSleepstages();
    return results;
    notifyListeners();
  } //findAllTodos

  Future<List<Sleep?>> findSleepByfirstday(DateTime day) async {
    final results = await database.sleepDao.findSleepByfirstday(day);
    return results;
    notifyListeners();
  }

  Future<List<Activity?>> findCaloriesByfirstday(DateTime day) async {
    final results = await database.activityDao.findCaloriesByfirstday(day);
    return results;
    notifyListeners();
  }

  Future<void> insertSleepStages(Sleep sleep) async {
    await database.sleepDao.insertSleepstages(sleep);
    notifyListeners();
  } //insertTodo

  Future<void> removeSleepStages(Sleep sleep) async {
    await database.sleepDao.deleteSleepstages(sleep);
    notifyListeners();
  } //removeTodo

  Future<Sleep?> findSleepByday(DateTime day) {
    final giorno = day.day;
    final mese = day.month;
    final anno = day.year;
    final data = DateTime(anno, mese, giorno);
    final result = database.sleepDao.findSleepByday(data);
    return result;
  }

  Future<DateTime?> minday() async {
    final result = await database.sleepDao.minday();
    return result;
  }
} //DatabaseRepository
