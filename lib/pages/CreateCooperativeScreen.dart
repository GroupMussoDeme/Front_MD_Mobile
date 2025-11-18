import 'package:flutter/material.dart';
// import 'package:votre_app/widgets/rounded_purple_container.dart';
// import 'package:votre_app/widgets/bottom_nav_bar.dart'; // Non utilisé ici, mais bonne pratique

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

class CreateCooperativeScreen extends StatefulWidget {
  const CreateCooperativeScreen({super.key});

  @override
  State<CreateCooperativeScreen> createState() => _CreateCooperativeScreenState();
}

class _CreateCooperativeScreenState extends State<CreateCooperativeScreen> {
  // Simule l'état de l'écran (non essentiel ici, mais bonne pratique)
  bool _isLoading = false; 

  void _submitCooperative() {
    setState(() {
      _isLoading = true;
    });
    // Logique de création de coopérative (API call, validation...)
    print('Coopérative en cours de création...');
    // Simuler un délai
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Naviguer ou afficher un message de succès
        Navigator.pop(context); 
        print('Coopérative créée avec succès.');
      }
    });
  }

  void _cancelCreation() {
    Navigator.pop(context);
    print('Création de coopérative annulée.');
  }

  // Widget réutilisable pour une ligne de saisie/action
  Widget _buildCooperativeField({
    required IconData leadingIcon,
    required String text,
    bool isAction = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icône de gauche
          Icon(leadingIcon, color: _kPrimaryPurple, size: 28),
          const SizedBox(width: 15.0),
          
          // Champ de saisie / Bouton d'action
          Expanded(
            child: GestureDetector(
              onTap: isAction ? onTap : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black38),
                ),
                child: isAction
                    ? Text(
                        text,
                        style: const TextStyle(
                          fontSize: 16,
                          color: _kPrimaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: text,
                          hintStyle: const TextStyle(color: Colors.black54),
                        ),
                        // Réglage pour la description si nécessaire
                        maxLines: (text == 'Description') ? 3 : 1, 
                        style: const TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ),
          
          const SizedBox(width: 15.0),
          // Icône de son (volume up)
          const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // En-tête (Widget Réutilisable)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Remplacer par RoundedPurpleContainer
          flexibleSpace: const Placeholder(fallbackHeight: 100, color: _kPrimaryPurple), 
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Nouvelle Copérative',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Zone Image de la coopérative
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: _kPrimaryPurple.withOpacity(0.1),
                  child: const Icon(Icons.people_alt, color: _kPrimaryPurple, size: 80),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: _kPrimaryPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),

            // 2. Champs de saisie
            _buildCooperativeField(
              leadingIcon: Icons.drive_file_rename_outline,
              text: 'Nom du copérative',
            ),
            _buildCooperativeField(
              leadingIcon: Icons.edit_note,
              text: 'Description',
            ),
            
            // 3. Bouton Ajouter des membres
            _buildCooperativeField(
              leadingIcon: Icons.person_add,
              text: 'Ajouter des membres',
              isAction: true,
              onTap: () => print('Ouvrir la liste d\'ajout de membres'),
            ),

            const SizedBox(height: 50.0),

            // 4. Boutons Valider / Annuler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Bouton Annuler (X)
                GestureDetector(
                  onTap: _cancelCreation,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _kPrimaryPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 40),
                  ),
                ),
                
                // Bouton Valider (V)
                GestureDetector(
                  onTap: _submitCooperative,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _kPrimaryPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: _isLoading 
                        ? const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                          )
                        : const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}