import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Augmenté pour accommoder l'icône centrale
      decoration: const BoxDecoration(
        color: Color(0xFF491B6D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Barre de navigation de base
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Icône Accueil
              _buildNavItem(Icons.home, "Accueil", 0),
              
              // Espace vide pour l'icône centrale
              const SizedBox(width: 60),
              
              // Icône Profil
              _buildNavItem(Icons.person, "Profil", 2),
            ],
          ),
          
          // Icône centrale (Formation) chevauchée
          Positioned(
            top: -20, // Position plus haute pour l'effet de chevauchement
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => onItemTapped(1),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF491B6D),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.library_books,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}