import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kIconColor = Colors.white;

/// Barre de lecteur audio personnalisée réutilisable et interactive.
class CustomAudioPlayerBar extends StatefulWidget {
  final AudioPlayer player;
  
  const CustomAudioPlayerBar({super.key, required this.player});

  @override
  State<CustomAudioPlayerBar> createState() => _CustomAudioPlayerBarState();
}

class _CustomAudioPlayerBarState extends State<CustomAudioPlayerBar> {
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
  }

  void _togglePlayback() async {
    try {
      if (widget.player.playing) {
        await widget.player.pause();
      } else {
        // Vérifier si le lecteur a une source
        if (widget.player.duration == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucun fichier audio chargé')),
          );
          return;
        }
        await widget.player.play();
      }
    } catch (e) {
      print('Erreur lors de la lecture/pause: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Répartir l'espace entre les éléments
        children: [
          // Barre de progression et temps
          StreamBuilder<Duration>(
            stream: widget.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = widget.player.duration ?? Duration.zero;
              
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(color: _kIconColor, fontSize: 12),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(color: _kIconColor, fontSize: 12),
                  ),
                ],
              );
            },
          ),
          // Barre de progression interactive
          StreamBuilder<Duration>(
            stream: widget.player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = widget.player.duration ?? Duration.zero;
              final progress = duration.inMilliseconds > 0 
                  ? position.inMilliseconds / duration.inMilliseconds 
                  : 0.0;
              
              return SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white38,
                  thumbColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                ),
                child: Slider(
                  value: progress.clamp(0.0, 1.0).toDouble(),
                  onChanged: (value) {
                    final duration = widget.player.duration ?? Duration.zero;
                    final newPosition = Duration(milliseconds: (duration.inMilliseconds * value).round());
                    widget.player.seek(newPosition);
                  },
                ),
              );
            },
          ),
          // Contrôles du lecteur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Télécharger
              IconButton(
                icon: const Icon(Icons.file_download_outlined, color: _kIconColor, size: 24), // Réduction de taille
                onPressed: () {
                  // Fonctionnalité de téléchargement à implémenter
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fonctionnalité de téléchargement à venir')),
                  );
                },
              ),
              // Piste précédente (Reculer)
              IconButton(
                icon: const Icon(Icons.fast_rewind, color: _kIconColor, size: 32), // Réduction de taille
                onPressed: () {
                  widget.player.seek(widget.player.position - const Duration(seconds: 10));
                },
              ),
              // Play/Pause (Bouton central)
              StreamBuilder<PlayerState>(
                stream: widget.player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final isPlaying = playerState?.playing ?? false;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: _kIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: _kPrimaryPurple,
                        size: 32, // Réduction de taille
                      ),
                      onPressed: _togglePlayback,
                    ),
                  );
                },
              ),
              // Piste suivante (Avancer)
              IconButton(
                icon: const Icon(Icons.fast_forward, color: _kIconColor, size: 32), // Réduction de taille
                onPressed: () {
                  widget.player.seek(widget.player.position + const Duration(seconds: 10));
                },
              ),
              // Rejouer/Recharger
              IconButton(
                icon: const Icon(Icons.refresh_sharp, color: _kIconColor, size: 24), // Réduction de taille
                onPressed: () async {
                  try {
                    widget.player.seek(Duration.zero);
                    await widget.player.play();
                  } catch (e) {
                    print('Erreur lors du rechargement: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors du rechargement: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}