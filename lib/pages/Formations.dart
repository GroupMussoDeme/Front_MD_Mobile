import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets
import 'HomeScreen.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';

class FormationVideosPage extends StatefulWidget {
  const FormationVideosPage({super.key});

  @override
  State<FormationVideosPage> createState() => _FormationVideosPageState();
}

class _FormationVideosPageState extends State<FormationVideosPage> {
  int _selectedIndex = 1;
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio
  final List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  final List<String> videoTitles = [
    'Comment vendre ses produits',
    'Comment fabriquer du beurre de karité',
    'Comment tisser du pagne',
  ];

  late List<VideoPlayerController?> _controllers;
  int? _currentPlayingIndex;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(videoUrls.length, (index) => null);
    _initializeAudio(); // Initialisation de l'audio
    _playFormationAudio(); // Lecture de l'audio de formation au démarrage
  }

  // Initialisation du lecteur audio
  void _initializeAudio() {
    _audioPlayer = AudioPlayer();
  }

  // Lecture de l'audio de formation
  Future<void> _playFormationAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioFormation);
      await _audioPlayer.play();
      setState(() {
        _isPlayingAudio = true;
      });
      
      // Mettre à jour l'état lorsque la lecture est terminée
      _audioPlayer.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed,
      ).then((_) {
        if (mounted) {
          setState(() {
            _isPlayingAudio = false;
          });
        }
      });
    } catch (e) {
      print('Erreur lors de la lecture de l\'audio de formation: $e');
    }
  }

  Future<void> _initializeVideo(int index) async {
    if (_controllers[index] != null) return;

    final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrls[index]));
    await controller.initialize();
    controller.setLooping(true);

    setState(() {
      _controllers[index] = controller;
    });
  }

  void _toggleVideoPlayback(int index) {
    if (_controllers[index] == null) return;

    final controller = _controllers[index]!;
    
    if (_currentPlayingIndex == index) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    } else {
      if (_currentPlayingIndex != null && _controllers[_currentPlayingIndex!] != null) {
        _controllers[_currentPlayingIndex!]!.pause();
      }
      controller.play();
      setState(() {
        _currentPlayingIndex = index;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  Widget _buildVideoCard(int index) {
    final controller = _controllers[index];
    final isInitialized = controller?.value.isInitialized ?? false;
    final isPlaying = controller?.value.isPlaying ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video Player
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE0D6EB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: isInitialized
                  ? VideoPlayer(controller!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          
          // Video Info
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    videoTitles[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A0072),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xFF4A0072),
                  ),
                  onPressed: () {
                    _toggleVideoPlayback(index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      if (index == 0) {
        navigateToHome(context);
      } else if (index == 1) {
        // Reste sur la page actuelle
      } else if (index == 2) {
        // Navigation vers le profil
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4A0072),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    "Vidéos de formations",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white, size: 26),
                    onPressed: _playFormationAudio, // Lecture de l'audio de formation
                  ),
                ],
              ),
            ),
          ),
          
          // Video List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videoUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _initializeVideo(index),
                  child: _buildVideoCard(index),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}