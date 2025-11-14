import 'package:flutter/material.dart';

// Définissez vos couleurs principales pour la réutilisation
const Color primaryPurple = Color(0xFF5A1489); // Couleur violette dominante (conserve les couleurs existantes)
const Color cardBackground = Colors.white; // Couleur de fond des cartes
const Color textColor = Colors.black;

// Couleurs partagées (utilisées par FinancialAidScreen style)
const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color lightGrey = Color(0xFFF0F0F0);
const Color darkGrey = Color(0xFF707070);

class RuralMarketScreen extends StatelessWidget {
  const RuralMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryViolet,
        elevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: neutralWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Marchés',
          style: TextStyle(color: neutralWhite, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: neutralWhite),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Espace pour la photo du marché
            _buildMarketHeader(),
            const SizedBox(height: 20),
            // Les boutons d'action
            _buildActionButtons(),
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
      // La barre de navigation inférieure (style FinancialAidScreen)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: primaryViolet,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage), // Icône Base de Données/Formation
              label: 'Formation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: neutralWhite,
          unselectedItemColor: neutralWhite.withOpacity(0.6),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {},
        ),
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

Widget _buildActionButtons() {
  // Crée la ligne de quatre boutons sous l'image
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _ActionButton(icon: Icons.shopping_bag_outlined, label: 'Produits'),
        _ActionButton(icon: Icons.mic_none, label: 'Publier'),
        _ActionButton(icon: Icons.shopping_cart_outlined, label: 'Mes commandes'),
        _ActionButton(icon: Icons.shopping_bag_outlined, label: 'Mes ventes'),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
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