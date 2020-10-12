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

  Map<String, dynamic> getJson(json) {
    return Map.from(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carta'),
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
                      itemCount: snapshot.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        print(snapshot.data.snapshot.value);
                        String item = getJson(snapshot.data.snapshot.value)
                            .entries
                            .elementAt(index)
                            .key;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: agregar item al pedido
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
