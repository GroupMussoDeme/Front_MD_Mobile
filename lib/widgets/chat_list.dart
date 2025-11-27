import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musso_deme_app/models/contact.dart';
import 'package:musso_deme_app/services/contact_service.dart';
import 'package:musso_deme_app/pages/select_contact_screen.dart';
import 'package:musso_deme_app/pages/new_chat_screen.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactService>(
      builder: (context, contactService, child) {
        final favoriteContacts = contactService.favoriteContacts;
        
        return Column(
          children: [
            // En-tête avec bouton pour nouvelle discussion
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discussions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Implémenter l'édition des discussions
                    },
                  ),
                ],
              ),
            ),
            
            // Section des contacts favoris
            if (favoriteContacts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Favoris',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Naviguer vers l'écran de sélection de contacts
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectContactScreen(),
                          ),
                        );
                      },
                      child: const Text('Nouveau'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: favoriteContacts.length,
                  itemBuilder: (context, index) {
                    final contact = favoriteContacts[index];
                    return _buildFavoriteContactItem(context, contact);
                  },
                ),
              ),
            ],
            
            // Liste des discussions récentes
            Expanded(
              child: _buildRecentChatsList(context, contactService),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildFavoriteContactItem(BuildContext context, Contact contact) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
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
                    width: 16,
                    height: 16,
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
          const SizedBox(height: 8),
          Text(
            contact.name.split(' ')[0], // Prénom seulement
            style: const TextStyle(
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentChatsList(BuildContext context, ContactService contactService) {
    final contacts = contactService.contacts;
    
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
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
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '12:45',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFF4A0072),
                child: Text(
                  '2',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
      },
    );
  }
}