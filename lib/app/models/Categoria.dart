class Categoria {
  final int id;
  final String name;
  final double precio;

  Categoria({
    required this.id,
    required this.name,
    required this.precio,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'precio': precio,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'precio': precio,
    };
  }


  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Categoria{id: $id, name: $name, precio: $precio}';
  }
}