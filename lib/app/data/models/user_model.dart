class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? externalId;
  final int? isNew;
  final String? emailVerifiedAt;
  final String? kontak;
  final String? signFile;
  final String? fotoFile;
  final int? status;
  final String? expiredDate;
  final String? departmentName;
  final String? divisionName;
  final String? teamName;
  final String? role;
  final String? fcmToken;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.externalId,
    this.isNew,
    this.emailVerifiedAt,
    this.kontak,
    this.signFile,
    this.fotoFile,
    this.status,
    this.expiredDate,
    this.departmentName,
    this.divisionName,
    this.teamName,
    this.role,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      externalId: json['externalId'],
      isNew: json['isNew'],
      emailVerifiedAt: json['emailVerifiedAt'],
      kontak: json['kontak'],
      signFile: json['signFile'],
      fotoFile: json['fotoFile'],
      status: json['status'],
      expiredDate: json['expiredDate'],
      departmentName: json['departmentName'],
      divisionName: json['divisionName'],
      teamName: json['teamName'],
      role: json['role'],
      fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'externalId': externalId,
      'isNew': isNew,
      'emailVerifiedAt': emailVerifiedAt,
      'kontak': kontak,
      'signFile': signFile,
      'fotoFile': fotoFile,
      'status': status,
      'expiredDate': expiredDate,
      'departmentName': departmentName,
      'divisionName': divisionName,
      'teamName': teamName,
      'role': role,
      'fcmToken': fcmToken,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? externalId,
    int? isNew,
    String? emailVerifiedAt,
    String? kontak,
    String? signFile,
    String? fotoFile,
    int? status,
    String? expiredDate,
    String? departmentName,
    String? divisionName,
    String? teamName,
    String? role,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      externalId: externalId ?? this.externalId,
      isNew: isNew ?? this.isNew,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      kontak: kontak ?? this.kontak,
      signFile: signFile ?? this.signFile,
      fotoFile: fotoFile ?? this.fotoFile,
      status: status ?? this.status,
      expiredDate: expiredDate ?? this.expiredDate,
      departmentName: departmentName ?? this.departmentName,
      divisionName: divisionName ?? this.divisionName,
      teamName: teamName ?? this.teamName,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}

class UserWithName {
  final int id;
  final String name;

  UserWithName({
    required this.id,
    required this.name,
  });

  factory UserWithName.fromJson(Map<String, dynamic> json) {
    return UserWithName(
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

class UserWithEmail {
  final int id;
  final String name;
  final String email;

  UserWithEmail({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserWithEmail.fromJson(Map<String, dynamic> json) {
    return UserWithEmail(
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
