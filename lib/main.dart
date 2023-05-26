import 'package:flutter/material.dart';
import 'package:flutter_final_project/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social Network",
      theme: ThemeData(
        primaryColor: Colors.blue[400],
        hintColor: Colors.greenAccent[400],
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
