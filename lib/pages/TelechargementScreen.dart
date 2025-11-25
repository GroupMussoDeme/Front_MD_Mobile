import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart'; // Ajout de l'import pour la lecture audio
import 'package:musso_deme_app/constants/assets.dart'; // Ajout de l'import pour les assets

class TelechargementScreen extends StatefulWidget {
  const TelechargementScreen({super.key});

  @override
  State<TelechargementScreen> createState() => _TelechargementScreenState();
}

class _TelechargementScreenState extends State<TelechargementScreen> {
  int _selectedIndex = 1;
  late AudioPlayer _audioPlayer; // Ajout du lecteur audio
  bool _isPlayingAudio = false; // État de lecture de l'audio

  // Exemple de fichiers à télécharger
  final List<DownloadItem> _downloadItems = [
    DownloadItem(
      title: "Conseil pour les femmes enceintes",
      duration: "10 min 30 s",
    ),
    DownloadItem(
      title: "Conseil pour les nouvelles mères",
      duration: "12 min 15 s",
    ),
    DownloadItem(
      title: "Droits des femmes au Mali",
      duration: "8 min 45 s",
    ),
    DownloadItem(
      title: "Nutrition pendant la grossesse",
      duration: "15 min 20 s",
    ),
    DownloadItem(
      title: "Protection contre la violence",
      duration: "9 min 30 s",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playDownloadAudio(); // Lecture de l'audio de téléchargement au démarrage
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libération des ressources audio
    super.dispose();
  }

  // Lecture de l'audio de téléchargement
  Future<void> _playDownloadAudio() async {
    try {
      await _audioPlayer.setAsset(AppAssets.audioTelechargements);
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
      print('Erreur lors de la lecture de l\'audio de téléchargement: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Navigation
      if (index == 0) {
        // Accueil
      } else if (index == 1) {
        // Formation
      } else if (index == 2) {
        // Profil
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // En-tête violette
          Container(
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF5A1A82),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                // Flèche retour
                Positioned(
                  left: 20,
                  top: 50,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                
                // Heure
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Center(
                    child: Text(
                      "10:00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Icônes réseau/batterie
                Positioned(
                  right: 60,
                  top: 50,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.signal_cellular_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 20,
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.7,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Icône haut-parleur
                Positioned(
                  right: 20,
                  top: 50,
                  child: IconButton(
                    icon: Icon(
                      _isPlayingAudio ? Icons.pause : Icons.volume_up,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _playDownloadAudio, // Lecture de l'audio de téléchargement
                  ),
                ),
              ],
            ),
          ),
          
          // Contenu principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  const Text(
                    "Historique des téléchargements",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Liste des téléchargements
                  Expanded(
                    child: ListView.builder(
                      itemCount: _downloadItems.length,
                      itemBuilder: (context, index) {
                        return _buildDownloadItem(_downloadItems[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Barre de navigation inférieure
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF5A1A82),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Accueil", 0),
            _buildNavItem(Icons.library_books, "Formation", 1),
            _buildNavItem(Icons.person, "Profil", 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadItem(DownloadItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône deux cœurs imbriqués
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF5A1A82).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                FontAwesomeIcons.heart,
                color: Color(0xFF5A1A82),
                size: 24,
              ),
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.duration,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Boutons
          Row(
            children: [
              // Bouton play
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF5A1A82),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Icône poubelle
              const Icon(
                Icons.delete,
                color: Color(0xFFD03A3A),
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white70,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadItem {
  final String title;
  final String duration;

  DownloadItem({
    required this.title,
    required this.duration,
  });
}