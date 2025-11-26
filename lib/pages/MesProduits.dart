import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/widgets/RoundedPurpleContainer.dart';

import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/pages/product_publish_screen.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Color(0xFFF0F0F0);
const Color _kCardColor = Colors.white;
const Color _kTextColor = Colors.black87;
const Color _kButtonPurple = Color(0xFF5E2B97);
const Color _kButtonRed = Color(0xFFE57373);

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int _selectedIndex = 0;
  late Future<List<Produit>> _futureProduits;

  @override
  void initState() {
    super.initState();
    _futureProduits = _loadMesProduits();
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

  Future<List<Produit>> _loadMesProduits() async {
    final api = await _buildApi();
    return api.getMesProduits();
  }

  void _refresh() {
    setState(() {
      _futureProduits = _loadMesProduits();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation éventuelle (accueil, formations, profil) si souhaité
  }

  Future<void> _supprimerProduit(Produit produit) async {
    final api = await _buildApi();

    if (produit.id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le produit'),
        content: Text('Voulez-vous vraiment supprimer "${produit.nom}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await api.supprimerProduit(produitId: produit.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit supprimé avec succès')),
      );
      _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur suppression : $e')),
      );
    }
  }

  Future<void> _modifierProduit(Produit produit) async {
    final result = await Navigator.push<Produit?>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductPublishScreen(existingProduct: produit),
      ),
    );
    if (result != null && mounted) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Produit>>(
          future: _futureProduits,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erreur chargement produits : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final produits = snapshot.data ?? [];
            if (produits.isEmpty) {
              return const Center(
                child: Text('Vous n’avez pas encore publié de produits.'),
              );
            }

            return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final product = produits[index];
                return ProductCard(
                  product: product,
                  onEdit: () => _modifierProduit(product),
                  onDelete: () => _supprimerProduit(product),
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Produit product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: _buildProductImage(),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.nom,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _kTextColor,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Prix : ${product.prix?.toStringAsFixed(0) ?? '-'} FCFA',
                        style: const TextStyle(
                          fontSize: 16,
                          color: _kTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Stock : ${product.quantite ?? 0}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
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
                _buildActionButton(
                  icon: Icons.volume_up,
                  label: '',
                  color: Colors.transparent,
                  textColor: _kPrimaryPurple,
                  isOutline: true,
                  onPressed: () {
                    // TODO : lecture audio du guide si disponible
                  },
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Modifier',
                  color: _kButtonPurple,
                  textColor: Colors.white,
                  onPressed: onEdit,
                ),
                _buildActionButton(
                  icon: Icons.delete,
                  label: 'Supprimer',
                  color: _kButtonRed,
                  textColor: Colors.white,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final img = product.image;
    if (img != null && img.isNotEmpty) {
      final url =
          img.startsWith('http') ? img : 'http://10.0.2.2:8080/uploads/$img';

      return Image.network(
        url,
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_outlined,
        color: Colors.grey,
        size: 40,
      ),
    );
  }

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
          icon: Icon(
            icon,
            color: isOutline ? textColor : Colors.white,
            size: 20,
          ),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: isOutline ? 0 : 2,
          ),
        ),
      ),
    );
  }
}
