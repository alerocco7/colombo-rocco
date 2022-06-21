import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class SleepDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the Sleep table
  @Query('SELECT * FROM Sleep')
  Future<List<Sleep>> findAllSleepstages();

  //Query #2: INSERT -> this allows to add a stage in the table
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertSleepstages(Sleep stage);

  @Query('SELECT MIN day FROM Sleep')
  Future<DateTime?> minday();

  @Query('SELECT * FROM Sleep WHERE day = :day')
  Future<Sleep?> findSleepByday(DateTime day);

  @Query('SELECT * FROM Sleep WHERE day > :day')
  Future<List<Sleep?>> findSleepByfirstday(DateTime day);

  @Query('DELETE FROM Sleep WHERE deep=0 AND light =0 AND rem=0')
  Future<void> deleteNotSleeping();


  //Query #3: DELETE -> this allows to delete a stage from the table
  @delete
  Future<void> deleteSleepstages(Sleep stage);
}//SleepDao