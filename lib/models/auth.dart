class LoginRequest {
  final String telephone;
  final String motcle;

  LoginRequest({
    required this.telephone,
    required this.motcle, 
  });

  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'motcle': motcle,
    };
  }
}

class AuthResponse {
  final String token;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}

// Importez le modèle User
class User {
  final int id;
  final String email;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}