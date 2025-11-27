import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/widgets/VocalIcon.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2; // Profil sélectionné par défaut
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _playAudio();
  }

  void _playAudio() async {
    try {
      // Lecture automatique de l'audio "profil afficher.aac"
      await Future.delayed(const Duration(milliseconds: 500)); // Petit délai avant de commencer
      await audioPlayer.setAsset("assets/audios/profil afficher.aac");
      await audioPlayer.play();
    } catch (e) {
      print("Erreur lors de la lecture de l'audio: $e");
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Si l'utilisateur clique sur l'icône Home (index 0)
      if (index == 0) {
        // Retourner à la page d'accueil
        navigateToHome(context);
      }
      // Si l'utilisateur clique sur l'icône centrale (index 1) - Formations
      else if (index == 1) {
        // Naviguer vers la page Formations
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      }
      // Si l'utilisateur clique sur l'icône de profil (index 2)
      else if (index == 2) {
        // Nous sommes déjà sur la page de profil, donc on ne fait rien
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Remplacer l'en-tête violet existant par un conteneur personnalisé avec flèche retour et titre
          Container(
            height: 100.0,
            decoration: const BoxDecoration(
              color: Color(0xFF5E2B97), // Couleur violette du design
              // Arrondi seulement le coin inférieur gauche et inférieur droit
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flèche de retour
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  // Titre centré
                  const Text(
                    'Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Icône vocale
                  VocalIcon(
                    onPressed: () {
                      // TODO: Implémenter la fonctionnalité vocale
                    },
                    isActive: true,
                  ),
                ],
              ),
            ),
          ),
          
          // Contenu principal
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
                  child: Column(
                    children: [
                      _buildMainCard(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCircleActionButton(Icons.edit_outlined),
                          const SizedBox(width: 40),
                          _buildCircleActionButton(Icons.volume_up_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // Remplacer la barre de navigation personnalisée par BottomNavBar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCircleActionButton(IconData icon) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF4A148C), size: 30),
    );
  }

  Widget _buildMainCard() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                "Djassi KONE",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 5),
              const Text(
                "Femme rurale",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "Utilisant l'application pour se renseigner et vendre ses produits",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoField("Numéro", "75 45 75 45"),
              const Divider(height: 30, color: Colors.purpleAccent),
              _buildInfoField("Mot clé", "djago1"),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Colors.purpleAccent),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.purple.shade100, width: 3),
                  color: Colors.white,
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg'),
                  backgroundColor: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A148C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}