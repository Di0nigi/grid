import 'package:flutter/material.dart';
import 'package:grid/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  
  runApp(const MyApp());

  
  
}

SharedPreferences? prefs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Grid',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen());
  }
}
