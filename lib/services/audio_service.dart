import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  int? currentIndex;
  bool isPlaying = false;

  Future<void> playAsset(String assetPath, int index) async {
    try {
      await player.setAsset(assetPath);
      await player.play();
      currentIndex = index;
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lecture asset: $e');
      rethrow;
    }
  }

  Future<void> playFromUrl(String url, int index) async {
    try {
      await player.setUrl(url);
      await player.play();
      currentIndex = index;
      isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lecture URL: $e');
      rethrow;
    }
  }

  Future<void> pause() async {
    await player.pause();
    isPlaying = false;
    notifyListeners();
  }

  Future<void> stop() async {
    await player.stop();
    isPlaying = false;
    currentIndex = null;
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
