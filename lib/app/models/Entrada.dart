class Entrada {
  final int id;
  final String fecha;
  final String hora;
  final int id_usuario;
  final double monto;

  Entrada ({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.id_usuario,
    required this.monto
  });
  Map<String, Object?> toMap(){
    return {
      'id': id,
      'fecha': fecha,
      'hora': hora,
      'id_usuario': id_usuario,
      'monto': monto
    };
  }
  @override
  String toString() {
    return 'Entrada{id: $id, fecha: $fecha, hora: $hora, id_usuario: $id_usuario, monto: $monto}';
  }
}
