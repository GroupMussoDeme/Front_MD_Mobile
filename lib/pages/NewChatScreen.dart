import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/ModernChatScreen.dart';
import 'package:musso_deme_app/pages/NewCooperativeScreen.dart'; // Ajout de l'import

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isRecording = false;
  String _recordedAudioPath = '';

  // Données de test pour les contacts
  final List<Map<String, dynamic>> _contacts = [
    {
      'name': 'Mariam Coulibaly',
      'phone': '75 45 75 45',
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
      'isOnline': true,
    },
    {
      'name': 'Aïssata Diarra',
      'phone': '75 45 75 46',
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
      'isOnline': false,
    },
    {
      'name': 'Koumba Traore',
      'phone': '75 45 75 47',
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
      'isOnline': true,
    },
    {
      'name': 'Fatoumata Sissoko',
      'phone': '75 45 75 48',
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
      'isOnline': false,
    },
    {
      'name': 'Djeneba Keita',
      'phone': '75 45 75 49',
      'avatar': 'https://img.freepik.com/free-photo/portrait-young-african-woman-with-traditional-clothes_23-2148928488.jpg',
      'isOnline': true,
    },
  ];

  List<Map<String, dynamic>> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _filteredContacts = _contacts;
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredContacts = _contacts;
      });
    } else {
      setState(() {
        _filteredContacts = _contacts
            .where((contact) =>
                contact['name'].toLowerCase().contains(query) ||
                contact['phone'].contains(query))
            .toList();
      });
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    
    // Simuler l'enregistrement
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isRecording = false;
        _recordedAudioPath = 'chemin/vers/audio.mp3';
      });
      
      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message vocal enregistré')),
      );
    });
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
  }

  void _sendVoiceMessage() {
    if (_recordedAudioPath.isNotEmpty) {
      // Envoyer le message vocal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message vocal envoyé')),
      );
      
      setState(() {
        _recordedAudioPath = '';
      });
    }
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
              ),
            ),
          ),
          
          // Liste des contacts
          Expanded(
            child: ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                return _buildContactItem(_filteredContacts[index]);
              },
            ),
          ),
        ],
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
          'Nouvelle discussion',
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
              // Fonction de recherche (à implémenter)
              _performSearch();
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (String result) {
              switch (result) {
                case 'new_group':
                  // Naviguer vers la page nouvelle coopérative
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewCooperativeScreenRevised(),
                    ),
                  );
                  break;
                case 'new_broadcast':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nouvelle diffusion')),
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
                value: 'new_broadcast',
                child: Row(
                  children: [
                    Icon(Icons.campaign, color: Color(0xFF5A1A82), size: 20),
                    SizedBox(width: 10),
                    Text('Nouvelle diffusion'),
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

  // Élément de contact
  Widget _buildContactItem(Map<String, dynamic> contact) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers le chat avec ce contact
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(contact['avatar']),
                  backgroundColor: Colors.grey[300],
                ),
                // Indicateur de statut en ligne
                if (contact['isOnline'])
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            
            // Détails du contact
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact['phone'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}