class User{
   int? id_usuario;
   String? name;
   String? dni;
   String? password;
   String? email;

  User({
    required this.id_usuario,
    required this.name,
    required this.dni,
    required this.password,
    required this.email
  });
  Map<String, Object?> toMap(){
    return {
      'id_usuario': id_usuario,
      'name': name,
      'dni': dni,
      'password': password,
      'email': email
    };
  }
  // Convert a Note into a Map. The keys must correspond to the names of the
  // columns in the database.
  User.fromJson(Map<String, dynamic> map) {
    id_usuario: map['id_usuario'];
    name: map['name'];
    dni: map['dni'];
    password: map['password'];
    email: map['email'];
  }

// Method to convert a 'NoteModel' to a map
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': id_usuario,
      'name': name,
      'dni': dni,
      'password': password,
      'email': email
    };
  }

  @override
  String toString() {
    return 'User{id_usuario: $id_usuario, name: $name, dni: $dni, password: $password, email: $email}';
  }
}