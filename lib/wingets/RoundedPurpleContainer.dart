import 'package:flutter/material.dart';

// Définition des couleurs
const Color _kPrimaryPurple = Color(0xFF5E2B97); // Couleur violette du design

/// Un conteneur réutilisable avec un fond violet et des bords arrondis en bas.
class RoundedPurpleContainer extends StatelessWidget {
  final double height;

  const RoundedPurpleContainer({
    super.key,
    this.height = 100.0, // Hauteur par défaut
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: _kPrimaryPurple,
        // Arrondi seulement le coin inférieur gauche et inférieur droit
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      // Vous pouvez ajouter un enfant ici si nécessaire
      // child: const Center(child: Text('Conteneur Personnalisé')),
    );
  }
}