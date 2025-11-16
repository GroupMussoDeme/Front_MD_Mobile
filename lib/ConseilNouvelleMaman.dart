import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/AudioContentScreen.dart';
import 'package:musso_deme_app/pages/AudiosDroits.dart';

final List<AudioTrack> newMomsAdviceTracks = [
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les femmes enceintes', duration: '10 min 30 s', isPlaying: true),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les nouvelles mères', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les femmes enceintes', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les nouvelles mères', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les femmes enceintes', duration: '10 min 30 s'),
  AudioTrack(icon: Icons.favorite_border, title: 'Conseil pour les nouvelles mères', duration: '10 min 30 s'),
];

final newMomsScreen = AudioContentScreen(
  screenTitle: 'Conseils aux nouvelles mamans',
  introMessage: 'Bienvenue dans l\'espace santé de la femmes.\nÉcouter des conseils sur la santé en Bambara.',
  tracks: newMomsAdviceTracks,
);