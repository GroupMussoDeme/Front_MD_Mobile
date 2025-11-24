import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';

// Définition des couleurs pour la cohérence
const Color primaryColor = Color(0xFF6A1B9A); // Violet foncé
const Color lightPurple = Color(0xFFE1BEE7); // Violet clair

class NotificationsScreen extends StatelessWidget {
  // Données factices pour la liste de notifications
  final List<Map<String, String>> _notifications = const [
    {'title': 'Nouvelle commande', 'description': 'Vous avez une nouvelles commande pour vos produits/', 'time': 'Il y a 2h'},
    {'title': 'Nouvelle commande', 'description': 'Vous avez une nouvelles commande pour vos produits/', 'time': 'Il y a 2h'},
    {'title': 'Nouvelle commande', 'description': 'Vous avez une nouvelles commande pour vos produits/', 'time': 'Il y a 2h'},
    {'title': 'Nouvelle commande', 'description': 'Vous avez une nouvelles commande pour vos produits/', 'time': 'Il y a 2h'},
    {'title': 'Nouvelle commande', 'description': 'Vous avez une nouvelles commande pour vos produits/', 'time': 'Il y a 2h'},
    {'title': 'Nouvelle commande', 'description': 'Vous avez une nouvelles commande pour vos produits/', 'time': 'Il y a 2h'},
  ];

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Barre du haut) remplacée par RoundedPurpleContainer ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: primaryColor,
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
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      // --- Body (Contenu principal) ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30), // Espace pour compenser l'AppBar modifiée
          // En-tête (Titre et icône sonore)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 15.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                const Icon(Icons.volume_up, color: Colors.grey, size: 20),
              ],
            ),
          ),

          // Banner de notifications non lues
          _buildUnreadBanner(),

          // Liste des notifications (Défilable)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                // La première notification n'a pas de ligne de séparation en haut
                bool showDivider = index > 0;
                return _buildNotificationItem(
                  notification['title']!,
                  notification['description']!,
                  notification['time']!,
                  showDivider,
                );
              },
            ),
          ),
        ],
      ),
      
      // --- Bottom Navigation Bar (remplacé par BottomNavBar) ---
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0, // Vous pouvez ajuster l'index sélectionné selon vos besoins
        onItemTapped: (index) {
          // Vous pouvez ajouter la logique de navigation ici
          print('Item tapé: $index');
        },
      ),
    );
  }

  // -----------------------------------------------------------
  // --- Widget pour la bannière de notifications non lues ---
  // -----------------------------------------------------------
  Widget _buildUnreadBanner() {
    return Container(
      color: lightPurple,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: primaryColor, size: 18),
              const SizedBox(width: 8),
              const Text(
                '1 notification non lue',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              // Action pour marquer tout comme lu
            },
            child: const Text(
              'TOUT MARQUER COMME LU',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // --- Widget pour un élément de notification individuel ---
  // -----------------------------------------------------------
  Widget _buildNotificationItem(String title, String description, String time, bool showTopDivider) {
    return Column(
      children: [
        if (showTopDivider) const Divider(height: 1, thickness: 1, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icône horloge
              const Icon(Icons.alarm, color: primaryColor, size: 24),
              const SizedBox(width: 15),

              // Contenu du texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Icône sonore à droite
              const Icon(Icons.volume_up, color: primaryColor, size: 24),
            ],
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // --- Widget pour la barre de navigation inférieure ---
  // -----------------------------------------------------------
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Accueil', true),
          _buildNavItem(Icons.storage, 'Formation', false), // Utilisation de storage pour la base de données
          _buildNavItem(Icons.person, 'Profil', false),
        ],
      ),
    );
  }

  // --- Helper Widget for Navigation Bar Items ---
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white, size: 28),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
