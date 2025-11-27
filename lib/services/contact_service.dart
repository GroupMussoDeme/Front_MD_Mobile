import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/contact.dart';

class ContactService with ChangeNotifier {
  final List<Contact> _contacts = [];
  
  ContactService() {
    _loadSampleContacts();
  }

  List<Contact> get contacts => _contacts;
  
  List<Contact> get favoriteContacts {
    return _contacts.where((contact) => contact.isFavorite).toList();
  }
  
  List<Contact> get onlineContacts {
    return _contacts.where((contact) => contact.isOnline).toList();
  }
  
  // Charger des contacts d'exemple
  void _loadSampleContacts() {
    _contacts.addAll([
      Contact(
        id: '1',
        name: 'Aïssata Coulibaly',
        phoneNumber: '+223 70 00 00 01',
        profileImage: 'assets/images/Ellipse 77.png',
        isOnline: true,
        isFavorite: true,
      ),
      Contact(
        id: '2',
        name: 'Koumba Diarra',
        phoneNumber: '+223 70 00 00 02',
        profileImage: 'assets/images/Ellipse 77.png',
        isOnline: false,
        lastSeen: 'Il y a 2 heures',
        isFavorite: true,
      ),
      Contact(
        id: '3',
        name: 'Fatoumata Traoré',
        phoneNumber: '+223 70 00 00 03',
        profileImage: 'assets/images/Ellipse 77.png',
        isOnline: true,
        isFavorite: false,
      ),
      Contact(
        id: '4',
        name: 'Mariam Keita',
        phoneNumber: '+223 70 00 00 04',
        profileImage: 'assets/images/Ellipse 77.png',
        isOnline: false,
        lastSeen: 'Il y a 1 jour',
        isFavorite: false,
      ),
      Contact(
        id: '5',
        name: 'Hawa Diallo',
        phoneNumber: '+223 70 00 00 05',
        profileImage: 'assets/images/Ellipse 77.png',
        isOnline: true,
        isFavorite: true,
      ),
      Contact(
        id: '6',
        name: 'Aminata Sidibé',
        phoneNumber: '+223 70 00 00 06',
        profileImage: 'assets/images/Ellipse 77.png',
        isOnline: false,
        lastSeen: 'Il y a 3 jours',
        isFavorite: false,
      ),
    ]);
    notifyListeners();
  }
  
  // Ajouter un nouveau contact
  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
  }
  
  // Mettre à jour un contact
  void updateContact(Contact contact) {
    final index = _contacts.indexWhere((c) => c.id == contact.id);
    if (index != -1) {
      _contacts[index] = contact;
      notifyListeners();
    }
  }
  
  // Supprimer un contact
  void removeContact(String contactId) {
    _contacts.removeWhere((contact) => contact.id == contactId);
    notifyListeners();
  }
  
  // Rechercher des contacts
  List<Contact> searchContacts(String query) {
    if (query.isEmpty) {
      return _contacts;
    }
    
    return _contacts.where((contact) {
      final name = contact.name.toLowerCase();
      final phone = contact.phoneNumber?.toLowerCase() ?? '';
      final searchQuery = query.toLowerCase();
      
      return name.contains(searchQuery) || phone.contains(searchQuery);
    }).toList();
  }
  
  // Basculer le statut favori d'un contact
  void toggleFavorite(String contactId) {
    final index = _contacts.indexWhere((c) => c.id == contactId);
    if (index != -1) {
      _contacts[index] = _contacts[index].copyWith(
        isFavorite: !_contacts[index].isFavorite,
      );
      notifyListeners();
    }
  }
}