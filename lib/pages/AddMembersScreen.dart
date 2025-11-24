import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

// Defined colors for consistency
const Color primaryColor = Color(0xFF6A1B9A); // Deep purple
const Color lightPurple = Color(0xFFE1BEE7); // Light purple

class AddMembersScreen extends StatefulWidget {
  const AddMembersScreen({super.key});

  @override
  _AddMembersScreenState createState() => _AddMembersScreenState();
}

class _AddMembersScreenState extends State<AddMembersScreen> {
  // Mock data representing the contacts list
  final List<Map<String, dynamic>> _contacts = [
    {'name': 'Adama Sy', 'isSelected': false},
    {'name': 'Oumar Diallo', 'isSelected': false},
    {'name': 'Fatou Cissé', 'isSelected': false},
    {'name': 'Moussa Traoré', 'isSelected': false},
    {'name': 'Aminata Touré', 'isSelected': true}, // One is pre-selected
  ];

  // State to manage the selected item (assuming single selection based on the radio button look)
  int? _selectedContactIndex; 

  @override
  void initState() {
    super.initState();
    // Find the index of the pre-selected contact to initialize the state
    _selectedContactIndex = _contacts.indexWhere((c) => c['isSelected'] == true);
  }

  void _selectContact(int index) {
    setState(() {
      // Toggle selection: if the same index is tapped, deselect it.
      // Otherwise, select the new index.
      _selectedContactIndex = (_selectedContactIndex == index) ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Top Bar) remplacée par RoundedPurpleContainer ---
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

                ],
              ),
            ),
          ),
        ),
      ),
      // --- Body (Main Content) ---
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30), // Espace pour compenser l'AppBar modifiée
          // Header Section
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 5.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                // Speaker Icon
                const Icon(Icons.volume_up, color: Colors.grey, size: 20),
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

          // --- Contacts List (Scrollable) ---
          Expanded(
            child: ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                final isSelected = _selectedContactIndex == index;
                
                return _buildMemberListItem(
                  name: contact['name'] as String,
                  isSelected: isSelected,
                  onTap: () => _selectContact(index),
                );
              },
            ),
          ),
          
          // --- Action Buttons (X and Check) ---
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.close, primaryColor, () {
                  // Action for Cancel (X)
                  print('Cancel pressed');
                }),
                _buildActionButton(Icons.check, primaryColor, () {
                  // Action for Submit (Check)
                  if (_selectedContactIndex != null) {
                    print('Selected member: ${_contacts[_selectedContactIndex!]['name']}');
                  } else {
                    print('No member selected');
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // --- Widget helper for Member List Item ---
  // -----------------------------------------------------------
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
        // Placeholder for the profile image (Adama Sy)
        child: Icon(Icons.person, color: primaryColor), 
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      trailing: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? primaryColor : primaryColor.withOpacity(0.5),
            width: 2,
          ),
          color: isSelected ? primaryColor : Colors.white,
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // --- Helper Widget for Large Circular Action Buttons (X and Check) ---
  // -----------------------------------------------------------
  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
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