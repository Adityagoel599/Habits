 import 'package:habits/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays){
  final today=DateTime.now();
  return completedDays.any((date)=>
   date.year== today.year&&
      date.month== today.month&&
      date.day==today.day
  );
 }
 Map<DateTime, int >prepHeatMApDatabase(List <Habit>habits){
Map<DateTime, int> dataset={};
for(var habit in habits){
  for(var date in habit.completedDays){
    final normalizeddate= DateTime(date.year,date.month, date.day);
  if(dataset.containsKey(normalizeddate))
  {
    dataset[normalizeddate]=dataset[normalizeddate]!+1;
  }
  else{
    dataset[normalizeddate]=1;
  }
  }

}
return dataset;
 }