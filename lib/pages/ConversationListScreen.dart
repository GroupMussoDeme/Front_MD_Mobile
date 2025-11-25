import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/ModernChatScreen.dart';
import 'package:musso_deme_app/pages/NewChatScreen.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({super.key});

  @override
  State<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends State<ConversationListScreen> {
  // Données de test pour les conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Mariam Coulibaly',
      'lastMessage': 'Bonjour, comment allez-vous ?',
      'time': '10:30',
      'unread': 2,
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
    },
    {
      'name': 'Aïssata Diarra',
      'lastMessage': 'Merci pour votre aide',
      'time': '09:45',
      'unread': 0,
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
    },
    {
      'name': 'Koumba Traore',
      'lastMessage': 'Message vocal (0:45)',
      'time': 'Hier',
      'unread': 5,
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
    },
    {
      'name': 'Fatoumata Sissoko',
      'lastMessage': 'Photo',
      'time': 'Hier',
      'unread': 0,
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
    },
    {
      'name': 'Djeneba Keita',
      'lastMessage': 'À demain !',
      'time': '15/11/2023',
      'unread': 0,
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
    },
  ];

  late List<Map<String, dynamic>> _filteredConversations;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredConversations = _conversations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF5A1A82)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: _filterConversations,
              ),
            ),
          ),
          
          // Liste des conversations
          Expanded(
            child: ListView.builder(
              itemCount: _filteredConversations.length,
              itemBuilder: (context, index) {
                return _buildConversationItem(_filteredConversations[index]);
              },
            ),
          ),
        ],
      ),
      // Bouton flottant pour créer une nouvelle conversation
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewChatScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF5A1A82),
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  // Barre supérieure
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        backgroundColor: const Color(0xFF5A1A82),
        title: const Text(
          'Discussions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Fonction de recherche
              _performSearch();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              switch (result) {
                case 'new_group':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Créer un nouveau groupe')),
                  );
                  break;
                case 'archived':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Discussions archivées')),
                  );
                  break;
                case 'settings':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paramètres')),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'new_group',
                child: Row(
                  children: [
                    Icon(Icons.group, color: Color(0xFF5A1A82), size: 20),
                    SizedBox(width: 10),
                    Text('Nouveau groupe'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'archived',
                child: Row(
                  children: [
                    Icon(Icons.archive, color: Color(0xFF5A1A82), size: 20),
                    SizedBox(width: 10),
                    Text('Discussions archivées'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF5A1A82), size: 20),
                    SizedBox(width: 10),
                    Text('Paramètres'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fonction de recherche
  void _performSearch() {
    // Implémenter la logique de recherche ici
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fonction de recherche')),
    );
  }

  // Filtrer les conversations
  void _filterConversations(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredConversations = _conversations;
      });
    } else {
      setState(() {
        _filteredConversations = _conversations
            .where((conversation) =>
                conversation['name'].toLowerCase().contains(query.toLowerCase()) ||
                conversation['lastMessage'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  // Élément de conversation
  Widget _buildConversationItem(Map<String, dynamic> conversation) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers le chat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ModernChatScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(conversation['avatar']),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),
            
            // Détails de la conversation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation['lastMessage'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Informations de temps et non lus
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  conversation['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                if (conversation['unread'] > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF5A1A82),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      conversation['unread'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}