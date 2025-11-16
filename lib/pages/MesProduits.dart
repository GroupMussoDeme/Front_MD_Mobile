import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
// Assurez-vous d'importer vos widgets réutilisables ici
// import 'package:votre_app/widgets/rounded_purple_container.dart';
// import 'package:votre_app/widgets/bottom_nav_bar.dart';

// Définition des couleurs (assurez-vous qu'elles sont cohérentes avec vos widgets réutilisables)
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Color(0xFFF0F0F0); // Couleur de fond légèrement grise
const Color _kCardColor = Colors.white;
const Color _kTextColor = Colors.black87;
const Color _kButtonPurple = Color(0xFF5E2B97); // Couleur du bouton modifier
const Color _kButtonRed = Color(0xFFE57373); // Couleur du bouton supprimer

// Modèle de données pour un produit
class Product {
  final String imageUrl;
  final String name;
  final String price;

  Product({required this.imageUrl, required this.name, required this.price});
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int _selectedIndex = 0; // Pour la barre de navigation

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Logique de navigation ici (ex: Navigator.push, changer le corps de l'écran)
    print('Navigation vers l\'index: $index');
  }

  // Liste de produits factices pour l'affichage
  final List<Product> _products = [
    Product(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Beurre de karité',
      price: '1000 FCFA',
    ),
    Product(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Pagne tissé',
      price: '6000 FCFA',
    ),
    Product(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Soumbala',
      price: '600 FCFA',
    ),
    // Ajoutez d'autres produits ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor, // Couleur de fond globale

      // L'AppBar avec le conteneur violet arrondi
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Hauteur de l'AppBar
        child: AppBar(
          automaticallyImplyLeading: false, // Cache le bouton retour par défaut
          backgroundColor: Colors.transparent, // Rendre l'AppBar transparente
          elevation: 0, // Enlever l'ombre de l'AppBar
          flexibleSpace: const RoundedPurpleContainer(
              height: 100.0), // Votre widget réutilisable
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0), // Ajustez le padding si nécessaire
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // Retour à l'écran précédent
                  },
                ),
                const Text(
                  'Mes produits',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.white),
                  onPressed: () {
                    // Action pour les notifications
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            return ProductCard(product: product);
          },
        ),
      ),

      // La barre de navigation inférieure personnalisée
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

/// Widget représentant une carte de produit individuelle
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: _kCardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image du produit
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    product.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _kTextColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Prix : ${product.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: _kTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0, thickness: 1.0, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Bouton Son (icône de haut-parleur)
                _buildActionButton(
                  icon: Icons.volume_up,
                  label: '', // Pas de texte, juste l'icône
                  color: Colors.transparent, // Fond transparent
                  textColor: _kPrimaryPurple, // Couleur de l'icône
                  isOutline: true, // Pour un effet de contour si désiré
                  onPressed: () {
                    print('Son pour ${product.name}');
                  },
                ),
                // Bouton Modifier
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Modifier',
                  color: _kButtonPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    print('Modifier ${product.name}');
                  },
                ),
                // Bouton Supprimer
                _buildActionButton(
                  icon: Icons.delete,
                  label: 'Supprimer',
                  color: _kButtonRed,
                  textColor: Colors.white,
                  onPressed: () {
                    print('Supprimer ${product.name}');
                    // Ici, vous devrez implémenter la logique pour supprimer le produit de la liste
                    // et reconstruire l'interface utilisateur.
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper pour construire les boutons d'action
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
    bool isOutline = false,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, color: isOutline ? textColor : Colors.white, size: 20),
          label: Text(
            label,
            style: TextStyle(
              color: isOutline ? textColor : Colors.white,
              fontSize: 13,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: isOutline
                  ? BorderSide(color: textColor, width: 1.5)
                  : BorderSide.none,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: isOutline ? 0 : 2, // Pas d'ombre pour le bouton contour
          ),
        ),
      ),
    );
  }
}

// Pour le bouton volume, il était légèrement différent, donc je le sépare
Widget _buildSpeakerButton({required VoidCallback onPressed}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell( // Utilisez InkWell pour un effet de ripple sur un conteneur personnalisé
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: _kPrimaryPurple, width: 1.5), // Contour violet
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volume_up, color: _kPrimaryPurple, size: 20),
            ],
          ),
        ),
      ),
    ),
  );
}