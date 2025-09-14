
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;

  User({required this.id, required this.name, required this.email, this.phone});

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: (j['id'] ?? j['user_id'] ?? '').toString(),
        name: j['name'] ?? j['full_name'] ?? '',
        email: j['email'] ?? '',
        phone: j['phone'] ?? j['phone_number'] ?? j['tel'] ?? null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
      };
}
