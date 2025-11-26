class Produit {
  final int? id;
  final String nom;
  final String? description;
  final String? image;
  final int? quantite;
  final double? prix;
  final String? typeProduit;
  final String? audioGuideUrl;

  // 🆕 ajoute ça :
  final int? femmeRuraleId;

  Produit({
    this.id,
    required this.nom,
    this.description,
    this.image,
    this.quantite,
    this.prix,
    this.typeProduit,
    this.audioGuideUrl,
    this.femmeRuraleId, // 🆕
  });

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: json['id'] as int?,
      nom: json['nom'] as String? ?? '',
      description: json['description'] as String?,
      image: json['image'] as String?,
      quantite: json['quantite'] as int?,
      prix: (json['prix'] as num?)?.toDouble(),
      typeProduit: json['typeProduit'] as String?,
      audioGuideUrl: json['audioGuideUrl'] as String?,
      // 🆕 doit matcher ProduitDTO.getFemmeRuraleId()
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
      'audioGuideUrl': audioGuideUrl,
      'femmeRuraleId': femmeRuraleId, // 🆕
    };
  }
}

class Commande {
  final int? id;
  final int quantite;
  /// Statut : "EN_ATTENTE", "EN_COURS", "LIVRE", "ANNULE"
  final String? statutCommande;
  final DateTime? dateAchat;
  final Produit? produit;

  /// Infos vendeuse (femme rurale qui a publié le produit)
  final int? vendeuseId;
  final String? vendeuseNom;

  /// Montant total = prix * quantite
  final double? montantTotal;

  Commande({
    this.id,
    required this.quantite,
    this.statutCommande,
    this.dateAchat,
    this.produit,
    this.vendeuseId,
    this.vendeuseNom,
    this.montantTotal,
  });

  factory Commande.fromJson(Map<String, dynamic> json) {
    final produitJson = json['produit'] as Map<String, dynamic>?;
    final produit = produitJson != null ? Produit.fromJson(produitJson) : null;

    // nom de la vendeuse (backend : vendeuseNom)
    final vendeuseNom =
        json['vendeuseNom'] as String? ?? json['vendeurNom'] as String?;

    // id vendeuse si présent
    final vendeuseId = json['vendeuseId'] as int?;

    double? montant =
        (json['montantTotal'] as num?)?.toDouble(); // si déjà calculé par backend

    // Si montantTotal non fourni, calcule localement
    if (montant == null && produit != null && produit.prix != null) {
      final qte = json['quantite'] as int? ?? 0;
      montant = produit.prix! * qte;
    }

    return Commande(
      id: json['id'] as int?,
      quantite: json['quantite'] as int? ?? 0,
      statutCommande: json['statutCommande'] as String?,
      dateAchat: json['dateAchat'] != null
          ? DateTime.tryParse(json['dateAchat'] as String)
          : null,
      produit: produit,
      vendeuseId: vendeuseId,
      vendeuseNom: vendeuseNom,
      montantTotal: montant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantite': quantite,
      'statutCommande': statutCommande,
      'dateAchat': dateAchat?.toIso8601String(),
      'produit': produit?.toJson(),
      'vendeuseId': vendeuseId,
      'vendeuseNom': vendeuseNom,
      'montantTotal': montantTotal,
    };
  }
}



/// Représente un paiement d’une commande
class Paiement {
  final int? id;
  final DateTime? datePaiement;
  /// Mode de paiement : "ORANGE_MONEY", "MOOV_MONEY", "ESPECE", etc.
  final String? modePaiement;
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
          ? DateTime.tryParse(json['datePaiement'] as String)
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
