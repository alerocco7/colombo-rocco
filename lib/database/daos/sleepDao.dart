import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class SleepDao {
  //Query #1: SELECT -> this allows to obtain all the entries of the Sleep table
  @Query('SELECT * FROM Sleep')
  Future<List<Sleep>> findAllSleepstages();

  //Query #2: INSERT -> this allows to add a stage in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertSleepstages(Sleep stage);

  //Query #3: INSERT -> this allows to add a list of stages in the table
  //Not used but useful for future implementation
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertSleepList(List<Sleep> lista);

  //Query #4: SELECT -> this allows to obtain entry of the selected day
  @Query('SELECT * FROM sleep WHERE day = :day')
  Future<Sleep?> findSleepByday(DateTime day);

  //Query #5: SELECT -> this allows to obtain all the entries of the Sleep table after a certain date
  //Not used but useful for future implementation
  @Query('SELECT * FROM Sleep WHERE day > :day')
  Future<List<Sleep?>> findSleepByfirstday(DateTime day);

  //Query #6: DELETE -> useful because there were some wrong data when fetched, where all the phases were 0
  @Query('DELETE FROM Sleep WHERE deep=0 AND light =0 AND rem=0')
  Future<void> deleteNotSleeping();


  //Query #7: DELETE -> this allows to delete a stage from the table
  @delete
  Future<void> deleteSleepstages(Sleep stage);
}//SleepDao