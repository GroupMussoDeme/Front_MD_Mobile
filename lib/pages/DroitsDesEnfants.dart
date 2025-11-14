import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';

final List<AudioTrack> childRightsTracks = [
  AudioTrack(icon: Icons.family_restroom, title: 'Droit de l\'enfant', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.baby_changing_station, title: 'La santé enfantine', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.person_off, title: 'Éviter la mal nutrition enfantine', duration: '3 min 45 s'), // Icône ajustée
  AudioTrack(icon: Icons.medical_services, title: 'Consigne pour enfant malade', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.verified_user, title: 'Droits à la protection', duration: '3 min 45 s'),
];

final childRightsScreen = AudioContentScreen(
  screenTitle: 'Droits des enfants',
  introMessage: 'Bienvenue dans l\'espace droit des femmes.\nÉcouter vos droits expliques en Bambara.', // Texte conservé de l'image
  tracks: childRightsTracks,
);