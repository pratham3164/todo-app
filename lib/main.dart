import 'package:flutter/material.dart';
import 'package:todo_app/screens/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.black, scaffoldBackgroundColor: Colors.black),
      home: RegisterPage(),
    );
  }
}
