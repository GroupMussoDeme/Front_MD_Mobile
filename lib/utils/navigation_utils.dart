import 'package:flutter/material.dart';

/// Fonction utilitaire pour naviguer vers la page d'accueil
void navigateToHome(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(context, '/HomeScreen', (route) => false);
}