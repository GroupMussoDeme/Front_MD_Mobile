import 'package:flutter/material.dart';
import 'package:musso_deme_app/models/marche_models.dart';

class OrderValidationScreen extends StatelessWidget {
  final Commande commande;
  final Paiement paiement;

  const OrderValidationScreen({
    super.key,
    required this.commande,
    required this.paiement,
  });

  @override
  Widget build(BuildContext context) {
    final produitNom = commande.produit?.nom ?? 'Produit';
    final montant = paiement.montant?.toStringAsFixed(0) ?? '-';
    final mode = paiement.modePaiement ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Commande validée'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              Text(
                'Votre commande de $produitNom a bien été enregistrée.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text('Montant : $montant FCFA'),
              Text('Mode de paiement : $mode'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
