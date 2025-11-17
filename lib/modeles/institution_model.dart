class InstitutionModel {
  final int id;
  final String nom;
  final String numeroTel;
  final String description;
  final String logoUrl;

  InstitutionModel({
    required this.id,
    required this.nom,
    required this.numeroTel,
    required this.description,
    required this.logoUrl,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      numeroTel: json['numeroTel'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'numeroTel': numeroTel,
      'description': description,
      'logoUrl': logoUrl,
    };
  }
}