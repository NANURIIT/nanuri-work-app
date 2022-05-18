import 'package:flutter/material.dart';
import 'package:nanuriit_members02/screens/loginPage.dart';
import 'package:nanuriit_members02/screens/startScreen.dart';
import 'package:flutter_session/flutter_session.dart';


void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nanuriit',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: StartScreen(),
    );
  }
}
