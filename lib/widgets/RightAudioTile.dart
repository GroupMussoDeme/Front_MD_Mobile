import 'package:flutter/material.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color darkGrey = Color(0xFF707070);

class RightAudioTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String duration;
  final bool isPlaying;
  final VoidCallback onTap;

  const RightAudioTile({
    super.key,
    required this.icon,
    required this.title,
    required this.duration,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final playPauseIcon = isPlaying ? Icons.pause : Icons.play_arrow;
    final playPauseBg = isPlaying ? primaryViolet : neutralWhite;
    final playPauseColor = isPlaying ? neutralWhite : primaryViolet;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: neutralWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryViolet.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryViolet, size: 26),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: primaryViolet,
            ),
          ),
          subtitle: Text(
            duration,
            style: const TextStyle(color: darkGrey, fontSize: 13),
          ),
          trailing: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: playPauseBg,
              border: Border.all(color: primaryViolet, width: 1.5),
            ),
            child: Icon(playPauseIcon, color: playPauseColor, size: 28),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
