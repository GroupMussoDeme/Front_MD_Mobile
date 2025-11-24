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

  @override
  Widget build(BuildContext context) {
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
          // Back
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
          // Bouton play/pause
          if (_isReady)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: IconButton(
                  iconSize: 56,
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: kPrimaryPurple,
                  ),
                  onPressed: _togglePlayPause,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
