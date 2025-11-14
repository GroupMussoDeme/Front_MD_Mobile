import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/product_publish_screen.dart';
import 'package:musso_deme_app/pages/MesProduits.dart';
import 'package:musso_deme_app/pages/MesCommandes.dart';
import 'package:musso_deme_app/pages/MesVentes.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';

// Définissez vos couleurs principales pour la réutilisation
const Color primaryPurple = Color(0xFF5A1489); // Couleur violette dominante (conserve les couleurs existantes)
const Color cardBackground = Colors.white; // Couleur de fond des cartes
const Color textColor = Colors.black;

// Couleurs partagées (utilisées par FinancialAidScreen style)
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkGrey = Color(0xFF707070);

class RuralMarketScreen extends StatefulWidget {
  const RuralMarketScreen({super.key});

  @override
  State<RuralMarketScreen> createState() => _RuralMarketScreenState();
}

class _RuralMarketScreenState extends State<RuralMarketScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Ajouter la navigation vers les pages correspondantes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          // Conteneur violet arrondi en haut
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: primaryViolet,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: neutralWhite),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Text(
                          'Marchés',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: neutralWhite),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Contenu scrollable
          Positioned.fill(
            top: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Espace pour la photo du marché
                  _buildMarketHeader(),
                  const SizedBox(height: 20),
                  // Les boutons d'action
                  _buildActionButtons(context),
                  const SizedBox(height: 30),
                  // Titre "Produits disponibles"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Produits disponibles',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Liste des produits (utilisez un GridView.builder ou un Row/Wrap)
                  _buildProductGrid(context),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      // Utilisation du widget BottomNavBar
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
  // ... (définition des autres fonctions helper ci-dessous)
}

// Dans la classe RuralMarketScreen...

Widget _buildMarketHeader() {
  // Cette section est le conteneur de l'image du marché rural
  return Container(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Marché rurale',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: AspectRatio(
            aspectRatio: 16 / 9, // Format d'image typique
            child: Image.asset(
              // REMPLACER par le chemin de votre image
              'assets/images/rural_market_header.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButtons(BuildContext context) {
  // Crée la ligne de quatre boutons sous l'image
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _ActionButton(
          icon: Icons.shopping_bag_outlined,
          label: 'Produits',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductsScreen()),
            );
          },
        ),
        _ActionButton(
          icon: Icons.mic_none,
          label: 'Publier',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductPublishScreen()),
            );
          },
        ),
        _ActionButton(
          icon: Icons.shopping_cart_outlined,
          label: 'Mes commandes',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MesCommandesScreen()),
            );
          },
        ),
        _ActionButton(
          icon: Icons.shopping_bag_outlined,
          label: 'Mes ventes',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MySalesScreen()),
            );
          },
        ),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80, // Largeur fixe pour les boutons
            height: 50, // Hauteur fixe pour les boutons
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Couleur de fond légèrement grise
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              icon,
              color: primaryPurple,
              size: 30,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Dans la classe RuralMarketScreen...

Widget _buildProductGrid(BuildContext context) {
  // Utilisez un Wrap ou un GridView pour les cartes de produits
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Wrap(
      spacing: 15.0, // Espace horizontal entre les cartes
      runSpacing: 15.0, // Espace vertical entre les lignes
      children: <Widget>[
        // Exemple de carte de produit 1
        ProductCard(
          imagePath: 'assets/images/beurredecarrite.png', // REMPLACER par le chemin de votre image
          name: 'Beurre de karite',
          price: '1000 FCFA',
        ),
        // Exemple de carte de produit 2
        ProductCard(
          imagePath: 'assets/images/pagne.png', // REMPLACER par le chemin de votre image
          name: 'Pagne tissé',
          price: '6000 FCFA',
        ),
        // Ajoutez d'autres ProductCard si nécessaire
      ],
    ),
  );
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  const ProductCard({super.key, 
    required this.imagePath,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    // La taille du widget est approximée pour afficher deux cartes par ligne.
    final double cardWidth = (MediaQuery.of(context).size.width - 45) / 2;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image du produit
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: cardWidth,
              fit: BoxFit.cover,
            ),
          ),
          // Bouton "Acheter"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: const BoxDecoration(
              color: primaryPurple,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Acheter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Nom et prix du produit
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prix : $price',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(
                      Icons.volume_up_outlined,
                      color: primaryPurple,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// (Bottom navigation and helper widgets removed because RuralMarketScreen now
// uses the FinancialAidScreen-style AppBar and bottom navigation directly.)