import '../../core/constants/api_constants.dart';

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
  final String? bio;
  final String? department;
  final String? city;

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
    this.bio,
    this.department,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String findFirstString(Map<String, dynamic> json, List<String> keys) {
      for (final key in keys) {
        final val = json[key];
        if (val is String && val.isNotEmpty) return val;
      }
      return '';
    }

    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? json['user_email'] ?? '',
      phone: json['phone'] ?? json['phone_number'] ?? json['celular'],
      address: json['address'] ?? json['user_address'] ?? json['direccion'],
      idDocumento:
          json['id_documento'] ?? json['identification'] ?? json['document_id'],
      status: json['status'],
      verificationStatus: json['verification_status'] ?? json['verified_at'],
      role: json['role'] is Map
          ? json['role']['name']
          : json['role'] ?? json['user_role'],
      photo: ApiConstants.resolveUrl(findFirstString(json, [
        'photo',
        'profile_photo',
        'avatar',
        'image',
        'pic',
        'profilePicture',
        'profile_picture',
        'path',
      ])),
      bio: json['bio'] ?? json['biography'] ?? json['descripcion'],
      department: json['department'] ?? json['provincia'] ?? json['estado'],
      city: json['city'] ?? json['ciudad'] ?? json['municipio'],
    );
  }

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
        'bio': bio,
        'department': department,
        'city': city,
      };
}

class RegisterData {
  final String name;
  final String email;
  final String phone;
  final String idDocument;
  final String address;
  final String password;

  RegisterData(
      {required this.name,
      required this.email,
      required this.phone,
      required this.idDocument,
      required this.address,
      required this.password});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'id_documento': idDocument,
        'address': address,
        'password': password,
      };
}
