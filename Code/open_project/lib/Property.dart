class Property {
  String name;
  int id;
  var color;
  Property({required this.id, required this.name, required this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Property && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Property(id: $id, name: $name, color: $color)';
}
