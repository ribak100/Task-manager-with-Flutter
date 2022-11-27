import 'package:flutter/material.dart';
import 'package:taskmanager/screens/first%20screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstScreen(),
      routes: {
        HomeScreen.routename :(BuildContext context) => HomeScreen(),
      },
    );
  }
}
