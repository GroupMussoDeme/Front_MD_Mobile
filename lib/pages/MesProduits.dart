import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/widgets/RoundedPurpleContainer.dart';

import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/pages/product_publish_screen.dart';

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
  final FemmeRuraleApi _api = FemmeRuraleApi();
  late Future<List<Produit>> _futureMesProduits;

  @override
  void initState() {
    super.initState();
    _loadMesProduits();
  }

  void _loadMesProduits() {
    _futureMesProduits = _api.getMesProduits();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _editProduct(Produit produit) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPublishScreen(existingProduct: produit),
      ),
    );

    if (result != null) {
      setState(_loadMesProduits);
    }
  }

  Future<void> _deleteProduct(Produit produit) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer le produit'),
        content:
            Text('Voulez-vous vraiment supprimer "${produit.nom}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.supprimerProduit(produit.id!);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit supprimé avec succès')),
      );
      setState(_loadMesProduits);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur suppression : $e')),
      );
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
                  icon:
                      const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
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
          future: _futureMesProduits,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erreur chargement de mes produits : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final produits = snapshot.data ?? [];
            if (produits.isEmpty) {
              return const Center(
                child: Text('Vous n’avez encore publié aucun produit.'),
              );
            }

            return ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final product = produits[index];
                return ProductCard(
                  product: product,
                  onEdit: () => _editProduct(product),
                  onDelete: () => _deleteProduct(product),
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
                _buildProductImage(),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildProductInfo(),
                ),
              ],
            ),
            const Divider(
                height: 24.0, thickness: 1.0, color: Colors.grey),
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
                    // Lecture audio si tu implémentes audioGuideUrl
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
    Widget child;

    if (img != null && img.isNotEmpty) {
      if (img.startsWith('http://') || img.startsWith('https://')) {
        child = Image.network(
          img,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      } else {
        final fullUrl = 'http://10.0.2.2:8080/uploads/$img';
        child = Image.network(
          fullUrl,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      }
    } else {
      child = _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: child,
    );
  }

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_outlined,
        color: Colors.grey,
        size: 32,
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
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
        const SizedBox(height: 8.0),
        if (product.description != null &&
            product.description!.isNotEmpty)
          Text(
            product.description!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
      ],
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
