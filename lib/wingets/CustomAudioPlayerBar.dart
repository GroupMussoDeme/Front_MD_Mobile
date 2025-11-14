import 'package:flutter/material.dart';

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kIconColor = Colors.white;

/// Barre de lecteur audio personnalisée réutilisable.
class CustomAudioPlayerBar extends StatelessWidget {
  const CustomAudioPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0, // Hauteur totale du lecteur
      decoration: const BoxDecoration(
        color: _kPrimaryPurple,
        // Arrondi seulement les coins supérieurs
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        children: [
          // Barre de progression et temps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('02:30', style: TextStyle(color: _kIconColor, fontSize: 12)),
              Text('02:30', style: TextStyle(color: _kIconColor, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4.0),
          // Placeholder pour la barre de progression
          LinearProgressIndicator(
            value: 0.5, // 50% de progression
            backgroundColor: Colors.white38,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 3.0,
          ),
          const SizedBox(height: 12.0),
          // Contrôles du lecteur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Télécharger
              IconButton(
                icon: const Icon(Icons.file_download_outlined, color: _kIconColor, size: 28),
                onPressed: () {},
              ),
              // Piste précédente (Reculer)
              IconButton(
                icon: const Icon(Icons.skip_previous, color: _kIconColor, size: 38),
                onPressed: () {},
              ),
              // Play/Pause (Bouton central)
              Container(
                decoration: BoxDecoration(
                  color: _kIconColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.pause, color: _kPrimaryPurple, size: 38),
                  onPressed: () {},
                ),
              ),
              // Piste suivante (Avancer)
              IconButton(
                icon: const Icon(Icons.skip_next, color: _kIconColor, size: 38),
                onPressed: () {},
              ),
              // Rejouer/Recharger
              IconButton(
                icon: const Icon(Icons.refresh_sharp, color: _kIconColor, size: 28),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}