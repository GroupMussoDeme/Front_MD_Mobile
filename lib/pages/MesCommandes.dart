import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';

// Définition des couleurs
const Color primaryPurple = Color(0xFF491B6D);
const Color backgroundColor = Color(0xFFF0F0F0);
const Color cardColor = Colors.white;
const Color textColor = Colors.black87;
const Color neutralWhite = Colors.white;

// Modèle de données pour une commande
class Order {
  final String imageUrl;
  final String productName;
  final String price;
  final String date;
  final String status; // En cours, Livrée, Annulée
  final String seller;

  Order({
    required this.imageUrl,
    required this.productName,
    required this.price,
    required this.date,
    required this.status,
    required this.seller,
  });
}

class MesCommandesScreen extends StatefulWidget {
  const MesCommandesScreen({super.key});

  @override
  State<MesCommandesScreen> createState() => _MesCommandesScreenState();
}

class _MesCommandesScreenState extends State<MesCommandesScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Liste de commandes factices
  final List<Order> _orders = [
    Order(
      imageUrl: 'assets/images/beurredecarrite.png',
      productName: 'Beurre de karité',
      price: '1000 FCFA',
      date: '26/10/2025',
      status: 'En cours',
      seller: 'Aminata Traoré',
    ),
    Order(
      imageUrl: 'assets/images/pagne.png',
      productName: 'Pagne tissé',
      price: '6000 FCFA',
      date: '25/10/2025',
      status: 'Livrée',
      seller: 'Fatoumata Diarra',
    ),
    Order(
      imageUrl: 'assets/images/beurredecarrite.png',
      productName: 'Soumbala',
      price: '600 FCFA',
      date: '20/10/2025',
      status: 'Annulée',
      seller: 'Mariam Coulibaly',
    ),
  ];

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return OrderCard(order: order);
                },
              ),
            ),
          ),
        ],
      ),

      // Barre de navigation avec BottomNavBar widget
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

/// Widget représentant une carte de commande
class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color _getStatusColor() {
    switch (order.status) {
      case 'En cours':
        return Colors.orange;
      case 'Livrée':
        return Colors.green;
      case 'Annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
                // Image du produit
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    order.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 40),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Vendeur: ${order.seller}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Prix : ${order.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Date: ${order.date}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge de statut
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(), width: 1.5),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: _getStatusColor(),
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
                // Bouton Audio
                _buildActionButton(
                  icon: Icons.volume_up,
                  label: '',
                  color: Colors.transparent,
                  textColor: primaryPurple,
                  isOutline: true,
                  onPressed: () {
                    print('Audio pour ${order.productName}');
                  },
                ),
                // Bouton Détails
                _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Détails',
                  color: primaryPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    print('Détails de ${order.productName}');
                  },
                ),
                // Bouton Contacter
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Contacter',
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    print('Contacter ${order.seller}');
                  },
                ),
              ],
            ),
          ],
        ),
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
          icon: Icon(icon, color: isOutline ? textColor : Colors.white, size: 20),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            elevation: isOutline ? 0 : 2,
          ),
        ),
      ),
    );
  }
}
