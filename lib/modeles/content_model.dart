class ContentModel {
  final int id;
  final String titre;
  final String langue;
  final String description;
  final String urlContenu;
  final String duree;
  final int adminId;
  final int categorieId;
  final String? type;
  final DateTime? createdAt;

  ContentModel({
    required this.id,
    required this.titre,
    required this.langue,
    required this.description,
    required this.urlContenu,
    required this.duree,
    required this.adminId,
    required this.categorieId,
    this.type,
    this.createdAt,
  });

  // Getter for title (alias of titre)
  String get title => titre;

  // Getter for duration (convert duree to int)
  int get duration {
    return int.tryParse(duree) ?? 0;
  }

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
      type: json['type'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  // toJson method for API requests (without server-generated fields)
  Map<String, dynamic> toJsonForApi() {
    return {
      'titre': titre,
      'langue': langue,
      'description': description,
      'urlContenu': urlContenu,
      'duree': duree,
      'adminId': adminId,
      'categorieId': categorieId,
    };
  }

  // Complete toJson method (for local storage or other uses)
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
      if (type != null) 'type': type,
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
    };
  }
}