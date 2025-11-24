import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/services/audio_service.dart';
import 'package:musso_deme_app/services/contenu.dart';
import 'package:musso_deme_app/services/media_api_service.dart';
import 'package:musso_deme_app/widgets/CustomAudioPlayerBar.dart';
import 'package:provider/provider.dart';

const Color _kPrimaryPurple = Color(0xFF491B6D);
const Color _kBackgroundColor = Colors.white;
const Color _kLightGrey = Color(0xFFF0F0F0);
const Color _kDarkGrey = Color(0xFF707070);

class BackendAudioContentScreen extends StatefulWidget {
  final String screenTitle;
  final String introMessage;
  final String typeInfo;
  final String typeCategorie;
  final IconData defaultIcon; // icône pour les lignes

  const BackendAudioContentScreen({
    super.key,
    required this.screenTitle,
    required this.introMessage,
    required this.typeInfo,
    required this.typeCategorie,
    required this.defaultIcon,
  });

  @override
  State<BackendAudioContentScreen> createState() =>
      _BackendAudioContentScreenState();
}

class _BackendAudioContentScreenState extends State<BackendAudioContentScreen> {
  late Future<List<Contenu>> _futureContenus;
  int _currentPlayingIndex = -1; // piste en cours

  @override
  void initState() {
    super.initState();
    _futureContenus = MediaApiService.fetchContenus(
      typeInfo: widget.typeInfo,
      typeCategorie: widget.typeCategorie,
    );
  }

  Future<void> _playContenu(Contenu contenu, int index) async {
    setState(() {
      _currentPlayingIndex = index;
    });

    try {
      final audioService = Provider.of<AudioService>(context, listen: false);
      final fullUrl = MediaApiService.fileUrl(contenu.urlContenu);
      await audioService.playFromUrl(fullUrl, index);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la lecture audio : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildIntroCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _kPrimaryPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.introMessage,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton.icon(
                  onPressed: () {
                    // si un jour tu as un audio "intro" dédié, tu peux le jouer ici
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text('Intro',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 22,
            backgroundColor: _kPrimaryPurple,
            child: Icon(Icons.tag_faces_rounded,
                color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioRow(Contenu contenu, int index) {
    final isPlaying = _currentPlayingIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: _kBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // icône
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kPrimaryPurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.defaultIcon,
              color: _kPrimaryPurple,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),

          // titre + durée
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contenu.titre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        isPlaying ? FontWeight.w700 : FontWeight.w500,
                    color: _kPrimaryPurple,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contenu.duree ?? '3 min 45 s',
                  style:
                      const TextStyle(fontSize: 12, color: _kDarkGrey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // bouton Play/Pause
          GestureDetector(
            onTap: () => _playContenu(contenu, index),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPlaying ? _kPrimaryPurple : _kBackgroundColor,
                border: Border.all(color: _kPrimaryPurple, width: 1.8),
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isPlaying ? Colors.white : _kPrimaryPurple,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);

    return Scaffold(
      backgroundColor: _kBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: _kPrimaryPurple,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.screenTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contenu>>(
          future: _futureContenus,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Erreur lors du chargement des audios : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final contenus = snapshot.data ?? [];
            if (contenus.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Aucun audio pour le moment.',
                  style: TextStyle(color: _kPrimaryPurple),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIntroCard(),
                ...List.generate(
                  contenus.length,
                  (index) => _buildAudioRow(contenus[index], index),
                ),
                const SizedBox(height: 120),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomAudioPlayerBar(player: audioService.player),
    );
  }
}
