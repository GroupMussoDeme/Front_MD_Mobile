class ContentModel {
  final int id;
  final String titre;
  final String langue;
  final String description;
  final String urlContenu;
  final String duree;
  final int adminId;
  final int categorieId;

  ContentModel({
    required this.id,
    required this.titre,
    required this.langue,
    required this.description,
    required this.urlContenu,
    required this.duree,
    required this.adminId,
    required this.categorieId,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      langue: json['langue'] ?? '',
      description: json['description'] ?? '',
      urlContenu: json['urlContenu'] ?? '',
      duree: json['duree'] ?? '',
      adminId: json['adminId'] ?? 0,
      categorieId: json['categorieId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'langue': langue,
      'description': description,
      'urlContenu': urlContenu,
      'duree': duree,
      'adminId': adminId,
      'categorieId': categorieId,
    };
  }
}