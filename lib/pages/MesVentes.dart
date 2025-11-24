import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/widgets/RoundedPurpleContainer.dart';

// API / modèles
import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';

// Couleurs
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Color(0xFFF0F0F0);
const Color _kCardColor = Colors.white;
const Color _kTextColor = Colors.black87;

class MySalesScreen extends StatefulWidget {
  const MySalesScreen({super.key});

  @override
  State<MySalesScreen> createState() => _MySalesScreenState();
}

class _MySalesScreenState extends State<MySalesScreen> {
  int _selectedIndex = 1;

  final FemmeRuraleApi _api = FemmeRuraleApi();
  late Future<List<Commande>> _futureVentes;

  @override
  void initState() {
    super.initState();
    _loadVentes();
  }

  void _loadVentes() {
    _futureVentes = _api.getMesVentes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Éventuellement navigation si tu veux
  }

  String _buildQuantiteLabel(Commande commande) {
    // Tu pourras spécialiser par type produit (Kg, M, etc.) si nécessaire
    return '${commande.quantite} vendu(s)';
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
        child: FutureBuilder<List<Commande>>(
          future: _futureVentes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erreur chargement ventes : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final ventes = snapshot.data ?? [];
            if (ventes.isEmpty) {
              return const Center(
                child: Text('Vous n’avez pas encore de ventes.'),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: ventes.length,
              itemBuilder: (context, index) {
                final commande = ventes[index];
                final produit = commande.produit; // peut être null
                final quantiteLabel = _buildQuantiteLabel(commande);

                return SalesItemCard(
                  produit: produit,
                  quantiteLabel: quantiteLabel,
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

class SalesItemCard extends StatelessWidget {
  final Produit? produit;        // nullable
  final String quantiteLabel;

  const SalesItemCard({
    super.key,
    required this.produit,
    required this.quantiteLabel,
  });

  @override
  Widget build(BuildContext context) {
    final productName = produit?.nom ?? 'Produit inconnu';

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
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: _buildProductImage(),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              productName,
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
            Text(
              quantiteLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _kPrimaryPurple,
              ),
            ),
            const SizedBox(height: 8.0),
            const Center(
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

  Widget _buildProductImage() {
    final img = produit?.image;
    Widget child;

    if (img != null && img.isNotEmpty) {
      if (img.startsWith('http://') || img.startsWith('https://')) {
        child = Image.network(
          img,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      } else {
        final fullUrl = 'http://10.0.2.2:8080/uploads/$img';
        child = Image.network(
          fullUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      }
    } else {
      child = _placeholder();
    }

    return child;
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.image_outlined,
        color: Colors.grey,
        size: 50,
      ),
    );
  }
}
