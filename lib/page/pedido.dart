import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:waiters/page/carta.dart';
import 'package:waiters/page/ingredientes.dart';

class PedidoPage extends StatefulWidget {
  final String local;
  final int mesa;
  const PedidoPage({Key key, this.mesa, this.local}) : super(key: key);
  @override
  _PedidoPageState createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  DatabaseReference _dbRef;
  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance
        .reference()
        .child("pedido/${widget.local}/mesa-${widget.mesa}");
  }

  Map<String, dynamic> getJson(json) {
    return Map.from(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido mesa ${widget.mesa}'),
      ),
      body: Container(
        child: StreamBuilder(
            stream: _dbRef.onValue,
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
                            .value;
                        String id = getJson(snapshot.data.snapshot.value)
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
                            trailing: IconButton(
                                icon: Icon(Icons.highlight_remove),
                                color: Colors.white,
                                onPressed: () => {
                                      _dbRef.child('$id').remove(),
                                      print('eliminando $id'),
                                      print('item seleccionado' + item)
                                    }),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IngredientesPage(
                                          plato: item,
                                          path:
                                              '${widget.local}/mesa-${widget.mesa}',
                                          id: id,
                                        ))),
                            tileColor: Colors.green,
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartaPage(
                        path: '${widget.local}/mesa-${widget.mesa}',
                      )));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
