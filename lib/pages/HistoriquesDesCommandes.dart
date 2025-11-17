import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
// import 'package:votre_app/widgets/rounded_purple_container.dart';
// import 'package:votre_app/widgets/bottom_nav_bar.dart'; 

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

// Modèle de données pour une commande
class OrderItem {
  final String imageUrl;
  final String name;
  final String total;
  final String status;
  final Color statusColor;

  OrderItem({
    required this.imageUrl,
    required this.name,
    required this.total,
    required this.status,
    required this.statusColor,
  });
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  final List<OrderItem> _orders = [
    OrderItem(
      imageUrl: 'https://via.placeholder.com/150/FFD700/000000?text=Beurre',
      name: 'Beurre de karité',
      total: '5000 FCFA',
      status: 'Livré',
      statusColor: Colors.green,
    ),
    OrderItem(
      imageUrl: 'https://via.placeholder.com/150/FFA07A/000000?text=Pagne',
      name: 'Pagne tissé',
      total: '7000 FCFA',
      status: 'En cours',
      statusColor: Colors.orange,
    ),
    OrderItem(
      imageUrl: 'https://via.placeholder.com/150/FFD700/000000?text=Beurre',
      name: 'Beurre de karité',
      total: '5000 FCFA',
      status: 'Livré',
      statusColor: Colors.green,
    ),
    OrderItem(
      imageUrl: 'https://via.placeholder.com/150/FFA07A/000000?text=Pagne',
      name: 'Pagne tissé',
      total: '7000 FCFA',
      status: 'Annulé',
      statusColor: Colors.red,
    ),
    OrderItem(
      imageUrl: 'https://via.placeholder.com/150/8B4513/FFFFFF?text=Poulet',
      name: 'Poulet',
      total: '7000 FCFA',
      status: 'Livré',
      statusColor: Colors.green,
    ),
  ];

  // Widget pour un élément d'historique
  Widget _buildOrderTile(OrderItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5.0),
                  Text('Total : ${item.total}', style: const TextStyle(color: Colors.black87)),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const Text('Commande : ', style: TextStyle(color: Colors.black87)),
                      Text(
                        item.status,
                        style: TextStyle(fontWeight: FontWeight.bold, color: item.statusColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,
      
      // En-tête
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: const Placeholder(fallbackHeight: 100, color: _kPrimaryPurple), // Remplacer par RoundedPurpleContainer
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
                  'Historiques de commandes',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historiques de commandes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return _buildOrderTile(_orders[index]);
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}