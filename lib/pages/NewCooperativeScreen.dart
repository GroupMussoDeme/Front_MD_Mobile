import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/RoundedPurpleContainer.dart';
import 'package:musso_deme_app/pages/AddMembersScreen.dart';
import 'package:musso_deme_app/pages/Notifications.dart';

// Defined colors for consistency
const Color primaryColor = Color(0xFF6A1B9A); // Deep purple
const Color lightPurple = Color(0xFFE1BEE7); // Light purple

class NewCooperativeScreenRevised extends StatelessWidget {
  // Controllers to manage the text input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  NewCooperativeScreenRevised({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (Top Bar) remplacée par RoundedPurpleContainer ---
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Stack(
          children: [
            const RoundedPurpleContainer(height: 100.0),
            SafeArea(
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
                      'Nouvelle Coopérative',
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
          ],
        ),
      ),
      // --- Body (Main Content) ---
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // --- Group Icon with Camera Button ---
              Center(
                child: Stack(
                  children: [
                    // Large Group Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: lightPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.people, // Group icon
                        size: 80,
                        color: primaryColor,
                      ),
                    ),
                    // Camera Button Overlay
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: lightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- Form Fields using TextFormField ---
              // 1. Nom du coopérative (Name)
              _buildFormInput(
                icon: Icons.group,
                hintText: 'Nom du coopérative',
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              
              // 2. Description
              _buildFormInput(
                icon: Icons.edit,
                hintText: 'Description',
                controller: _descriptionController,
              ),
              const SizedBox(height: 20),
              
              // 3. Ajouter des membres (Button, no input field)
              _buildFormButton(
                icon: Icons.person_add,
                text: 'Ajouter des membres',
                onTap: () {
                  // Redirection vers AddMembersScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMembersScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),

              // --- Action Buttons (X and Check) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(Icons.close, primaryColor, () {
                    // Action for Cancel (X)
                  }),
                  _buildActionButton(Icons.check, primaryColor, () {
                    // Action for Submit (Check)
                    print('Cooperative Name: ${_nameController.text}');
                    print('Description: ${_descriptionController.text}');
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // --- Widget helper for text input (TextField / TextFormField) ---
  // ------------------------------------------------------------------
  Widget _buildFormInput({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Icon (Input Decorator)
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200, 
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
        ),

        // TextFormField (The main difference)
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade600),
              // To achieve the desired rounded/colored background look
              filled: true,
              fillColor: Colors.grey.shade100, // Light background for text area
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none, // Removes the standard border line
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: primaryColor, width: 1.0), // Optional focus highlight
              ),
            ),
          ),
        ),

        // Right Icon (Sound/Voice)
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Icon(Icons.volume_up, color: Colors.grey, size: 20),
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  // --- Widget helper for the 'Add Members' button (different style) ---
  // -----------------------------------------------------------
  Widget _buildFormButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        // Left Icon
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Light gray
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
        ),

        // Button/Text Field Container
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: lightPurple, // Light purple background for the button
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Right Icon (Sound/Voice)
        const Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Icon(Icons.volume_up, color: Colors.grey, size: 20),
        ),
      ],
    );
  }


  // --- Helper Widget for Large Circular Action Buttons (X and Check) ---
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