class Contenu {
  final int id;
  final String titre;
  final String? description;
  final String urlContenu;
  final String? duree;
  final String typeInfo;
  final String typeCategorie;
  final int? adminId;

  Contenu({
    required this.id,
    required this.titre,
    required this.urlContenu,
    required this.typeInfo,
    required this.typeCategorie,
    this.description,
    this.duree,
    this.adminId,
  });

  factory Contenu.fromJson(Map<String, dynamic> json) {
    return Contenu(
      id: json['id'] as int,
      titre: json['titre'] ?? '',
      description: json['description'],
      urlContenu: json['urlContenu'] ?? '',
      duree: json['duree'],
      typeInfo: json['typeInfo'] ?? '',
      typeCategorie: json['typeCategorie'] ?? '',
      adminId: json['adminId'],
    );
  }
}
