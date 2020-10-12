import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class IngredientesPage extends StatefulWidget {
  final String path;
  final String plato;
  final String id;
  const IngredientesPage({Key key, this.plato, this.id, this.path})
      : super(key: key);
  @override
  _IngredientesPageState createState() => _IngredientesPageState();
}

class _IngredientesPageState extends State<IngredientesPage> {
  DatabaseReference _dbCarta;
  DatabaseReference _dbPedido;
  @override
  void initState() {
    super.initState();
    String plato;
    widget.plato.contains('-')
        ? plato = widget.plato.split('-').first
        : plato = widget.plato;
    _dbCarta = FirebaseDatabase.instance
        .reference()
        .child("carta/$plato/ingredientes");
    _dbPedido = FirebaseDatabase.instance.reference().child("pedido/");
  }

  Map<String, dynamic> getJson(json) {
    return Map.from(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seleccionar ingredientes'),
        ),
        body: Container(
          child: StreamBuilder(
              stream: _dbCarta.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data != null) {
                  if (snapshot.data.snapshot.value != null) {
                    return ListView.builder(
                        itemCount: snapshot.data.snapshot.value.length - 1,
                        itemBuilder: (context, index) {
                          print(snapshot.data.snapshot.value);
                          String item;
                          if (snapshot.data.snapshot.value[index + 1] != null) {
                            item = snapshot.data.snapshot.value[index + 1]
                                .toString();
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                item,
                                style: TextStyle(color: Colors.white),
                              ),
                              leading: IconButton(
                                onPressed: () {
                                  _dbPedido.child('${widget.path}').update({
                                    '${widget.id}': '${widget.plato}-$item'
                                  });
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.delete),
                                iconSize: 25,
                                color: Colors.white,
                              ),
                              tileColor: Colors.deepPurple,
                              onTap: () {},
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.no_food,
                            size: 100,
                          ),
                          Text(
                            'Sin ingredientes registrados',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
