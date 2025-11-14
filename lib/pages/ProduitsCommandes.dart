import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';

// --- COULEURS ET CONSTANTES ---
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Color(0xFFF0F0F0);
const Color _kCardColor = Colors.white;
const Color _kTextColor = Colors.black87;

// --- MODÈLE DE DONNÉES ---
class OrderedProduct {
  final String imageUrl;
  final String name;
  final String quantity;

  OrderedProduct({required this.imageUrl, required this.name, required this.quantity});
}

// --- WIDGET PRINCIPAL : ÉCRAN DES PRODUITS COMMANDÉS ---
class OrderedProductsScreen extends StatefulWidget {
  const OrderedProductsScreen({super.key});

  @override
  State<OrderedProductsScreen> createState() => _OrderedProductsScreenState();
}

class _OrderedProductsScreenState extends State<OrderedProductsScreen> {
  int _selectedIndex = 1; // L'icône centrale (Base de données/Formation) est sélectionnée par défaut

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Navigation vers l\'index: $index');
  }

  // Liste de produits commandés factices
  final List<OrderedProduct> _orderedProducts = [
    OrderedProduct(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Soumbala',
      quantity: '20Kg',
    ),
    OrderedProduct(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Beurre de karité',
      quantity: '50Kg',
    ),
    OrderedProduct(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Pagne tissé',
      quantity: '', // La quantité est vide pour l'exemple
    ),
    OrderedProduct(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Gourde traditionnelle',
      quantity: '',
    ),
    // Ajoutez d'autres produits ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // L'AppBar avec le conteneur violet arrondi (Widget Réutilisable 1)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Utilisation du RoundedPurpleContainer
          flexibleSpace: const RoundedPurpleContainer(height: 100.0), 
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
                  'Produits commandés',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
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

      // Corps de l'écran avec la grille des produits
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colonnes comme dans le design
            crossAxisSpacing: 16.0, // Espacement horizontal
            mainAxisSpacing: 16.0, // Espacement vertical
            childAspectRatio: 0.75, // Ajustez pour l'aspect de la carte
          ),
          itemCount: _orderedProducts.length,
          itemBuilder: (context, index) {
            final product = _orderedProducts[index];
            return OrderedProductCard(product: product);
          },
        ),
      ),

      // La barre de navigation inférieure personnalisée (Widget Réutilisable 2)
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// --- WIDGET DE LA CARTE DE PRODUIT COMMANDÉ (RÉUTILISABLE) ---
class OrderedProductCard extends StatelessWidget {
  final OrderedProduct product;

  const OrderedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _kCardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image du produit
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.image, size: 50));
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Nom du produit + Quantité
            Text(
              '${product.name} ${product.quantity}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _kTextColor,
              ),
            ),
            const SizedBox(height: 4.0),
            // Texte "commander par"
            const Text(
              'commander par',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8.0),
            // Icônes (Profil et Haut-parleur)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: _kPrimaryPurple,
                  size: 20,
                ),
                const SizedBox(width: 20.0),
                Icon(
                  Icons.volume_up,
                  color: _kPrimaryPurple,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}