import 'package:flutter/material.dart';

class AudioTrack {
  final IconData icon;
  final String title;
  final String duration;
  final bool isPlaying; // Ajouté pour simuler l'état Play/Pause

  AudioTrack({
    required this.icon,
    required this.title,
    required this.duration,
    this.isPlaying = false,
  });
}