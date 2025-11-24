// lib/services/institution.dart
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
    double? toDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return InstitutionFinanciere(
      id: json['id'] as int,
      nom: json['nom'] as String? ?? '',
      numeroTel: json['numeroTel'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      montantMin: toDouble(json['montantMin']),
      montantMax: toDouble(json['montantMax']),
      secteurActivite: json['secteurActivite'] as String?,
      tauxInteret: json['tauxInteret'] as String?,
    );
  }
}
