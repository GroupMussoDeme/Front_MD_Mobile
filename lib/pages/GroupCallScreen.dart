import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

// Constantes de couleur
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

// --- WIDGET PRINCIPAL : APPEL DE GROUPE ---
class GroupCallScreen extends StatelessWidget {
  const GroupCallScreen({super.key});

  // Widget pour un participant
  Widget _buildParticipantAvatar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35, // Taille pour une grille 2x3
      height: MediaQuery.of(context).size.width * 0.35,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _kPrimaryPurple, width: 3.0),
      ),
      child: const Icon(
        Icons.person,
        color: _kPrimaryPurple,
        size: 80,
      ),
    );
  }

  // Widget pour les boutons d'action de l'appel
  Widget _buildCallActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isHangUp = false,
  }) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: isHangUp ? 35 : 30),
        onPressed: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // En-tête (AppBar) - modifiée pour ressembler à RoundedPurpleContainer
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
                  const Spacer(),
                  const Text(
                    'Appel groupe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
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
          // --- Section Informations de l'appel ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'MUSSO DEME',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Appel groupe',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Icône de l'appelant / groupe
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: _kPrimaryPurple.withOpacity(0.1),
                    child: const Icon(Icons.person, color: _kPrimaryPurple, size: 30),
                  ),
                ),
              ],
            ),
          ),

          // --- Grille des participants ---
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0, // Rendre les cercles carrés
                ),
                itemCount: 6, // 6 participants comme dans le design
                itemBuilder: (context, index) {
                  return _buildParticipantAvatar(context);
                },
              ),
            ),
          ),

          // --- Barre d'actions d'appel ---
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            decoration: const BoxDecoration(
              color: _kPrimaryPurple,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Haut-parleur
                _buildCallActionButton(
                  icon: Icons.volume_up,
                  color: Colors.white.withOpacity(0.2),
                  onTap: () => print('Toggle haut-parleur'),
                ),
                // Micro (Mute)
                _buildCallActionButton(
                  icon: Icons.mic_off,
                  color: Colors.white.withOpacity(0.2),
                  onTap: () => print('Toggle Mute'),
                ),
                // Raccrocher
                _buildCallActionButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onTap: () => Navigator.pop(context),
                  isHangUp: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}