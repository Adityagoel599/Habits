import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habits/themes/themes_provider.dart';
import 'package:provider/provider.dart';
class MyDrawer extends StatelessWidget{
  const MyDrawer({super.key});
  @override
  Widget build (BuildContext context){
    return Drawer(
        backgroundColor:Theme.of(context).colorScheme.background,
        child: Center(child: CupertinoSwitch(value: Provider.of<ThemesProvider>(context).isDarkMode,
          onChanged: (value)=> Provider.of<ThemesProvider>(context, listen: false).toggleTheme(),),)
    );
  }
}