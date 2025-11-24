import 'package:flutter/material.dart';

const Color _kPrimaryPurple = Color(0xFF5E2B97);

class AudioTrackTile extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final String subtitle;
  final bool isPlaying;
  final VoidCallback onTap;

  const AudioTrackTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    this.isPlaying = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Détermine l'icône de lecture/pause
    final trailingIcon = isPlaying ? Icons.pause : Icons.play_arrow;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        
        // Icône de gauche (avec fond violet)
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: _kPrimaryPurple.withOpacity(0.1), // Fond légèrement teinté
            shape: BoxShape.circle,
          ),
          child: Icon(leadingIcon, color: _kPrimaryPurple, size: 30),
        ),

        // Titre et sous-titre
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),

        // Bouton Play/Pause
        trailing: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _kPrimaryPurple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            trailingIcon,
            color: _kPrimaryPurple,
            size: 28,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
    );
  }
}