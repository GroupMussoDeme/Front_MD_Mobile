import 'package:flutter/material.dart';

// --- Définition des couleurs de la Charte Graphique ---
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color darkGrey = Color(0xFF707070);
const Color callEndRed = Color(0xFFD32F2F); // Un rouge standard pour terminer l'appel

// *****************************************************************
// 1. Composant réutilisable pour les boutons d'appel en bas
// *****************************************************************
class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double size;

  const CallActionButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        // Ombre légère pour les boutons
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: neutralWhite, size: size * 0.5),
        onPressed: onPressed,
      ),
    );
  }
}

// *****************************************************************
// 2. Écran d'Appel en Cours
// *****************************************************************
class AppelScreen extends StatelessWidget {
  const AppelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Le nom de l'interlocuteur
    const String contactName = "Kafo Jiginew";
    
    return Scaffold(
      backgroundColor: neutralWhite,
      appBar: null,
      
      body: Stack(
        children: [
          // Header violet arrondi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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
                      Expanded(
                        child: Text(
                          'Appel en cours... "$contactName"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: neutralWhite),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu principal
          Positioned.fill(
            top: 100,
            child: Column(
              children: [
                // Espace principal du contenu de l'appel
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nom du contact et icône de profil
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contactName,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  "Appel",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: darkGrey,
                                  ),
                                ),
                              ],
                            ),
                            // Icône de profil du contact
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: primaryViolet,
                              child: Icon(Icons.person_outline, color: neutralWhite, size: 30),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 80),

                      // Grand cercle central avec l'icône/logo du contact
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryViolet.withOpacity(0.5), width: 2),
                          color: Colors.white,
                        ),
                        child: Center(
                          // Placeholder pour l'icône de la maison/logo "Kafo Jiginew"
                          child: Container(
                            width: 100,
                            height: 100,
                            // L'image du logo est simulée par un fond vert et une bordure
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green.shade800, width: 1.5),
                              color: Colors.green.shade50,
                            ),
                            child: Center(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                      // Icône de maison simulée
                                      Icon(Icons.house_outlined, color: Colors.green.shade800, size: 40),
                                      const Text("Kafo Jiginew", style: TextStyle(color: Colors.black, fontSize: 10)),
                                  ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // On peut ajouter ici un Timer d'appel
                      const SizedBox(height: 50),
                      const Text(
                          "00:45",
                          style: TextStyle(fontSize: 20, color: darkGrey),
                      ),
                    ],
                  ),
                ),
                
                // Barre d'actions d'appel en bas
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: const BoxDecoration(
              color: primaryViolet,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Bouton Haut-parleur (actif par défaut dans le design)
                CallActionButton(
                  icon: Icons.volume_up,
                  backgroundColor: neutralWhite.withOpacity(0.2), // Plus clair que le violet, comme sur le design
                  onPressed: () {
                    // Action pour activer/désactiver le haut-parleur
                  },
                  size: 65,
                ),
                
                // Bouton Microphone
                CallActionButton(
                  icon: Icons.mic_off,
                  backgroundColor: neutralWhite.withOpacity(0.2),
                  onPressed: () {
                    // Action pour couper/réactiver le micro
                  },
                  size: 65,
                ),
                
                // Bouton Raccrocher (Rouge)
                CallActionButton(
                  icon: Icons.call_end,
                  backgroundColor: callEndRed,
                  onPressed: () {
                    // Action pour terminer l'appel
                  },
                  size: 65,
                ),
              ],
            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}