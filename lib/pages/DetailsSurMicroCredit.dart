// lib/pages/DetailsSurMicroCredit.dart
import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/models/institution.dart';
import 'package:musso_deme_app/services/institution_api_service.dart';

const Color primaryPurple = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color _kBackgroundColor = Colors.white;
const Color _kCardColor = Colors.white;
const Color _kIconColor = primaryPurple;

class FinanceDetail {
  final IconData icon;
  final String title;
  final String value;

  FinanceDetail({required this.icon, required this.title, required this.value});
}

class MicrocreditDetailsScreen extends StatefulWidget {
  final InstitutionFinanciere institution;

  const MicrocreditDetailsScreen({super.key, required this.institution});

  @override
  State<MicrocreditDetailsScreen> createState() =>
      _MicrocreditDetailsScreenState();
}

class _MicrocreditDetailsScreenState extends State<MicrocreditDetailsScreen> {
  int _selectedIndex = 0;

  late final List<FinanceDetail> _details;

  @override
  void initState() {
    super.initState();

    final inst = widget.institution;

    String montant;
    if (inst.montantMin != null && inst.montantMax != null) {
      montant =
          '${inst.montantMin!.toStringAsFixed(0)} FCFA à ${inst.montantMax!.toStringAsFixed(0)} FCFA';
    } else {
      montant = 'Montant à définir avec l’institution';
    }

    final secteur = inst.secteurActivite?.isNotEmpty == true
        ? inst.secteurActivite!
        : 'Commerce, agriculture, artisanat (à préciser)';

    final taux = inst.tauxInteret?.isNotEmpty == true
        ? inst.tauxInteret!
        : 'Taux non renseigné';

    final tel = inst.numeroTel.isNotEmpty ? inst.numeroTel : 'Non renseigné';

    _details = [
      FinanceDetail(
        icon: Icons.account_balance_wallet,
        title: 'Montant du financement',
        value: montant,
      ),
      FinanceDetail(
        icon: Icons.apartment,
        title: 'Secteur d\'activité',
        value: secteur,
      ),
      FinanceDetail(icon: Icons.percent, title: 'Taux d\'intérêt', value: taux),
      FinanceDetail(icon: Icons.phone, title: 'Téléphone', value: tel),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inst = widget.institution;

    // Gestion logo (asset ou backend)
    Widget buildLogo() {
      final inst = widget.institution;

      if (inst.logoUrl.isEmpty) {
        return const Icon(
          Icons.account_balance,
          color: primaryPurple,
          size: 50,
        );
      }

      if (inst.logoUrl.startsWith('assets/')) {
        return Image.asset(
          inst.logoUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            debugPrint('Erreur asset logo détail: ${inst.logoUrl}');
            return const Icon(
              Icons.account_balance,
              color: primaryPurple,
              size: 50,
            );
          },
        );
      }

      final fullLogoUrl = InstitutionApiService.fileUrl(inst.logoUrl);
      debugPrint(
        'DETAIL logo brut="${inst.logoUrl}" -> complet="$fullLogoUrl"',
      );

      return Image.network(
        fullLogoUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          debugPrint('Erreur network logo détail: $fullLogoUrl');
          return const Icon(
            Icons.account_balance,
            color: primaryPurple,
            size: 50,
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: _kBackgroundColor,
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
                      Expanded(
                        child: Text(
                          'Détails sur le microcrédit',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo + nom
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryPurple.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: buildLogo(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    inst.nom,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (inst.description.isNotEmpty) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      inst.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 30.0),

                  const Text(
                    'Détails du financement',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _kCardColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ..._details.map(_buildDetailRow),
                        const Divider(
                          height: 30.0,
                          thickness: 1.0,
                          color: Colors.black12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionButton(Icons.volume_up, 'Écouter'),
                            _buildActionIcon(Icons.favorite_border),
                            _buildActionIcon(Icons.phone),
                          ],
                        ),
                      ],
                    ),
                  ),
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

  Widget _buildDetailRow(FinanceDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(detail.icon, color: _kIconColor, size: 30),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  detail.value,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () => debugPrint('Action: $label'),
      icon: Icon(icon, color: _kIconColor, size: 28),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: _kIconColor, size: 28),
      onPressed: () =>
          debugPrint('Action: ${icon == Icons.phone ? 'Appeler' : 'Favori'}'),
    );
  }
}
