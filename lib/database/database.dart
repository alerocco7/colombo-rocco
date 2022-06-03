//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'daos/activityDao.dart';
import 'daos/sleepDao.dart';
import 'entities/activity.dart';
import 'entities/sleep.dart';

 //The generated code will be in database.g.dart
part 'database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Todo
@Database(version: 1, entities: [Activity,Sleep])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  ActivityDao get activityDao;
  SleepDao get sleepDao;
}//AppDatabase