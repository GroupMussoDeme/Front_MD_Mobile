import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/CommanderProduits.dart';
import 'package:musso_deme_app/models/marche_models.dart';

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

class ProductDetailsScreen extends StatefulWidget {
  final Produit produit;

  const ProductDetailsScreen({super.key, required this.produit});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final produit = widget.produit;

    return Scaffold(
      backgroundColor: _kBackgroundColor,

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
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white),
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
            // Image dynamique depuis backend
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: _buildProductImage(produit),
            ),
            const SizedBox(height: 20.0),

            // Nom + icône son
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    produit.nom,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ),
                const Icon(Icons.volume_up,
                    color: _kPrimaryPurple, size: 28),
              ],
            ),
            const SizedBox(height: 5.0),

            // Prix + icône son
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prix : ${produit.prix?.toStringAsFixed(0) ?? '-'} FCFA',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.volume_up,
                    color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 20.0),

            // Description
            Row(
              children: const [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              produit.description ??
                  'Aucune description fournie pour ce produit.',
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 20.0),

            // Vendeuse (pour l’instant statique – pourra être branché plus tard sur l’API)
            Row(
              children: const [
                Text(
                  'Vendeuse',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 10.0),
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
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150/5E2B97/FFFFFF?text=V',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vendeuse',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.grey, size: 14),
                            Text('Localité inconnue',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: _kPrimaryPurple),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Bouton Acheter maintenant
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderScreen(produit: widget.produit),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Acheter maintenant',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildProductImage(Produit produit) {
    final img = produit.image;
    Widget child;

    if (img != null && img.isNotEmpty) {
      if (img.startsWith('http://') || img.startsWith('https://')) {
        child = Image.network(
          img,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderImage(),
        );
      } else {
        final fullUrl = 'http://10.0.2.2:8080/uploads/$img';
        child = Image.network(
          fullUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderImage(),
        );
      }
    } else {
      child = _placeholderImage();
    }

    return SizedBox(
      width: double.infinity,
      height: 220,
      child: child,
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: double.infinity,
      height: 220,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_outlined,
        color: Colors.grey,
        size: 60,
      ),
    );
  }
}
