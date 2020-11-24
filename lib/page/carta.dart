import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartaPage extends StatefulWidget {
  final String path;

  const CartaPage({Key key, this.path}) : super(key: key);
  @override
  _CartaPageState createState() => _CartaPageState();
}

class _CartaPageState extends State<CartaPage> {
  DatabaseReference _dbCarta;
  DatabaseReference _dbPedido;
  String local;
  List listaInicial = [];
  List listaFiltrada = [];
  @override
  void initState() {
    super.initState();
    _dbCarta = FirebaseDatabase.instance.reference().child("carta");
    _dbPedido = FirebaseDatabase.instance.reference().child("pedido");
    local = widget.path.split('/').first;
    print('loading carta');
    _loadCarta();
  }

  void _loadCarta() async {
    DataSnapshot recogido = await _dbCarta.once();
    Map carta = recogido.value;
    carta.forEach((key, value) {
      if (!value.toString().contains(local)) {
        listaInicial.add({key, value});
      }
    });
    print('carta cargada: $listaInicial');
    setState(() {});
  }

  Future<Map> _loadPedido() async {
    DataSnapshot pedido = await _dbPedido.child(widget.path).once();
    Map detalle = pedido.value;
    return detalle;
  }

  void _filtrar(String query) {
    print('filtrando lista: $query');
    listaFiltrada.clear();
    listaInicial.forEach((element) {
      print('elemento de la lista: ${element.toString()}');
      if (element.toString().contains(query)) {
        listaFiltrada.add(element);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _filtrar,
          decoration: InputDecoration(
              hintText: 'Carta', hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: listaFiltrada.isEmpty
              ? listaInicial.length
              : listaFiltrada.length,
          itemBuilder: (context, index) {
            String item = listaFiltrada.isEmpty
                ? listaInicial
                    .elementAt(index)
                    .toString()
                    .split(',')
                    .first
                    .substring(1)
                : listaFiltrada
                    .elementAt(index)
                    .toString()
                    .split(',')
                    .first
                    .substring(1);

            var detalles = listaInicial.contains('$local');

            print('detalles: $detalles');

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(
                  item,
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                tileColor: Colors.blueAccent,
                onTap: () async {
                  var pedido = await _loadPedido();
                  if (pedido != null && pedido.containsKey(item)) {
                    DataSnapshot cantidad =
                        await _dbPedido.child('${widget.path}/$item').once();
                    _dbPedido
                        .child(widget.path)
                        .update({item: cantidad.value + 1});
                  } else {
                    _dbPedido.child(widget.path).update({item: 1});
                  }
                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
