import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/Formations.dart'; 

// --- COULEURS ET CONSTANTES ---
const Color primaryPurple = Color(0xFF491B6D);
const Color neutralWhite = Colors.white;
const Color _kBackgroundColor = Colors.white; // Le fond est blanc
const Color _kCardColor = Colors.white;
const Color _kIconColor = primaryPurple;

// --- MODÈLE DE DONNÉES (pour le bloc Details) ---
class FinanceDetail {
  final IconData icon;
  final String title;
  final String value;

  FinanceDetail({required this.icon, required this.title, required this.value});
}


class MicrocreditDetailsScreen extends StatefulWidget {
  const MicrocreditDetailsScreen({super.key});

  @override
  State<MicrocreditDetailsScreen> createState() => _MicrocreditDetailsScreenState();
}

class _MicrocreditDetailsScreenState extends State<MicrocreditDetailsScreen> {
  int _selectedIndex = 0; // Index par défaut pour l'Accueil

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // Si l'utilisateur clique sur l'icône centrale (index 1) - Formations
      if (index == 1) {
        // Naviguer vers la page Formations
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      }
    });
    print('Navigation vers l\'index: $index');
  }

  // Les données pour la carte de détails
  final List<FinanceDetail> _details = [
    FinanceDetail(
      icon: Icons.account_balance_wallet,
      title: 'Montant du financement',
      value: '10000 FCFA à 500000 FCFA',
    ),
    FinanceDetail(
      icon: Icons.apartment,
      title: 'Secteur d\'activité',
      value: 'Commerce, agricole, Artinat',
    ),
    FinanceDetail(
      icon: Icons.percent,
      title: 'Taux d\'intérêt',
      value: '2% par mois',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                      const Expanded(
                        child: Text(
                          'Détails sur le microcrédit',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: neutralWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: neutralWhite),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Section 1 : Logo et Institution ---
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryPurple.withOpacity(0.5), width: 2),
                      ),
                      child: Center(
                        // Placeholder pour le logo "Kafo Jiginew"
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 1.5),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  
                  // Titre de l'institution
                  const Text(
                    'La caisse des femmes pour le développement',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30.0),

                  // --- Section 2 : Carte des Détails du Financement ---
                  const Text(
                    'Détails du financement',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Conteneur / Carte des détails
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
                        // Liste des détails (Montant, Secteur, Taux)
                        ..._details.map((detail) => _buildDetailRow(detail)),
                        
                        const Divider(height: 30.0, thickness: 1.0, color: Colors.black12),
                        
                        // Boutons d'action (Écouter, Favori, Appeler)
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

      // 3. Barre de navigation (Widget Réutilisable 2)
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // Helper pour construire une ligne de détail
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper pour construire le bouton Écouter
  Widget _buildActionButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () => print('Action: $label'),
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

  // Helper pour construire les icônes Favori et Appeler
  Widget _buildActionIcon(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: _kIconColor, size: 28),
      onPressed: () => print('Action: ${icon == Icons.phone ? 'Appeler' : 'Favori'}'),
    );
  }
}