import 'package:firebase_database/firebase_database.dart';

class Pedido {
  final List<String> pedido;
  final FirebaseDatabase db = FirebaseDatabase.instance;

  Pedido(this.pedido);

  Map<String, dynamic> getJson(json) {
    return Map.from(json);
  }

  void toJson(List<String> pedido) {
    for (var item in pedido) {
      db.reference().child('/pedido').push().set(item);
    }
  }
}
