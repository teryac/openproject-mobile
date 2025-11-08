class User {
  final int id;
  final String name;

  const User({required this.id, required this.name});

  /// Creates a User from the JSON map inside the `_links` object.
  /// e.g., "author": { "href": "/api/v3/users/4", "title": "Yaman Kalaji" }
  factory User.fromJson(Map<String, dynamic> json) {
    final href = json['href'] as String;
    // Extracts the ID from the end of the 'href' string.
    final id = int.parse(href.split('/').last);

    return User(
      id: id,
      name: json['title'] as String,
    );
  }

  /// Converts the User to a JSON map compatible with the API `_links` format.
  Map<String, dynamic> toJson() {
    return {
      'href': '/api/v3/users/$id',
      'title': name,
    };
  }
}
