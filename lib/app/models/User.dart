class User{
   int? id_usuario;
   String? name;
   String? dni;
   String? password;
   String? email;
   int? rol;

  User({
    required this.id_usuario,
    required this.name,
    required this.dni,
    required this.password,
    required this.email,
    this.rol
  });
  Map<String, Object?> toMap(){
    return {
      'id_usuario': id_usuario,
      'name': name,
      'dni': dni,
      'password': password,
      'email': email,
      'rol': rol
    };
  }
   User.map(dynamic obj) {
     id_usuario = obj['id_usuario'];
     name = obj['name'];
     dni  = obj['dni'];
     password = obj['password'];
     email = obj['email'];
     rol = obj['rol'];
   }


// Method to convert a 'NoteModel' to a map
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': id_usuario,
      'name': name,
      'dni': dni,
      'password': password,
      'email': email,
      'rol': rol
    };
  }

  @override
  String toString() {
    return 'User{id_usuario: $id_usuario, name: $name, dni: $dni, password: $password, email: $email, rol: $rol}';
  }
}