import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musso_deme_app/models/contact.dart';
import 'package:musso_deme_app/services/contact_service.dart';
import 'package:musso_deme_app/pages/new_chat_screen.dart';

class SelectContactScreen extends StatefulWidget {
  const SelectContactScreen({super.key});

  @override
  State<SelectContactScreen> createState() => _SelectContactScreenState();
}

class _SelectContactScreenState extends State<SelectContactScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Consumer<ContactService>(
        builder: (context, contactService, child) {
          final contacts = _searchController.text.isEmpty 
              ? contactService.contacts 
              : contactService.searchContacts(_searchController.text);
          
          return Column(
            children: [
              if (_showSearch)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un contact',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _showSearch = false;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              Expanded(
                child: _buildContactsList(contacts),
              ),
            ],
          );
        },
      ),
    );
  }
  
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Nouvelle discussion'),
      backgroundColor: const Color(0xFF4A0072),
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(_showSearch ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                _searchController.clear();
              }
            });
          },
        ),
      ],
    );
  }
  
  Widget _buildContactsList(List<Contact> contacts) {
    if (contacts.isEmpty) {
      return const Center(
        child: Text('Aucun contact trouvé'),
      );
    }
    
    // Grouper les contacts par première lettre du nom
    final Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      final firstLetter = contact.name[0].toUpperCase();
      if (groupedContacts.containsKey(firstLetter)) {
        groupedContacts[firstLetter]!.add(contact);
      } else {
        groupedContacts[firstLetter] = [contact];
      }
    }
    
    // Trier les groupes
    final sortedKeys = groupedContacts.keys.toList()..sort();
    
    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final key = sortedKeys[index];
        final contactsInGroup = groupedContacts[key]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              color: Colors.grey[100],
              child: Text(
                key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...contactsInGroup.map((contact) => _buildContactItem(contact)),
          ],
        );
      },
    );
  }
  
  Widget _buildContactItem(Contact contact) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: contact.profileImage != null
                ? AssetImage(contact.profileImage!)
                : null,
            backgroundColor: Colors.grey[300],
            child: contact.profileImage == null
                ? Icon(
                    Icons.person,
                    color: Colors.grey[600],
                  )
                : null,
          ),
          if (contact.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Text(contact.name),
      subtitle: contact.isOnline
          ? const Text('En ligne')
          : contact.lastSeen != null
              ? Text(contact.lastSeen!)
              : Text(contact.phoneNumber ?? ''),
      onTap: () {
        // Naviguer vers un nouveau chat avec ce contact
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewChatScreen(contact: contact),
          ),
        );
      },
    );
  }
}