import 'package:flutter/material.dart';

// Définition des couleurs
const Color _kPrimaryPurple = Color(0xFF5E2B97); // Couleur violette du design
const Color _kIconColor = Colors.white; // Couleur des icônes

/// Une barre de navigation inférieure personnalisée réutilisable.
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // La liste des icônes pour la navigation
  static const List<IconData> _icons = [
    Icons.home,
    Icons.storage, // Icône de base de données ou de piles de pièces
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    // La hauteur de la barre de navigation visible (hors padding du bas)
    const double barHeight = 60.0;

    return Container(
      height: barHeight + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: _kPrimaryPurple,
        // Les bords sont légèrement arrondis
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final icon = _icons[index];

            // Pour l'icône centrale qui est plus grande et a un fond blanc
            if (index == 1) {
              return _buildCenterIcon(index, icon);
            }

            // Pour les icônes normales (Accueil et Profil)
            return _buildSideIcon(index, icon);
          }),
        ),
      ),
    );
  }

  /// Widget pour l'icône centrale (Base de données)
  Widget _buildCenterIcon(int index, IconData icon) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: _kIconColor, // Fond blanc
          shape: BoxShape.circle,
          // Ombre légère pour accentuer l'effet 3D
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 35.0, // Plus grande taille
          color: _kPrimaryPurple, // Couleur violette pour l'icône
        ),
      ),
    );
  }

  /// Widget pour les icônes latérales (Accueil et Profil)
  Widget _buildSideIcon(int index, IconData icon) {
    // J'utilise le même style que le design pour l'icône de profil (personne avec un cercle)
    IconData effectiveIcon = icon == Icons.person ? Icons.person_outline : icon;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Icon(
          effectiveIcon,
          size: 30.0,
          color: selectedIndex == index ? Colors.yellowAccent : _kIconColor, // Vous pouvez changer la couleur de sélection ici
        ),
      ),
    );
  }
}