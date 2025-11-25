import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Color kPrimaryPurple = Color(0xFF491B6D);

class FullScreenVideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const FullScreenVideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  late VideoPlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..addListener(() {
        // On force le rebuild pour mettre à jour la barre et les temps
        if (!mounted) return;
        setState(() {});
      })
      ..initialize().then((_) {
        setState(() => _isReady = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isReady) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = d.inHours;
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final duration = _controller.value.duration;
    final position = _controller.value.position;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isReady
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
          // Bouton retour
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          // Titre
          Positioned(
            top: 45,
            left: 60,
            right: 16,
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          // Contrôles du lecteur
          if (_isReady)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barre de progression manipulable
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: kPrimaryPurple,
                        bufferedColor: Colors.white38,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Temps + Play/Pause
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Temps courant
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Bouton Play/Pause
                      IconButton(
                        iconSize: 56,
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: kPrimaryPurple,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      const SizedBox(width: 8),
                      // Durée totale
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
