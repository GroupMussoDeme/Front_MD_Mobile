import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/widgets/RoundedPurpleContainer.dart';

import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

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

  late Future<List<Commande>> _futureVentes;

  @override
  void initState() {
    super.initState();
    _futureVentes = _loadVentes();
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

  Future<List<Commande>> _loadVentes() async {
    final api = await _buildApi();
    final userId = await SessionService.getUserId();

    // Si tu ajoutes un endpoint dédié côté backend :
    // return api.getMesVentes();

    // Fallback : on récupère les commandes et on filtre localement
    final toutesCommandes = await api.getMesCommandes();

    if (userId == null) return [];

    // On considère "vente" = commande dont le produit appartient à la femme
    return toutesCommandes
        .where((c) => c.produit?.femmeRuraleId == userId)
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigation éventuelle si nécessaire
  }

  String _buildQuantiteLabel(Commande commande) {
    return '${commande.quantite} vendu';
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
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: ventes.length,
              itemBuilder: (context, index) {
                final commande = ventes[index];
                final produit = commande.produit;
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
  final Produit? produit;
  final String quantiteLabel;

  const SalesItemCard({
    super.key,
    required this.produit,
    required this.quantiteLabel,
  });

  @override
  Widget build(BuildContext context) {
    final nom = produit?.nom ?? 'Produit inconnu';

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
              nom,
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
    if (img != null && img.isNotEmpty) {
      final url =
          img.startsWith('http') ? img : 'http://10.0.2.2:8080/uploads/$img';

      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
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
