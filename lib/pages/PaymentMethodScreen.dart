import 'package:flutter/material.dart';
import 'package:musso_deme_app/wingets/BottomNavBar.dart';
import 'package:musso_deme_app/wingets/RoundedPurpleContainer.dart';
// import 'package:votre_app/widgets/rounded_purple_container.dart';
// import 'package:votre_app/widgets/bottom_nav_bar.dart'; 

const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

// Modèle de données pour les options de paiement
enum PaymentOption {
  orangeMoney,
  moovMoney,
  cashOnDelivery,
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentOption? _selectedOption = PaymentOption.orangeMoney;
  final int _subtotal = 1000;
  final int _deliveryFee = 1000;
  final int _total = 2000;
  int _selectedIndex = 0; // Index par défaut (Accueil)

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // Helper pour construire les lignes de prix
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 22 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 22 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Helper pour le conteneur de chaque méthode de paiement
  Widget _buildPaymentTile({
    required Widget leading,
    required String title,
    required PaymentOption option,
  }) {
    // Style de la bordure si l'option est sélectionnée
    final isSelected = _selectedOption == option;
    final borderColor = isSelected ? _kPrimaryPurple : Colors.black12;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 15.0),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            // Bouton radio personnalisé
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? _kPrimaryPurple : Colors.white,
                border: Border.all(
                  color: isSelected ? _kPrimaryPurple : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.circle, color: Colors.white, size: 10)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackgroundColor,

      // En-tête (Widget Réutilisable)
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
                      'Méthode de paiement',
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Titre de la section de paiement ---
            Row(
              children: [
                Text(
                  'Methode de paiement',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 28),
              ],
            ),
            const SizedBox(height: 20.0),

            // --- Options de paiement ---
            _buildPaymentTile(
              leading: Image.network(
                'https://via.placeholder.com/40x40/FF7C00/FFFFFF?text=Orange', // Placeholder Orange Money
                width: 40,
                height: 40,
              ),
              title: 'Orange Money',
              option: PaymentOption.orangeMoney,
            ),
            _buildPaymentTile(
              leading: Image.network(
                'https://via.placeholder.com/40x40/1E90FF/FFFFFF?text=Moov', // Placeholder Moov Money
                width: 40,
                height: 40,
              ),
              title: 'Moov Money',
              option: PaymentOption.moovMoney,
            ),
            _buildPaymentTile(
              leading: const SizedBox(width: 40, height: 40), // Espace pour l'alignement
              title: 'Paiement après livraison',
              option: PaymentOption.cashOnDelivery,
            ),
            
            const SizedBox(height: 30.0),

            // --- Section Localisation ---
            Row(
              children: [
                const Text(
                  'Localisation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Votre adresse de livraison',
                prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black54),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
            ),
            
            const SizedBox(height: 30.0),

            // --- Confirmation de commande ---
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirmation de commande',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  _buildPriceRow('Sous-total :', '$_subtotal FCFA'),
                  _buildPriceRow('Livraison :', '$_deliveryFee FCFA'),
                  const Divider(height: 20, thickness: 1.0),
                  _buildPriceRow('Total', '$_total FCFA', isTotal: true),
                ],
              ),
            ),
            
            const SizedBox(height: 30.0),

            // --- Bouton Confirmer ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text('Confirmer', style: TextStyle(fontSize: 18)),
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