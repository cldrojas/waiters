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
  @override
  void initState() {
    super.initState();
    _dbCarta = FirebaseDatabase.instance.reference().child("carta");
    _dbPedido = FirebaseDatabase.instance.reference().child("pedido");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              hintText: 'Carta', hintStyle: TextStyle(color: Colors.white)),
        ),
      ),
      body: Container(
        child: StreamBuilder(
            stream: _dbCarta.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data != null) {
                if (snapshot.data.snapshot.value != null) {
                  Map<String, dynamic> _sandwich =
                      Map.from(snapshot.data.snapshot.value);
                  //String dispo = _sandwich.entries.;

                  return ListView.builder(
                      itemCount: snapshot.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        String item = _sandwich.entries.elementAt(index).key;
                        var cosas = _sandwich.entries.elementAt(index).value;
                        String local = widget.path.split('/').first;
                        if (!cosas.entries.toString().contains(local)) {
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
                              tileColor: Colors.deepPurple,
                              onTap: () {
                                _dbPedido
                                    .child(widget.path)
                                    .update({'item-$index': item});
                                Navigator.pop(context);
                              },
                            ),
                          );
                        } else {
                          return Divider(
                            height: 0,
                          );
                        }
                      });
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sticky_note_2_outlined,
                          size: 100,
                        ),
                        Text(
                          'Pedido nuevo',
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
      ),
    );
  }
}
