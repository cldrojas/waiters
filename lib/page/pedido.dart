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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido mesa ${widget.mesa}'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              FirebaseDatabase.instance
                  .reference()
                  .child('local/${widget.local}')
                  .update({'mesa-${widget.mesa}': 'cocinando'});
              Navigator.pop(context);
            },
          ),
        ],
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
                    int cantidad = Map.from(snapshot.data.snapshot.value)
                        .entries
                        .elementAt(index)
                        .value;
                    String producto = Map.from(snapshot.data.snapshot.value)
                        .entries
                        .elementAt(index)
                        .key;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          producto,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Text(
                          ' Cantidad: $cantidad',
                          style: TextStyle(fontSize: 18),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () =>
                              _dbRef.update({'$producto': cantidad + 1}),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.highlight_remove),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () => cantidad == 1
                              ? _dbRef.child('$producto').remove()
                              : _dbRef.update({'$producto': cantidad - 1}),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IngredientesPage(
                              plato: producto,
                              path: '${widget.local}/mesa-${widget.mesa}',
                              id: producto,
                            ),
                          ),
                        ),
                        tileColor: Colors.green,
                      ),
                    );
                  },
                );
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
                        'Pedido vacío',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartaPage(
                path: '${widget.local}/mesa-${widget.mesa}',
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
