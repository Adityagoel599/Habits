import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits/database/habit_database.dart';
//import 'package:habits/themes/light_mode.dart';
import 'package:habits/themes/themes_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase.initalize();
  await HabitDatabase().saveFirstLaunchDate();

  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(create: (context)=> HabitDatabase()),
      ChangeNotifierProvider(create: (context)=> ThemesProvider())
    ] ,
    child: const MyApp()
    )
  );


}
class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build (BuildContext context){
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme:Provider.of<ThemesProvider>(context).themeData,
    );
  }
}