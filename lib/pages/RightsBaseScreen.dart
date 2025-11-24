import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/services/audio_service.dart';
import 'package:musso_deme_app/services/media_api_service.dart';
import 'package:musso_deme_app/services/contenu.dart';
import 'package:musso_deme_app/widgets/CustomAudioPlayerBar.dart';
import 'package:musso_deme_app/widgets/RightAudioTile.dart';
import 'package:provider/provider.dart';

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);

class RightsBaseScreen extends StatefulWidget {
  final String typeInfo;      // ex: "DROITS_FEMMES"
  final String screenTitle;   // ex: "Droits des femmes"
  final String introMessage;  // texte de la carte d'intro
  final IconData defaultIcon; // icône par défaut pour les lignes

  const RightsBaseScreen({
    super.key,
    required this.typeInfo,
    required this.screenTitle,
    required this.introMessage,
    required this.defaultIcon,
  });

  @override
  State<RightsBaseScreen> createState() => _RightsBaseScreenState();
}

class _RightsBaseScreenState extends State<RightsBaseScreen> {
  late Future<List<Contenu>> _futureContenus;
  int _currentPlayingIndex = -1;
  List<Contenu> _loadedContenus = [];

  @override
  void initState() {
    super.initState();
    // ✅ Utilisation de MediaApiService (et plus AudioApiService)
    _futureContenus = MediaApiService.fetchContenus(
      typeInfo: widget.typeInfo,
      typeCategorie: 'AUDIOS',
    );
  }

  Future<void> _playContenu(Contenu contenu, int index) async {
    setState(() {
      _currentPlayingIndex = index;
    });

    try {
      final audioService = Provider.of<AudioService>(context, listen: false);
      // ✅ Construction de l’URL via MediaApiService
      final fullUrl = MediaApiService.fileUrl(contenu.urlContenu);
      await audioService.playFromUrl(fullUrl, index);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la lecture audio : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _playIntroIfPossible() {
    if (_loadedContenus.isNotEmpty) {
      _playContenu(_loadedContenus[0], 0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aucun audio disponible pour l'instant."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context);

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: primaryViolet,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: neutralWhite),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.screenTitle,
                      style: const TextStyle(
                        color: neutralWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.notifications_none, color: neutralWhite),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
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
      body: Column(
        children: [
          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
              child: Column(
                children: [
                  _buildIntroCard(),
                  const SizedBox(height: 15),
                  _buildListFuture(),
                  const SizedBox(height: 100), // marge pour le player
                ],
              ),
            ),
          ),

          // Player global
          CustomAudioPlayerBar(player: audioService.player),
        ],
      ),
    );
  }

  // Carte d’intro (Intro + logo)
  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: neutralWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Texte + bouton Intro
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.introMessage,
                  style:
                      const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _playIntroIfPossible,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryViolet,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow,
                            color: neutralWhite, size: 20),
                        SizedBox(width: 5),
                        Text(
                          "Intro",
                          style: TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Logo / illustration à droite
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryViolet, width: 2),
              color: Colors.lightBlue.shade50,
            ),
            child: Center(
              child: Image.asset(
                "assets/images/gouverne.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Liste des audios depuis le backend
  Widget _buildListFuture() {
    return FutureBuilder<List<Contenu>>(
      future: _futureContenus,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Erreur lors du chargement des audios : ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final contenus = snapshot.data ?? [];
        _loadedContenus = contenus;

        if (contenus.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Aucun audio disponible pour le moment.",
              style: TextStyle(color: primaryViolet),
            ),
          );
        }

        return Column(
          children: contenus.asMap().entries.map((entry) {
            final index = entry.key;
            final c = entry.value;

            // ✅ gestion sûre de la durée (nullable ou vide)
            final duree = (c.duree != null && c.duree!.trim().isNotEmpty)
                ? c.duree!
                : '3 min 45 s';

            return RightAudioTile(
              icon: widget.defaultIcon,
              title: c.titre,
              duration: duree,
              isPlaying: _currentPlayingIndex == index,
              onTap: () => _playContenu(c, index),
            );
          }).toList(),
        );
      },
    );
  }
}
