class User {
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String? role;
  final String? token;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
    this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['userId'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      role: json['role'],
      token: json['token'],
    );
  }

  // Ajoutez cette méthode
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'username': username,
      'email': email,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (token != null) 'token': token,
    };
  }
}