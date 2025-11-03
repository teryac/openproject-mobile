class User {
  final int id;
  final String name;
  final String? firstName;
  final String? email;

  const User({
    required this.id,
    required this.name,
    required this.firstName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      // `firstName` in the API is nullable, while `name` is never null
      name: json['name'] as String,
      firstName: json['firstName'] as String?,
      // `email` isn't ensured to have a value in the API
      email: json['email'] as String?,
    );
  }
}
