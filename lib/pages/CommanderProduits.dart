import 'package:flutter/material.dart';
import 'package:musso_deme_app/utils/navigation_utils.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/pages/PaymentMethodScreen.dart';
import 'package:musso_deme_app/pages/Formations.dart';
import 'package:musso_deme_app/pages/ProfileScreen.dart';
import 'package:musso_deme_app/models/marche_models.dart';

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

class OrderScreen extends StatefulWidget {
  final Produit produit;

  const OrderScreen({super.key, required this.produit});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 1;
  final int _deliveryFee = 1000;
  int _selectedIndex = 0;

  /// Stock maximum disponible pour ce produit.
  /// On considère que si quantite <= 0 ou null -> pas de stock.
  int get _maxQuantity {
    final q = widget.produit.quantite;
    if (q == null || q <= 0) return 0;
    return q;
  }

  bool get _inStock => _maxQuantity > 0;

  @override
  void initState() {
    super.initState();
    // Si pas de stock, quantité = 0, sinon on démarre à 1.
    _quantity = _inStock ? 1 : 0;
  }

  void _updateQuantity(int delta) {
    if (!_inStock) return;

    setState(() {
      _quantity = (_quantity + delta).clamp(1, _maxQuantity);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        navigateToHome(context);
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FormationVideosPage()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    });
  }

  int get _unitPrice => widget.produit.prix?.round() ?? 1000;
  int get _subtotal => _unitPrice * _quantity;
  int get _total => _subtotal + _deliveryFee;

  @override
  Widget build(BuildContext context) {
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
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                    ),
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
            const SizedBox(height: 10.0),

            // Message si rupture de stock
            if (!_inStock)
              const Text(
                'Ce produit est en rupture de stock. Impossible de passer une commande.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 20.0),
            _buildPriceRow('Sous-total :', '$_subtotal FCFA'),
            _buildPriceRow('Livraison :', '$_deliveryFee FCFA'),
            const Divider(height: 20, thickness: 2, color: Colors.black),
            _buildPriceRow('Total', '$_total FCFA', isTotal: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: !_inStock
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentMethodScreen(
                              produit: widget.produit,
                              quantity: _quantity,
                              deliveryFee: _deliveryFee,
                            ),
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
                  'Procéder au paiement',
                  style: TextStyle(fontSize: 18),
                ),
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

  Widget _buildProductCard() {
    final productName = widget.produit.nom;

    // ===== Prix unitaire + unité =====
    final unitLabel = (widget.produit.unite ?? '').trim();
    final String productPriceText = unitLabel.isEmpty
        ? '${_unitPrice.toString()} FCFA'
        : '${_unitPrice.toString()} FCFA / $unitLabel';

    final stock = widget.produit.quantite ?? 0;

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
            child: _buildProductImage(),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Prix : $productPriceText',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4.0),
                Text(
                  _inStock
                      ? 'Stock disponible : $stock'
                      : 'Stock épuisé',
                  style: TextStyle(
                    fontSize: 13,
                    color: _inStock ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    _buildQuantityButton(
                      Icons.remove,
                      () => _updateQuantity(-1),
                      enabled: _inStock && _quantity > 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildQuantityButton(
                      Icons.add,
                      () => _updateQuantity(1),
                      enabled: _inStock && _quantity < _maxQuantity,
                    ),
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

  Widget _buildProductImage() {
    final img = widget.produit.image;
    if (img != null && img.isNotEmpty) {
      final url = img.startsWith('http')
          ? img
          : 'http://10.0.2.2:8080/uploads/$img';

      return Image.network(
        url,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image_outlined, color: Colors.grey, size: 40),
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Icon(icon, color: Colors.black, size: 18),
            ),
          ),
        ),
      ),
    );
  }

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
}
