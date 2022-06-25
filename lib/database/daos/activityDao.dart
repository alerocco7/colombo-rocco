import 'package:colombo_rocco/database/entities/activity.dart';
import 'package:floor/floor.dart';

//Here, we are saying that the following class defines a dao.

@dao
abstract class ActivityDao {

  //Query #1: SELECT -> this allows to obtain all the entries of the Activity table
  @Query('SELECT * FROM Activity')
  Future<List<Activity>> findAllSteps();

  @Query('SELECT * FROM Activity WHERE day > :day')
  Future<List<Activity?>> findCaloriesByfirstday(DateTime day);

  @Query('SELECT calories FROM Activity WHERE day > :day')
  Future<List<double?>?> findCalorieByfirstday(DateTime day);

  //Query #2: INSERT -> this allows to add a step in the table
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertActivity(Activity calories);

  //Query #3: DELETE -> this allows to delete a step from the table
  @delete
  Future<void> deleteActivity(Activity calories);

}//ActivityDao