import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
import 'package:musso_deme_app/pages/CommanderProduits.dart';
// import 'package:votre_app/widgets/rounded_purple_container.dart';
// import 'package:votre_app/widgets/bottom_nav_bar.dart'; 

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedIndex = 0; // Index par défaut (Accueil)

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      
      // En-tête (Widget Réutilisable)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Container(
          height: 100,
          decoration: const BoxDecoration(
            color: _kPrimaryPurple,
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
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Détails du produit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
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
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image du Produit
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'assets/images/karite.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20.0),

            // 2. Titre et Prix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Beurre de karité',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 28),
              ],
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Prix : 1000 FCFA',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 20.0),

            // 3. Description
            Row(
              children: const [
                Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Le beurre de karité est une matière grasse naturelle extraite des noix de l\'arbre de karité, originaire d\'Afrique de l\'Ouest.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20.0),

            // 4. Vendeuse
            Row(
              children: const [
                Text('Vendeuse', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 10.0),
            
            // Carte Vendeuse
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150/5E2B97/FFFFFF?text=F'), // Placeholder profil
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Fatou Cissé', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey, size: 14),
                            Text('Koutiala', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, color: _kPrimaryPurple),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // 5. Bouton "Acheter maintenant"
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Action pour passer à l'écran de commande
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrderScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text('Acheter maintenant', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20.0), // Espace pour la barre de navigation
          ],
        ),
      ),

      // Barre de navigation (Widget Réutilisable)
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}