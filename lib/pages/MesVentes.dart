import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/widgets/RoundedPurpleContainer.dart';

// --- COULEURS ET CONSTANTES ---
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Color(0xFFF0F0F0);
const Color _kCardColor = Colors.white;
const Color _kTextColor = Colors.black87;

// --- MODÈLE DE DONNÉES ---
class SaleItem {
  final String imageUrl;
  final String name;
  final String quantitySold; // Ex: '40 Kg vendu'

  SaleItem({required this.imageUrl, required this.name, required this.quantitySold});
}

// --- WIDGET PRINCIPAL : ÉCRAN MES VENTES ---
class MySalesScreen extends StatefulWidget {
  const MySalesScreen({super.key});

  @override
  State<MySalesScreen> createState() => _MySalesScreenState();
}

class _MySalesScreenState extends State<MySalesScreen> {
  int _selectedIndex = 1; // L'icône centrale (Formation) est sélectionnée par défaut

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print('Navigation vers l\'index: $index');
  }

  // Liste des articles vendus factices
  final List<SaleItem> _sales = [
    SaleItem(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Soumbala',
      quantitySold: '40 Kg vendu',
    ),
    SaleItem(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Savons',
      quantitySold: '400 M vendu',
    ),
    SaleItem(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Karité',
      quantitySold: '30 Kg vendu',
    ),
    SaleItem(
      imageUrl: 'assets/images/beurredecarrite.png',
      name: 'Légumes',
      quantitySold: '100 Kg vendu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // L'AppBar avec le conteneur violet arrondi (Widget Réutilisable)
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
                  'Mes ventes',
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

      // Corps de l'écran avec la grille des ventes
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colonnes comme dans le design
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // Ajustement léger pour mieux coller au design
          ),
          itemCount: _sales.length,
          itemBuilder: (context, index) {
            final item = _sales[index];
            return SalesItemCard(item: item);
          },
        ),
      ),

      // La barre de navigation inférieure personnalisée (Widget Réutilisable)
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// --- WIDGET DE LA CARTE D'ARTICLE VENDU (RÉUTILISABLE) ---
class SalesItemCard extends StatelessWidget {
  final SaleItem item;

  const SalesItemCard({super.key, required this.item});

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
            // Image de l'article
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.image, size: 50));
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            // Nom de l'article
            Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _kTextColor,
              ),
            ),
            const SizedBox(height: 4.0),
            // Quantité vendue
            Text(
              item.quantitySold,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _kPrimaryPurple, // Mis en violet pour accentuer la donnée
              ),
            ),
            const SizedBox(height: 8.0),
            // Icône Haut-parleur
            Center(
              child: Icon(
                Icons.volume_up,
                color: _kPrimaryPurple,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}