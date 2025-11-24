import 'package:flutter/material.dart';

const Color kPrimaryPurple = Color(0xFF491B6D);

class TutorialVideoCard extends StatelessWidget {
  final String title;
  final String duration;
  final String videoUrl;
  final VoidCallback onOpenFullScreen;

  const TutorialVideoCard({
    super.key,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.onOpenFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenFullScreen,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/vidéo de couverture + bouton play rond
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey.shade300,
                      // Ici tu peux remplacer par une vraie miniature si tu en as une
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kPrimaryPurple, width: 3),
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0x55491B6D),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Badge durée violet
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: kPrimaryPurple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Titre (2 lignes max, comme sur la maquette)
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
