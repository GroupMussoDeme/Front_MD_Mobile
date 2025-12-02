class Produit {
  final int? id;
  final String nom;
  final String? description;
  final String? image;
  final int? quantite;
  final double? prix;
  final String? typeProduit;
  final String? audioGuideUrl;
  final int? femmeRuraleId;

  /// ✅ nouvelle propriété
  final String? unite; // ex. "kg", "L", "sachet"

  Produit({
    this.id,
    required this.nom,
    this.description,
    this.image,
    this.quantite,
    this.prix,
    this.typeProduit,
    this.audioGuideUrl,
    this.femmeRuraleId,
    this.unite, // ✅
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
      femmeRuraleId: json['femmeRuraleId'] as int?,
      unite: json['unite'] as String?, // ✅ doit matcher ProduitDTO.unite
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
      'femmeRuraleId': femmeRuraleId,
      'unite': unite, // ✅
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

class Cooperative {
  final int? id;
  final String nom;
  final String? description;
  final int nbrMembres;
  final List<Appartenance>? appartenances;

  Cooperative({
    this.id,
    required this.nom,
    this.description,
    required this.nbrMembres,
    this.appartenances,
  });

  factory Cooperative.fromJson(Map<String, dynamic> json) {
    final List<Appartenance>? appartenances;
    if (json['appartenances'] != null) {
      final list = json['appartenances'] as List<dynamic>;
      appartenances = list
          .map((e) => Appartenance.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      appartenances = null;
    }

    return Cooperative(
      id: json['id'] as int?,
      nom: json['nom'] as String? ?? '',
      description: json['description'] as String?,
      nbrMembres: json['nbrMembres'] as int? ?? 0,
      appartenances: appartenances,
    );
  }
}

class Appartenance {
  final int? id;
  final String? dateIntegration; // on garde String, tu peux parser en DateTime ensuite si besoin
  final int? coperativeId;
  final int? femmeRuraleId;

  Appartenance({
    this.id,
    this.dateIntegration,
    this.coperativeId,
    this.femmeRuraleId,
  });

  factory Appartenance.fromJson(Map<String, dynamic> json) {
    return Appartenance(
      id: json['id'] as int?,
      dateIntegration: json['dateIntegration'] as String?,
      coperativeId: json['coperativeId'] as int?,     // même orthographe que le DTO Java
      femmeRuraleId: json['femmeRuraleId'] as int?,
    );
  }
}

class ChatVocal {
  final int? id;
  final int? expediteurId;
  final String? expediteurNom;
  final String? expediteurPrenom;
  final String? texte;
  final String? audioUrl;
  final String? fichierUrl;
  final String? dateEnvoi;
  final String? duree;

  ChatVocal({
    this.id,
    this.expediteurId,
    this.expediteurNom,
    this.expediteurPrenom,
    this.texte,
    this.audioUrl,
    this.fichierUrl, 
    this.dateEnvoi,
    this.duree,
  });

  factory ChatVocal.fromJson(Map<String, dynamic> json) {
    return ChatVocal(
      id: json['id'] as int?,
      expediteurId: json['expediteurId'] as int?,
      expediteurNom: json['expediteurNom'] as String?,
      expediteurPrenom: json['expediteurPrenom'] as String?,
      texte: json['texte'] as String?,
      audioUrl: json['audioUrl'] as String?,
      fichierUrl: json['fichierUrl'] as String?,
      dateEnvoi: json['dateEnvoi'] as String?,
      duree: json['duree'] as String?,
    );
  }
}


class FemmeRurale {
  final int id;
  final String nom;
  final String prenom;

  FemmeRurale({
    required this.id,
    required this.nom,
    required this.prenom,
  });

  String get nomComplet => '$prenom $nom';

  factory FemmeRurale.fromJson(Map<String, dynamic> json) {
    return FemmeRurale(
      id: json['id'] as int,
      nom: json['nom'] as String? ?? '',
      prenom: json['prenom'] as String? ?? '',
    );
  }
}
