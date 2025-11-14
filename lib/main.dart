import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/AudioSplashScreen.dart';
import 'package:musso_deme_app/pages/ConfirmationScreen.dart';
import 'package:musso_deme_app/pages/HomeScreen.dart';
import 'package:musso_deme_app/pages/InscriptionScreen.dart';
import 'package:musso_deme_app/pages/LoginScreen.dart';
import 'package:musso_deme_app/pages/ChildrenRightsScreen.dart';
import 'package:musso_deme_app/pages/NewMomsAdviceScreen.dart';

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
      initialRoute: '/Connexion',
      routes: {
        '/Connexion': (context) => LoginScreen(),
        '/InscriptionScreen': (context) => InscriptionScreen(),
        '/ConfirmationScreen': (context) => Confirmationscreen(),
        '/HomeScreen': (context) => HomeScreen(),
        '/AudioSplashScreen': (context) => WomenRightsScreen(),
        '/ChildrenRightsScreen': (context) => ChildrenRightsScreen(),
        '/NewMomsAdviceScreen': (context) => NewMomsAdviceScreen(),
      },
    );
  }
}
