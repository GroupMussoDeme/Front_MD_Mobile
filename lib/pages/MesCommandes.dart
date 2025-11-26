import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

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

  late Future<List<Commande>> _futureCommandes;

  @override
  void initState() {
    super.initState();
    _futureCommandes = _loadCommandes();
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

  Future<List<Commande>> _loadCommandes() async {
    final api = await _buildApi();
    return api.getMesCommandes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d/$m/$y';
  }

  String _statusLabel(String? rawStatus) {
    if (rawStatus == null) return '-';
    switch (rawStatus.toUpperCase()) {
      case 'EN_COURS':
        return 'En cours';
      case 'EN_ATTENTE':
        return 'En attente';
      case 'LIVREE':
      case 'LIVRE':
        return 'Livrée';
      case 'ANNULEE':
      case 'ANNULE':
        return 'Annulée';
      default:
        return rawStatus;
    }
  }

  Color _statusColor(String? rawStatus) {
    if (rawStatus == null) return Colors.grey;
    switch (rawStatus.toUpperCase()) {
      case 'EN_COURS':
      case 'EN_ATTENTE':
        return Colors.orange;
      case 'LIVREE':
      case 'LIVRE':
        return Colors.green;
      case 'ANNULEE':
      case 'ANNULE':
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
          // Header violet
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

          // Contenu
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
                      final produit = commande.produit;
                      final produitNom = produit?.nom ?? 'Produit inconnu';

                      final statusLabel =
                          _statusLabel(commande.statutCommande);
                      final statusColor =
                          _statusColor(commande.statutCommande);
                      final dateFormatted = _formatDate(commande.dateAchat);

                      // On s’appuie sur vendeuseNom de Commande
                      final vendeur =
                          commande.vendeuseNom ?? 'Vendeuse inconnue';

                      final montant =
                          (commande.montantTotal?.toStringAsFixed(0) ?? '-') +
                              ' FCFA';

                      return CommandeCard(
                        produit: produit,
                        produitNom: produitNom,
                        vendeur: vendeur,
                        montant: montant,
                        statusLabel: statusLabel,
                        statusColor: statusColor,
                        dateFormatted: dateFormatted,
                        quantite: commande.quantite,
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

class CommandeCard extends StatelessWidget {
  final Produit? produit;
  final String produitNom;
  final String vendeur;
  final String montant;
  final String statusLabel;
  final Color statusColor;
  final String dateFormatted;
  final int quantite;

  const CommandeCard({
    super.key,
    required this.produit,
    required this.produitNom,
    required this.vendeur,
    required this.montant,
    required this.statusLabel,
    required this.statusColor,
    required this.dateFormatted,
    required this.quantite,
  });

  @override
  Widget build(BuildContext context) {
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
                        produitNom,
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
                        'Quantité : $quantite',
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
                    // TODO : lecture audio si nécessaire
                  },
                ),
                _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Détails',
                  color: primaryPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO : détails de la commande
                  },
                ),
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Contacter',
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    // TODO : contact de la vendeuse
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
    if (img != null && img.isNotEmpty) {
      final url =
          img.startsWith('http') ? img : 'http://10.0.2.2:8080/uploads/$img';

      return ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(
          url,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: _placeholder(),
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
