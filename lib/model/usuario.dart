class Usuario {
  final String id, nombre, cargo;

  Usuario({this.nombre, this.cargo, this.id});

  factory Usuario.fromList(List data) =>
      Usuario(id: data[0], nombre: data[1], cargo: data[2]);
}
