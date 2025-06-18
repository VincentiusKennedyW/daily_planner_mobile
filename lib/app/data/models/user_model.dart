class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final String? nip;
  final String? nik;
  final String? phone;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.nip,
    this.nik,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      nip: json['nip'],
      nik: json['nik'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'nip': nip,
      'nik': nik,
      'phone': phone,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? nip,
    String? nik,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      nip: nip ?? this.nip,
      nik: nik ?? this.nik,
      phone: phone ?? this.phone,
    );
  }
}

class UserResponse {
  final int id;
  final String name;

  UserResponse({
    required this.id,
    required this.name,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
