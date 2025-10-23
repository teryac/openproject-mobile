class User {
  final String firstName;
  final String avatar;
  final String? email;

  const User({
    required this.firstName,
    required this.avatar,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // `firstName` in the API is nullable, while `name` is
      // never null
      firstName: (json['firstName'] as String?) ??
          // Choose first word from `name` (Display name)
          (json['name'] as String).split(' ').first,
      // `avatar` is never null in the API
      avatar: json['avatar'] as String,
      // `email` isn't ensured to have a value in the API
      email: json['email'] as String?
    );
  }
}
