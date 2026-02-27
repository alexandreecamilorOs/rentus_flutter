class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? idDocumento;
  final String? status;
  final String? verificationStatus;
  final String? role;
  final String? photo;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.idDocumento,
    this.status,
    this.verificationStatus,
    this.role,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'],
        address: json['address'],
        idDocumento: json['id_documento'],
        status: json['status'],
        verificationStatus: json['verification_status'],
        role: json['role'],
        photo: json['photo'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'id_documento': idDocumento,
        'status': status,
        'verification_status': verificationStatus,
        'role': role,
        'photo': photo,
      };
}

class RegisterData {
  final String name;
  final String email;
  final String phone;
  final String idDocument;
  final String address;
  final String password;

  RegisterData({required this.name, required this.email, required this.phone, required this.idDocument, required this.address, required this.password});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'id_documento': idDocument,
        'address': address,
        'password': password,
      };
}
