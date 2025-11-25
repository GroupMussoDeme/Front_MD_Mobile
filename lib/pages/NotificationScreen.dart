import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 0;
  
  // Exemple de notifications
  List<NotificationItem> _notifications = [
    NotificationItem(
      title: "Nouveau message",
      content: "Vous avez reçu un nouveau message de Mariam",
      time: "Il y a 10 minutes",
      isRead: false,
    ),
    NotificationItem(
      title: "Mise à jour disponible",
      content: "Une nouvelle version de l'application est disponible",
      time: "Il y a 1 heure",
      isRead: true,
    ),
    NotificationItem(
      title: "Rappel de formation",
      content: "N'oubliez pas votre formation prévue aujourd'hui à 14h",
      time: "Il y a 2 heures",
      isRead: false,
    ),
    NotificationItem(
      title: "Nouveau contenu",
      content: "De nouveaux contenus sont disponibles dans la section Droits des femmes",
      time: "Hier",
      isRead: true,
    ),
  ];
  
  // Liste filtrée pour la recherche
  List<NotificationItem> _filteredNotifications = [];
  
  // Contrôleur pour la barre de recherche
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _filteredNotifications = List.from(_notifications);
    _searchController.addListener(_filterNotifications);
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_filterNotifications);
    _searchController.dispose();
    super.dispose();
  }
  
  // Filtrer les notifications selon le texte de recherche
  void _filterNotifications() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredNotifications = List.from(_notifications);
      } else {
        _filteredNotifications = _notifications
            .where((notification) =>
                notification.title
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ||
                notification.content
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
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
  
  // Marquer une notification comme lue
  void _markAsRead(NotificationItem notification) {
    setState(() {
      final index = _notifications.indexOf(notification);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          title: notification.title,
          content: notification.content,
          time: notification.time,
          isRead: true,
        );
        _filterNotifications();
      }
    });
  }
  
  // Supprimer une notification
  void _deleteNotification(NotificationItem notification) {
    setState(() {
      _notifications.remove(notification);
      _filterNotifications();
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
              color: Color(0xFF5E2B97),
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
                
                // Titre
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 50,
                  child: Center(
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Icône paramètres
                Positioned(
                  right: 20,
                  top: 50,
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      // Paramètres des notifications
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher des notifications...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Liste des notifications
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredNotifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(_filteredNotifications[index]);
              },
            ),
          ),
        ],
      ),
      
      // Barre de navigation inférieure
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[50] : const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: notification.isRead ? Colors.grey[200]! : const Color(0xFF5E2B97),
          width: notification.isRead ? 1 : 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notification.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: notification.isRead ? Colors.grey[800] : const Color(0xFF5E2B97),
                  fontSize: 16,
                ),
              ),
              Text(
                notification.time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification.content,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!notification.isRead)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E2B97),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Nouveau",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              Row(
                children: [
                  // Bouton marquer comme lu
                  if (!notification.isRead)
                    IconButton(
                      icon: const Icon(Icons.check, size: 20),
                      onPressed: () => _markAsRead(notification),
                      tooltip: 'Marquer comme lu',
                    ),
                  // Bouton supprimer
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () => _deleteNotification(notification),
                    tooltip: 'Supprimer',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String content;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.content,
    required this.time,
    this.isRead = false,
  });
}