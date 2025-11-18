import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

// You would typically define colors and styles in a separate file.
const Color primaryColor = Color(0xFF6A1B9A); // A deep purple similar to the image
const Color lightPurple = Color(0xFFE1BEE7); // For the card backgrounds or light elements

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remplacement de l'AppBar par RoundedPurpleContainer avec flèche et titre
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
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
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
                    icon: const Icon(Icons.open_in_full, color: Colors.white),
                    onPressed: () {},
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
      // --- Use a Stack to position the content above the BottomNavigationBar ---
      body: Stack(
        children: [
          // 1. Scrollable Content Area
          SingleChildScrollView(
            child: Column(
              children: [
                // Padding for the main content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // --- Group Info Card (Top Card) ---
                      _buildGroupInfoCard(),
                      const SizedBox(height: 20),
                      // --- Members Card (Bottom Card) ---
                      _buildMembersCard(),
                    ],
                  ),
                ),
                // Spacer to ensure content doesn't get covered by the nav bar
                const SizedBox(height: 80), 
              ],
            ),
          ),
          // 2. Bottom Navigation Bar (positioned at the bottom)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  // --- Widget for the Group Info Card ---
  Widget _buildGroupInfoCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: [
            // Group Icon with Background
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: lightPurple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people, // Representative icon for a group
                size: 60,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            // Group Name and Type
            const Text(
              'MUSSO DEME',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'Cooperative',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            // Description Bubble
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                'Cooperative pour les formations, se renseigner et vendre ses produits',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(Icons.person_add, 'Add'),
                _buildActionButton(Icons.group, 'Group'),
                _buildActionButton(Icons.search, 'Search'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget for Action Buttons ---
  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      width: 70, // Fixed width for a square/circular look
      height: 70,
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(15), // Slightly rounded square
        // shape: BoxShape.circle, // Use BoxShape.circle for a fully circular look
      ),
      child: Icon(icon, size: 30, color: primaryColor),
    );
  }

  // --- Widget for the Members Card ---
  Widget _buildMembersCard() {
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
            // Single Member Item (repeated for a full list)
            _buildMemberListItem('Adama Sy'),
          ],
        ),
      ),
    );
  }

  // --- Helper Widget for Member List Item ---
  Widget _buildMemberListItem(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Profile Picture Placeholder
          const CircleAvatar(
            radius: 20,
            backgroundColor: primaryColor,
            // Replace with Image.asset or NetworkImage for a real image
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          // Member Name
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          // Radio Button or Checkbox (empty circle in the image)
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

  // --- Widget for the Bottom Navigation Bar (remplacé par BottomNavBar) ---
  Widget _buildBottomNavigationBar() {
    return BottomNavBar(
      selectedIndex: 0, // Vous pouvez ajuster l'index sélectionné selon vos besoins
      onItemTapped: (index) {
        // Vous pouvez ajouter la logique de navigation ici
        print('Item tapé: $index');
      },
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

// To run this code, you would use:
// void main() {
//   runApp(MaterialApp(home: GroupInfoScreen()));
// }