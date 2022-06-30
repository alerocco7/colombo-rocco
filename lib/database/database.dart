
import 'dart:async';
import 'package:colombo_rocco/database/TypeConverters/datetimeconverter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'daos/sleepDao.dart';
import 'entities/sleep.dart';
part 'database.g.dart';


@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Sleep])
abstract class AppDatabase extends FloorDatabase {
  //Here all the daos as getters
  SleepDao get sleepDao;
}//AppDatabase