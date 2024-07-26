import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits/components/my_drawer.dart';
import 'package:habits/components/my_habit_tile.dart';
import 'package:habits/components/my_heat_map.dart';
import 'package:habits/database/habit_database.dart';
import 'package:habits/models/habit.dart';
import 'package:habits/themes/themes_provider.dart';
import 'package:habits/util/habit_util.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState()=> _HomePageState();
}

class _HomePageState extends State<HomePage>{
  @override
  void initState(){
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }
  final TextEditingController textController= TextEditingController();
  void createNewHabit(){
    showDialog(context:context, builder: (context)=> AlertDialog(
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: "Create a new Habit"
        ),
        
      ),
      actions: [
        MaterialButton(onPressed: (){
          String newHabitName=textController.text;
          context.read<HabitDatabase>().addHabit(newHabitName);
          Navigator.pop(context);
          textController.clear();
        },
          child: const Text('Save'),

        ),
        MaterialButton(onPressed: (){
          //String newHabitName=textController.text;
          //context.read<HabitDatabase>().addHabit(newHabitName);
          Navigator.pop(context);
          textController.clear();
        },
          child: Text('Cancel'),
        )
        ],
    ));
  }
  void checkHabitOnOff(bool?value, Habit habit) {
if(value!=null){
  context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
}
  }

  void editHabitBox(Habit habit){
    textController.text= habit.name;
    showDialog(context: context, builder: (context)=>AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        MaterialButton(onPressed: (){
          String newHabitName=textController.text;
          context.read<HabitDatabase>().updateHabitName(habit.id,newHabitName);
          Navigator.pop(context);
          textController.clear();
        },
          child: const Text('Save'),

        ),
        MaterialButton(onPressed: (){
          //String newHabitName=textController.text;
          //context.read<HabitDatabase>().addHabit(newHabitName);
          Navigator.pop(context);
          textController.clear();
        },
          child: Text('Cancel'),
        )
      ],
    ));
  }
  void deleteHabitBox(Habit habit ){
    textController.text= habit.name;
    showDialog(context: context, builder: (context)=>AlertDialog(
    title: const Text("Are you sure you want to delete this" ) ,
      actions: [
        MaterialButton(onPressed: (){
          //String newHabitName=textController.text;
          context.read<HabitDatabase>().deleteHabit(habit.id);
          Navigator.pop(context);
          textController.clear();
        },
          child: const Text('Delete'),

        ),
        MaterialButton(onPressed: (){
          //String newHabitName=textController.text;
          //context.read<HabitDatabase>().addHabit(newHabitName);
          Navigator.pop(context);
          textController.clear();
        },
          child: Text('Cancel'),
        )
      ],
    ));
  }
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const
        Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: ListView(
        children:[
        _buildHeatMap(),
        _buildHabitList(),
      ]),
    );
  }
  Widget _buildHabitList(){
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currenthabits= habitDatabase.currentHabits;
    return ListView.builder(
        itemCount: currenthabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
        final habit = currenthabits[index];
        bool isCompletedtoday= isHabitCompletedToday(habit.completedDays);
        return MyHabitTile(text:habit.name, isCompleted: isCompletedtoday,
            onChanged: (value)=> checkHabitOnOff(value,habit),
        editHabit: (context)=>editHabitBox(habit),
          deleteHabit: (context)=> deleteHabitBox(habit),
        );
    }
    );
  }
  Widget _buildHeatMap(){
final habitDatabase= context.watch<HabitDatabase>();
List<Habit> currenthabits= habitDatabase.currentHabits;
return FutureBuilder<DateTime?>(future: habitDatabase.getFirstLaunchDate(), builder: (context, snapshot){
  if(snapshot.hasData){
return MyHeatMap(startDate: snapshot.data!, datasets: prepHeatMApDatabase(currenthabits));
  }
  else{
    return Container();
  }
});
  }

}


