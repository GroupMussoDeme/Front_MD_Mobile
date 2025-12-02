import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/AddMembersScreen.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

import 'package:musso_deme_app/models/marche_models.dart'; // Cooperative, FemmeRurale
import 'package:musso_deme_app/services/femme_rurale_api.dart';

const Color primaryColor = Color(0xFF6A1B9A); // violet profond
const Color lightPurple = Color(0xFFE1BEE7);  // violet clair

class GroupInfoScreen extends StatefulWidget {
  final Cooperative cooperative;
  final FemmeRuraleApi api;

  const GroupInfoScreen({
    super.key,
    required this.cooperative,
    required this.api,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  late Future<List<FemmeRurale>> _membersFuture;

  @override
  void initState() {
    super.initState();
    _membersFuture =
        widget.api.getMembresCooperative(cooperativeId: widget.cooperative.id!);
  }

  Future<void> _reloadMembers() async {
    setState(() {
      _membersFuture = widget.api
          .getMembresCooperative(cooperativeId: widget.cooperative.id!);
    });
  }

  Future<void> _openAddMembers() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddMembersScreen(
          cooperativeId: widget.cooperative.id!,
          api: widget.api,
        ),
      ),
    );

    if (added == true) {
      await _reloadMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar arrondi violet
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
                    'Informations du groupe',
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
                  IconButton(
                    icon:
                        const Icon(Icons.open_in_full, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Contenu scrollable
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildGroupInfoCard(),
                      const SizedBox(height: 20),
                      FutureBuilder<List<FemmeRurale>>(
                        future: _membersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Erreur lors du chargement des membres : ${snapshot.error}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }

                          final membres = snapshot.data ?? [];
                          return _buildMembersCard(membres);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Bottom Nav
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(context),
          ),
        ],
      ),
    );
  }

  // Carte d'information sur la coopérative
  Widget _buildGroupInfoCard() {
    final coop = widget.cooperative;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: lightPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people,
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              coop.nom,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'Coopérative',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '${coop.nbrMembres} membre(s)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                coop.description ??
                    'Coopérative pour les formations, se renseigner et vendre ses produits',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  Icons.person_add,
                  'Add',
                  onTap: _openAddMembers,
                ),
                _buildActionButton(Icons.group, 'Group'),
                _buildActionButton(Icons.search, 'Search'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: lightPurple,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, size: 30, color: primaryColor),
      ),
    );
  }

  // Carte des membres (liste dynamique)
  Widget _buildMembersCard(List<FemmeRurale> membres) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Membres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Contacts sur MussoDèmè',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Divider(),
            if (membres.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Aucun membre pour le moment'),
              )
            else
              ...membres.map(
                (m) => _buildMemberListItem(m.nomComplet),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberListItem(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavBar(
      selectedIndex: 0,
      onItemTapped: (index) {
        if (index == 0) {
          navigateToHome(context);
        }
      },
    );
  }
}
