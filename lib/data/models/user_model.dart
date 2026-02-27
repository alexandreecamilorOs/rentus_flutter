class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? photoUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.photoUrl,
  });
}

class RegisterData {
  final String name;
  final String email;
  final String phone;
  final String idDocument;
  final String address;
  final String password;

  RegisterData({
    required this.name,
    required this.email,
    required this.phone,
    required this.idDocument,
    required this.address,
    required this.password,
  });
}
