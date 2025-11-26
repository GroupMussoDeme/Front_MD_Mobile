import 'package:flutter/material.dart';
import 'package:musso_deme_app/pages/product_publish_screen.dart';
import 'package:musso_deme_app/pages/MesProduits.dart';
import 'package:musso_deme_app/pages/MesCommandes.dart';
import 'package:musso_deme_app/pages/MesVentes.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/ProductDetailsScreen.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';

import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

const Color primaryPurple = Color(0xFF5A1489);
const Color cardBackground = Colors.white;
const Color textColor = Colors.black;

const Color primaryViolet = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;

class RuralMarketScreen extends StatefulWidget {
  const RuralMarketScreen({super.key});

  @override
  State<RuralMarketScreen> createState() => _RuralMarketScreenState();
}

class _RuralMarketScreenState extends State<RuralMarketScreen> {
  int _selectedIndex = 0;

  late Future<List<Produit>> _futureProduits;

  @override
  void initState() {
    super.initState();
    _futureProduits = _loadProduits();
  }

  Future<FemmeRuraleApi> _buildApi() async {
    final token = await SessionService.getAccessToken();
    final userId = await SessionService.getUserId();

    if (token == null || token.isEmpty || userId == null) {
      throw Exception('Session expirée ou utilisateur non connecté');
    }

    return FemmeRuraleApi(
      baseUrl: AuthService.baseUrl,
      token: token,
      femmeId: userId,
    );
  }

  Future<List<Produit>> _loadProduits() async {
    final api = await _buildApi();
    return api.getTousLesProduits();
  }

  void _refreshProduits() {
    setState(() {
      _futureProduits = _loadProduits();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        navigateToHome(context);
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: [
          // Header violet arrondi
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
                        icon: const Icon(
                          Icons.notifications_none,
                          color: neutralWhite,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenu
          Positioned.fill(
            top: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildMarketHeader(),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                  const SizedBox(height: 30),

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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: FutureBuilder<List<Produit>>(
                      future: _futureProduits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Erreur chargement produits : ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        final produits = snapshot.data ?? [];
                        if (produits.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                                'Aucun produit disponible pour le moment'),
                          );
                        }

                        return Wrap(
                          spacing: 15.0,
                          runSpacing: 15.0,
                          children: produits
                              .map(
                                (p) => MarketProductCard(
                                  produit: p,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailsScreen(produit: p),
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildMarketHeader() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marché rural',
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
              aspectRatio: 16 / 9,
              child: Image.asset(
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
                MaterialPageRoute(
                  builder: (context) => const ProductsScreen(),
                ),
              );
            },
          ),
          _ActionButton(
            icon: Icons.mic_none,
            label: 'Publier',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductPublishScreen(),
                ),
              );
              _refreshProduits();
            },
          ),
          _ActionButton(
            icon: Icons.shopping_cart_outlined,
            label: 'Mes commandes',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MesCommandesScreen(),
                ),
              );
            },
          ),
          _ActionButton(
            icon: Icons.shopping_bag_outlined,
            label: 'Mes ventes',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MySalesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
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
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
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

/// Carte produit pour le marché
class MarketProductCard extends StatelessWidget {
  final Produit produit;
  final VoidCallback onTap;

  const MarketProductCard({
    super.key,
    required this.produit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double cardWidth = (MediaQuery.of(context).size.width - 45) / 2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: _buildProductImage(cardWidth),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: const BoxDecoration(
                color: primaryPurple,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produit.nom,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix : ${produit.prix?.toStringAsFixed(0) ?? '-'} FCFA',
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
      ),
    );
  }

  Widget _buildProductImage(double width) {
    final img = produit.image;
    if (img != null && img.isNotEmpty) {
      final url =
          img.startsWith('http') ? img : 'http://10.0.2.2:8080/uploads/$img';

      return Image.network(
        url,
        height: 120,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(width),
      );
    }
    return _placeholder(width);
  }

  Widget _placeholder(double width) {
    return Container(
      height: 120,
      width: width,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
    );
  }
}
