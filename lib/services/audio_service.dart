import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class AudioService with ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String _currentAudioAsset = '';
  int _currentTrackIndex = -1;

  AudioPlayer get player => _player;
  String get currentAudioAsset => _currentAudioAsset;
  int get currentTrackIndex => _currentTrackIndex;

  /// Vérifie si un fichier audio existe dans les assets
  Future<bool> _assetExists(String assetPath) async {
    try {
      // Charger le manifeste des assets
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      // Vérifier si le chemin du fichier est présent dans le manifeste
      return manifestContent.contains(assetPath);
    } catch (e) {
      print('Erreur lors de la vérification de l\'existence du fichier: $e');
      return false;
    }
  }

  Future<void> playAudio(String assetPath, int trackIndex) async {
    try {
      // Vérifier si le fichier existe
      final exists = await _assetExists(assetPath);
      if (!exists) {
        throw Exception('Fichier audio introuvable: $assetPath');
      }

      // Si c'est le même fichier et qu'il est déjà chargé, on reprend la lecture
      if (_currentAudioAsset == assetPath && _player.duration != null) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
      } else {
        // Charger et jouer un nouveau fichier
        _currentAudioAsset = assetPath;
        _currentTrackIndex = trackIndex;
        await _player.setAsset(assetPath);
        await _player.play();
      }
      
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la lecture audio: $e');
      rethrow;
    }
  }

  Future<void> pauseAudio() async {
    if (_player.playing) {
      await _player.pause();
      notifyListeners();
    }
  }

  Future<void> resumeAudio() async {
    if (!_player.playing) {
      await _player.play();
      notifyListeners();
    }
  }

  Future<void> stopAudio() async {
    await _player.stop();
    _currentAudioAsset = '';
    _currentTrackIndex = -1;
    notifyListeners();
  }

  void seekTo(Duration position) {
    _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}