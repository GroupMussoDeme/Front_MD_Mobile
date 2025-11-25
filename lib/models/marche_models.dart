class Produit {
  final int? id;
  final String nom;
  final String? description;
  final String? image;        // nom du fichier ou URL
  final int? quantite;
  final double? prix;
  final String? typeProduit;  // ALIMENTAIRE, ARTISANAT, ...

  // Optionnel : id de la femme rurale
  final int? femmeRuraleId;

  Produit({
    this.id,
    required this.nom,
    this.description,
    this.image,
    this.quantite,
    this.prix,
    this.typeProduit,
    this.femmeRuraleId,
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'] as int?,
      nom: json['nom'] ?? '',
      description: json['description'] as String?,
      image: json['image'] as String?,
      quantite: json['quantite'] as int?,
      prix: (json['prix'] as num?)?.toDouble(),
      typeProduit: json['typeProduit'] as String?,
      femmeRuraleId: json['femmeRuraleId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'image': image,
      'quantite': quantite,
      'prix': prix,
      'typeProduit': typeProduit,
      'femmeRuraleId': femmeRuraleId,
    };
  }
}


class Commande {
  final int id;
  final int quantite;
  final String? statutCommande;    // EN_COURS, LIVREE, ANNULEE...
  final DateTime dateAchat;
  final int acheteurId;
  final int produitId;
  final int? paiementId;
  final double? montantTotal;

  // >>> NOUVEAU : produit complet renvoyé par le backend
  final Produit? produit;

  // optionnel : nom de la vendeuse si tu l’ajoutes côté backend
  final String? vendeuseNom;

  Commande({
    required this.id,
    required this.quantite,
    this.statutCommande,
    required this.dateAchat,
    required this.acheteurId,
    required this.produitId,
    this.paiementId,
    this.montantTotal,
    this.produit,
    this.vendeuseNom,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    return Commande(
      id: json['id'] as int,
      quantite: json['quantite'] as int,
      statutCommande: json['statutCommande'] as String?,
      dateAchat: DateTime.parse(json['dateAchat'] as String),
      acheteurId: json['acheteurId'] as int,
      produitId: json['produitId'] as int,
      paiementId: json['paiementId'] as int?,
      montantTotal: (json['montantTotal'] as num?)?.toDouble(),

      // ici on parse l’objet produit si le backend l’envoie
      produit: json['produit'] != null
          ? Produit.fromJson(json['produit'] as Map<String, dynamic>)
          : null,

      // si tu ajoutes ce champ dans ton DTO / JSON
      vendeuseNom: json['vendeuseNom'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'statutCommande': statutCommande,
      'dateAchat': dateAchat.toIso8601String(),
      'acheteurId': acheteurId,
      'produitId': produitId,
      'paiementId': paiementId,
      'montantTotal': montantTotal,
      'produit': produit?.toJson(),
      'vendeuseNom': vendeuseNom,
    };
  }
}

class Paiement {
  final int? id;
  final DateTime? datePaiement;
  final String? modePaiement; // ORANGE_MONEY / MOOV_MONEY / ESPECE ...
  final double? montant;
  final int? acheteurId;

  Paiement({
    this.id,
    this.datePaiement,
    this.modePaiement,
    this.montant,
    this.acheteurId,
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'] as int?,
      datePaiement: json['datePaiement'] != null
          ? DateTime.parse(json['datePaiement'] as String)
          : null,
      modePaiement: json['modePaiement'] as String?,
      montant: json['montant'] != null
          ? (json['montant'] as num).toDouble()
          : null,
      acheteurId: json['acheteurId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'datePaiement': datePaiement?.toIso8601String(),
      'modePaiement': modePaiement,
      'montant': montant,
      'acheteurId': acheteurId,
    };
  }
}