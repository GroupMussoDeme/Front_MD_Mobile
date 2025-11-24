import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';

// Couleurs
const Color primaryPurple = Color(0xFF491B6D);
const Color backgroundColor = Color(0xFFF0F0F0);
const Color cardColor = Colors.white;
const Color textColor = Colors.black87;
const Color neutralWhite = Colors.white;

class MesCommandesScreen extends StatefulWidget {
  const MesCommandesScreen({super.key});

  @override
  State<MesCommandesScreen> createState() => _MesCommandesScreenState();
}

class _MesCommandesScreenState extends State<MesCommandesScreen> {
  int _selectedIndex = 0;

  final FemmeRuraleApi _api = FemmeRuraleApi();
  late Future<List<Commande>> _futureCommandes;

  @override
  void initState() {
    super.initState();
    _loadCommandes();
  }

  void _loadCommandes() {
    _futureCommandes = _api.getMesCommandes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // À compléter si tu veux une navigation spécifique
    });
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  String _statusLabel(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'EN_COURS':
        return 'En cours';
      case 'LIVREE':
        return 'Livrée';
      case 'ANNULEE':
        return 'Annulée';
      default:
        return rawStatus;
    }
  }

  Color _statusColor(String rawStatus) {
    switch (rawStatus.toUpperCase()) {
      case 'EN_COURS':
        return Colors.orange;
      case 'LIVREE':
        return Colors.green;
      case 'ANNULEE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                color: primaryPurple,
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
                          'Mes commandes',
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

          // Contenu scrollable
          Positioned.fill(
            top: 100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Commande>>(
                future: _futureCommandes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erreur chargement commandes : ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final commandes = snapshot.data ?? [];
                  if (commandes.isEmpty) {
                    return const Center(
                      child: Text('Aucune commande pour le moment.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: commandes.length,
                    itemBuilder: (context, index) {
                      final commande = commandes[index];
                      final produit = commande.produit; // Peut être null
                      final statusLabel =
                          _statusLabel(commande.statutCommande ?? '');
                      final statusColor =
                          _statusColor(commande.statutCommande ?? '');

                      return CommandeCard(
                        commande: commande,
                        produit: produit,
                        statusLabel: statusLabel,
                        statusColor: statusColor,
                        dateFormatted: _formatDate(commande.dateAchat),
                      );
                    },
                  );
                },
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
}

/// Carte de commande basée sur Commande + Produit du backend
class CommandeCard extends StatelessWidget {
  final Commande commande;
  final Produit? produit;              // nullable
  final String statusLabel;
  final Color statusColor;
  final String dateFormatted;

  const CommandeCard({
    super.key,
    required this.commande,
    required this.produit,
    required this.statusLabel,
    required this.statusColor,
    required this.dateFormatted,
  });

  @override
  Widget build(BuildContext context) {
    // Fallback si produit est null
    final productName = produit?.nom ?? 'Produit inconnu';
    final vendeur = commande.vendeuseNom ?? 'Vendeuse inconnue';
    final montant =
        (commande.montantTotal?.toStringAsFixed(0) ?? '-') + ' FCFA';

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: cardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Vendeur : $vendeur',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Montant : $montant',
                        style: const TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Date : $dateFormatted',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Quantité : ${commande.quantite}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1.5),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
                  textColor: primaryPurple,
                  isOutline: true,
                  onPressed: () {
                    // TODO : lecture audio si tu ajoutes un audio pour la commande
                  },
                ),
                _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Détails',
                  color: primaryPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO : rediriger vers détail de commande si besoin
                  },
                ),
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Contacter',
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO : ouvrir écran de contact avec la vendeuse
                  },
                ),
              ],
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
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        );
      } else {
        final fullUrl = 'http://10.0.2.2:8080/uploads/$img';
        child = Image.network(
          fullUrl,
          width: 80,
          height: 80,
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
      width: 80,
      height: 80,
      color: Colors.grey[300],
      child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
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
