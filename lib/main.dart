import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/ConfirmationScreen.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musso Deme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, 
      initialRoute: '/HomeScreen',
      routes: {
        '/Connexion': (context) => LoginScreen(),
        '/InscriptionScreen': (context) => InscriptionScreen(),
        '/ConfirmationScreen': (context) => Confirmationscreen(),
        '/HomeScreen': (context) => HomeScreen(),
      },
    );
  }
}
