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
  Future<void> insertActivity(Activity activity) async {
    await database.activityDao.insertActivity(activity);
    notifyListeners();
  } //insertTodo

  //This method wraps the deleteTodo() method of the DAO.
  //Then, it notifies the listeners that something changed.
  Future<void> removeActivity(Activity activity) async {
    await database.activityDao.deleteActivity(activity);
    notifyListeners();
  } //removeTodo

  Future<List<Sleep>> findAllSleep() async {
    final results = await database.sleepDao.findAllSleepstages();
    return results;
    notifyListeners();
  } //findAllTodos

  Future<void> insertSleepStages(Sleep sleep) async {
    await database.sleepDao.insertSleepstages(sleep);
    notifyListeners();
  } //insertTodo

  Future<void> removeSleepStages(Sleep sleep) async {
    await database.sleepDao.deleteSleepstages(sleep);
    notifyListeners();
  } //removeTodo

  Future<Sleep?> findSleepByday(DateTime day) async {
    final result = await database.sleepDao.findSleepByday(day);
    return result;
    notifyListeners();
  }
} //DatabaseRepository
