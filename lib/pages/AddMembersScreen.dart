import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Notifications.dart';
import 'package:musso_deme_app/models/marche_models.dart'; // FemmeRurale
import 'package:musso_deme_app/services/femme_rurale_api.dart';

const Color primaryColor = Color(0xFF6A1B9A);
const Color lightPurple = Color(0xFFE1BEE7);

class AddMembersScreen extends StatefulWidget {
  final int cooperativeId;
  final FemmeRuraleApi api;

  const AddMembersScreen({
    super.key,
    required this.cooperativeId,
    required this.api,
  });

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  late Future<List<FemmeRurale>> _contactsFuture;
  int? _selectedContactId;

  @override
  void initState() {
    super.initState();
    _contactsFuture = widget.api.getContactsAjoutablesPourCooperative(
      cooperativeId: widget.cooperativeId,
    );
  }

  void _selectContact(int femmeId) {
    setState(() {
      _selectedContactId = (_selectedContactId == femmeId) ? null : femmeId;
    });
  }

  Future<void> _onValidate() async {
    if (_selectedContactId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un contact à ajouter.'),
        ),
      );
      return;
    }

    try {
      final id = _selectedContactId!;
      await widget.api.ajouterMembreDansCooperative(
        cooperativeId: widget.cooperativeId,
        femmeRuraleId: id,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membre ajouté avec succès à la coopérative.'),
        ),
      );

      if (mounted) {
        Navigator.pop(context, true); // indique à l'écran précédent de recharger
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout du membre : $e'),
        ),
      );
    }
  }

  void _onCancel() {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar arrondi
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
                    'Ajouter membres',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding:
                const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 5.0),
            child: Row(
              children: const [
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: Colors.grey, size: 20),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 24.0, bottom: 15.0),
            child: Text(
              'Contacts sur MussoDèmè',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          // Liste des contacts
          Expanded(
            child: FutureBuilder<List<FemmeRurale>>(
              future: _contactsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erreur lors du chargement des contacts : ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final contacts = snapshot.data ?? [];
                if (contacts.isEmpty) {
                  return const Center(
                    child: Text('Aucun contact disponible à ajouter.'),
                  );
                }

                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final isSelected = _selectedContactId == contact.id;

                    return _buildMemberListItem(
                      name: contact.nomComplet,
                      isSelected: isSelected,
                      onTap: () => _selectContact(contact.id),
                    );
                  },
                );
              },
            ),
          ),

          // Boutons X et ✓
          Padding(
            padding:
                const EdgeInsets.only(top: 20.0, bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.close, primaryColor, _onCancel),
                _buildActionButton(Icons.check, primaryColor, _onValidate),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Item contact
  Widget _buildMemberListItem({
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(
        radius: 25,
        backgroundColor: lightPurple,
        child: Icon(Icons.person, color: primaryColor),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? primaryColor
                : primaryColor.withOpacity(0.5),
            width: 2,
          ),
          color: isSelected ? primaryColor : Colors.white,
        ),
      ),
    );
  }

  // Bouton circulaire (X / ✓)
  Widget _buildActionButton(
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
