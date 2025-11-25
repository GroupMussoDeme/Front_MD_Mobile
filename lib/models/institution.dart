class InstitutionFinanciere {
  final int id;
  final String nom;
  final String numeroTel;
  final String description;
  final String logoUrl;
  final double? montantMin;
  final double? montantMax;
  final String? secteurActivite;
  final String? tauxInteret;

  InstitutionFinanciere({
    required this.id,
    required this.nom,
    required this.numeroTel,
    required this.description,
    required this.logoUrl,
    this.montantMin,
    this.montantMax,
    this.secteurActivite,
    this.tauxInteret,
  });

  factory InstitutionFinanciere.fromJson(Map<String, dynamic> json) {
    return InstitutionFinanciere(
      id: json['id'] as int,
      nom: (json['nom'] ?? '') as String,
      numeroTel: (json['numeroTel'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      // TRÈS IMPORTANT : correspond exactement à ton DTO Java (getLogoUrl)
      logoUrl: (json['logoUrl'] ?? '') as String,
      montantMin: json['montantMin'] != null
          ? (json['montantMin'] as num).toDouble()
          : null,
      montantMax: json['montantMax'] != null
          ? (json['montantMax'] as num).toDouble()
          : null,
      secteurActivite: json['secteurActivite'] as String?,
      tauxInteret: json['tauxInteret'] as String?,
    );
  }
}
