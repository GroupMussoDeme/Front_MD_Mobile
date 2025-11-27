import 'package:flutter/material.dart';
import 'package:musso_deme_app/widgets/BottomNavBar.dart';
import 'package:musso_deme_app/models/marche_models.dart';
import 'package:musso_deme_app/pages/OrderValidationScreen.dart';

import 'package:musso_deme_app/services/femme_rurale_api.dart';
import 'package:musso_deme_app/services/auth_service.dart';
import 'package:musso_deme_app/services/session_service.dart';

// Couleurs
const Color _kPrimaryPurple = Color(0xFF5E2B97);
const Color _kBackgroundColor = Colors.white;

// Modèle de données pour les options de paiement
enum PaymentOption { orangeMoney, moovMoney, cashOnDelivery }

class PaymentMethodScreen extends StatefulWidget {
  final Produit produit;
  final int quantity;
  final int deliveryFee;

  const PaymentMethodScreen({
    super.key,
    required this.produit,
    required this.quantity,
    required this.deliveryFee,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  PaymentOption? _selectedOption = PaymentOption.orangeMoney;
  int _selectedIndex = 0;
  bool _isLoading = false;

  // Calculs basés sur les paramètres reçus
  int get _price => widget.produit.prix?.toInt() ?? 0;
  int get _subtotal => _price * widget.quantity;
  int get _deliveryFee => widget.deliveryFee;
  int get _total => _subtotal + _deliveryFee;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  String _mapPaymentOptionToBackend(PaymentOption option) {
    switch (option) {
      case PaymentOption.orangeMoney:
        return 'ORANGE_MONEY';
      case PaymentOption.moovMoney:
        return 'MOOV_MONEY';
      case PaymentOption.cashOnDelivery:
        return 'ESPECE'; // paiement en espèces à la livraison
    }
  }

  Future<void> _confirmOrder() async {
    final stock = widget.produit.quantite ?? 999999;
    if (widget.quantity > stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stock insuffisant. Disponible : $stock, demandé : ${widget.quantity}',
          ),
        ),
      );
      return;
    }

    if (widget.produit.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit invalide (id manquant).')),
      );
      return;
    }

    final selected = _selectedOption;
    if (selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez choisir un mode de paiement.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1) Récupérer token + userId de la session
      final token = await SessionService.getAccessToken();
      final userId = await SessionService.getUserId();

      if (token == null || userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expirée. Veuillez vous reconnecter.'),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }

      // 2) Instancier l’API femme rurale
      final api = FemmeRuraleApi(
        baseUrl: AuthService.baseUrl,
        token: token,
        femmeId: userId,
      );

      // 3) Créer la commande
      final commande = await api.passerCommande(
        produitId: widget.produit.id!,
        quantite: widget.quantity,
      );

      // 4) Créer le paiement (sauf si tu veux faire un flux différent
      //    pour "Paiement après livraison")
      final modeString = _mapPaymentOptionToBackend(selected);

      final paiement = await api.payerCommande(
        commandeId: commande.id!,
        montant: _total.toDouble(),
        modePaiement: modeString,
      );

      // 5) Aller sur l’écran de validation avec les vraies données
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrderValidationScreen(commande: commande, paiement: paiement),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la commande : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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

  Widget _buildPaymentTile({
    required Widget leading,
    required String title,
    required PaymentOption option,
  }) {
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre section paiement
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

            // Options de paiement
            _buildPaymentTile(
              leading: Image.asset(
                'assets/images/Orange_logo.svg 2.png',
                width: 40,
                height: 40,
              ),
              title: 'Orange Money',
              option: PaymentOption.orangeMoney,
            ),
            _buildPaymentTile(
              leading: Image.asset(
                'assets/images/payment-methods-moov-money.f34903fd 1.png',
                width: 40,
                height: 40,
              ),
              title: 'Moov Money',
              option: PaymentOption.moovMoney,
            ),
            _buildPaymentTile(
              leading: const SizedBox(width: 40, height: 40),
              title: 'Paiement après livraison',
              option: PaymentOption.cashOnDelivery,
            ),

            const SizedBox(height: 30.0),

            // Localisation
            Row(
              children: const [
                Text(
                  'Localisation',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.volume_up, color: _kPrimaryPurple, size: 24),
              ],
            ),
            const SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Votre adresse de livraison',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black54),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 10.0,
                ),
              ),
            ),

            const SizedBox(height: 30.0),

            // Confirmation de commande
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

            // Bouton Confirmer
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Confirmer', style: TextStyle(fontSize: 18)),
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
