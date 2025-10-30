import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Bienvenue.dart';
import 'package:musso_deme_app/pages/Demarrage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musso Deme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, 
      initialRoute: '/Demarrage',
      routes: {
        '/Demarrage': (context) => Demarrage(),
        '/Bienvenue': (context) => BienvenuePage(),
        '/welcome': (context) => BienvenuePage(),
      },
    );
  }
}