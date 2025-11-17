import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
import 'package:musso_deme_app/pages/PaymentMethodScreen.dart';
// import 'package:votre_app/widgets/rounded_purple_container.dart';
// import 'package:votre_app/widgets/bottom_nav_bar.dart'; 

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 1;
  final int _price = 1000;
  final int _deliveryFee = 1000;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _updateQuantity(int delta) {
    setState(() {
      _quantity = (_quantity + delta).clamp(1, 99); // Limiter la quantité entre 1 et 99
    });
  }

  int get _subtotal => _price * _quantity;
  int get _total => _subtotal + _deliveryFee;

  // Widget pour la carte du produit et le compteur
  Widget _buildProductCard() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/beurredecarrite.png',
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
                const Text(
                  'Beurre de karité',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Prix : $_price FCFA',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8.0),
                // Compteur de quantité
                Row(
                  children: [
                    _buildQuantityButton(Icons.remove, () => _updateQuantity(-1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    _buildQuantityButton(Icons.add, () => _updateQuantity(1)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
        ],
      ),
    );
  }

  // Helper pour les boutons de quantité
  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Icon(icon, color: Colors.black, size: 18),
        ),
      ),
    );
  }

  // Helper pour les lignes de prix
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 22 : 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 22 : 18,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
        ],
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
                      'Commande',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
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
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductCard(),
            const SizedBox(height: 30.0),

            _buildPriceRow('Sous-total :', '$_subtotal FCFA'),
            _buildPriceRow('Livraison :', '$_deliveryFee FCFA'),
            
            const Divider(height: 20, thickness: 2, color: Colors.black),
            
            _buildPriceRow('Total', '$_total FCFA', isTotal: true),
            const Spacer(),

            // Bouton "Procéder au paiement"
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text('Procéder au paiement', style: TextStyle(fontSize: 18)),
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