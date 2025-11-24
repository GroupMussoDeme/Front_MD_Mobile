import 'package:flutter/material.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkGrey = Color(0xFF707070);

class BackendAudioListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String duration;
  final bool isPlaying;
  final VoidCallback onTap;

  const BackendAudioListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.duration,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: neutralWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Icône à gauche
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: primaryViolet,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Titre + durée
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: primaryViolet,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: darkGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Bouton Play/Pause
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPlaying ? primaryViolet : neutralWhite,
                border: Border.all(color: primaryViolet, width: 1.6),
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isPlaying ? neutralWhite : primaryViolet,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
