import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';

final List<AudioTrack> womenRightsTracks = [
  AudioTrack(icon: Icons.school, title: 'Droit à l\'éducation', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.favorite, title: 'Droit à la santé et la maternité', duration: '3 min 45 s', isPlaying: true), // Piste en pause
  AudioTrack(icon: Icons.security, title: 'Protection contre la violence', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.currency_exchange, title: 'Droits à l\'autonomie financière', duration: '3 min 45 s'),
  AudioTrack(icon: Icons.home, title: 'Droits à la propriété foncière', duration: '3 min 45 s'),
];

final womenRightsScreen = AudioContentScreen(
  screenTitle: 'Droits des femmes',
  introMessage: 'Bienvenue dans l\'espace droit des femmes.\nÉcouter vos droits expliques en Bambara.',
  tracks: womenRightsTracks,
);
// Pour utiliser: runApp(MaterialApp(home: womenRightsScreen));