import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewerScreen extends StatefulWidget {
  final String mediaPath;
  final MediaType mediaType;
  final String title;
  
  const MediaViewerScreen({
    super.key,
    required this.mediaPath,
    required this.mediaType,
    this.title = 'Média',
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.video) {
      _initializeVideoPlayer();
    }
  }
  
  Future<void> _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.asset(widget.mediaPath);
    await _videoController!.initialize();
    setState(() {});
  }
  
  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: _buildMediaContent(),
      ),
    );
  }
  
  Widget _buildMediaContent() {
    switch (widget.mediaType) {
      case MediaType.image:
        return InteractiveViewer(
          child: Image.asset(
            widget.mediaPath,
            fit: BoxFit.contain,
          ),
        );
      
      case MediaType.video:
        if (_videoController == null) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
            if (!_isVideoPlaying)
              GestureDetector(
                onTap: _toggleVideoPlayback,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
          ],
        );
      
      case MediaType.audio:
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.audiotrack,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                widget.mediaPath.split('/').last,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implémenter la lecture audio
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Lire'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      
      case MediaType.document:
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.description,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                widget.mediaPath.split('/').last,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implémenter l'ouverture du document
                },
                icon: const Icon(Icons.download),
                label: const Text('Télécharger'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      
      default:
        return const Text(
          'Type de média non supporté',
          style: TextStyle(color: Colors.white),
        );
    }
  }
  
  void _toggleVideoPlayback() {
    if (_videoController != null) {
      setState(() {
        if (_isVideoPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
        _isVideoPlaying = !_isVideoPlaying;
      });
    }
  }
}

enum MediaType {
  image,
  video,
  audio,
  document,
}