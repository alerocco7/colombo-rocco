import 'package:colombo_rocco/database/entities/sleep.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class SleepDao {

  //Query #1: SELECT -> this allows to obtain all the entries of the Sleep table
  @Query('SELECT * FROM Sleep')
  Future<List<Sleep>> findAllSleepstages();

  //Query #2: INSERT -> this allows to add a stage in the table
  @insert
  Future<void> insertSleepstages(Sleep stage);

  //Query #3: DELETE -> this allows to delete a stage from the table
  @delete
  Future<void> deleteSleepstages(Sleep stage);

}//SleepDao