class User {
  final int id;
  final String name;
  final String telephone;
  final String motcle;

  User({
    required this.id,
    required this.name,
    required this.telephone,
    required this.motcle,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      telephone: json['telephone'] ?? '',
      motcle: json['motcle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'telephone': telephone,
      'motcle': motcle,
    };
  }
}