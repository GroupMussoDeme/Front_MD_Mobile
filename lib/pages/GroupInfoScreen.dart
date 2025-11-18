import 'package:flutter/material.dart';

// Constantes de couleur
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

// --- WIDGET PRINCIPAL : INFORMATIONS DU GROUPE ---
class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  int _selectedIndex = 0; // Index par défaut (Accueil)
  
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // Liste des membres (simulée)
  final List<String> _members = ['Adama Sy', 'Fatou Cissé', 'Koumba Diarra', 'Oumou Traoré'];
  
  // Widget pour un bouton d'action rapide
  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _kPrimaryPurple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: _kPrimaryPurple, size: 30),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Widget pour un élément de membre
  Widget _buildMemberTile(String name, String avatarUrl, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          // Bouton radio ou icône de statut (simulé)
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _kPrimaryPurple, width: 2),
            ),
            child: isSelected ? const Center(child: Icon(Icons.circle, color: _kPrimaryPurple, size: 12)) : null,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // En-tête (AppBar)
      appBar: AppBar(
        backgroundColor: _kPrimaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('MUSSO DEME', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Carte d'information du groupe ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar et nom du groupe
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: _kPrimaryPurple.withOpacity(0.1),
                      child: const Icon(Icons.people_alt, color: _kPrimaryPurple, size: 70),
                    ),
                    const SizedBox(height: 10),
                    const Text('MUSSO DEME', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Text('Cooperative', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 15),

                    // Description
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Text(
                        'Cooperative pour les formations, se renseigner et vendre ses produits',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Boutons d'action rapide (Ajouter, Membres, Recherche)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(Icons.person_add, 'Ajouter', () => print('Ajouter membre')),
                        _buildActionButton(Icons.group, 'Membres', () => print('Voir tous les membres')),
                        _buildActionButton(Icons.search, 'Recherche', () => print('Rechercher')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Section Membres ---
            Row(
              children: [
                const Text('Membres', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 10),

            // Liste des membres (seulement le premier est affiché dans le design)
            _buildMemberTile(_members[0], 'https://via.placeholder.com/150/800080/FFFFFF?text=A', isSelected: true),
            
            // Simuler l'affichage de plus de membres
            ..._members.skip(1).map((name) => _buildMemberTile(name, 'https://via.placeholder.com/150/800080/FFFFFF?text=${name.substring(0, 1)}')),

            const SizedBox(height: 50),
          ],
        ),
      ),
      
      // Barre de navigation (Widget Réutilisable)
      bottomNavigationBar: const Placeholder(fallbackHeight: 80, color: _kPrimaryPurple), // Remplacer par BottomNavBar
    );
  }
}