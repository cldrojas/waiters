class Usuario {
  final String id, nombre, cargo;

  Usuario({this.nombre, this.cargo, this.id});

  factory Usuario.fromJson(Map data) =>
      Usuario(id: data['id'], nombre: data['nombre'], cargo: data['cargo']);

  factory Usuario.fromList(List data) =>
      Usuario(id: data[0], nombre: data[1], cargo: data[2]);
}
