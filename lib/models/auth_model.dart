class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool isBibliotecario;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isBibliotecario,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      isBibliotecario: json['is_bibliotecario'] ?? false,
    );
  }

  String get nomeExibicao => 
      firstName.isNotEmpty ? '$firstName $lastName'.trim() : username;
}

class AuthResponseModel {
  final String access;
  final String refresh;
  final UserModel user;

  AuthResponseModel({
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
      user: UserModel.fromJson(json),
    );
  }
}