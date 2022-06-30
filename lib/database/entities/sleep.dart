import 'package:floor/floor.dart';

//Table of the database, at first there were two tables, but since they had the same primary key,
// we decided to merged them in a single table
@entity
class Sleep {
  //The day will be the primary key of the table.

  @PrimaryKey()
  final DateTime day;

 
  final int? deep; //2*minutes
  final int? light; //2*minutes
  final int? rem; //2*minutes
  final int? wake; //2*minutes
  final double? caloriesDaybefore; //kcal

  //Default constructor
  Sleep(this.day, this.deep, this.light, this.rem, this.wake,
      this.caloriesDaybefore);
}//Sleep