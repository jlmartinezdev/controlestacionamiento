class Entrada {
   int? id;
   String? fechahora;
   int? id_usuario;
   double? monto;

  Entrada ({
    required this.id,
    required this.fechahora,
    required this.id_usuario,
    required this.monto
  });

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'id_usuario': id_usuario,
      'monto': monto
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_usuario': id_usuario,
      'monto': monto,
    };
  }
  Entrada.map(dynamic obj) {
    id = obj['id'];
    id_usuario = obj['id_usuario'];
    fechahora= obj['fechahora'];
    monto = obj['monto'];
  }
  @override
  String toString() {
    return 'Entrada{id: $id, fechahora: $fechahora,  id_usuario: $id_usuario, monto: $monto}';
  }
}
