import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SinStock extends StatefulWidget {
  final String sandwich;
  final String local;

  const SinStock({Key key, this.sandwich, this.local}) : super(key: key);
  @override
  _SinStockState createState() => _SinStockState();
}

class _SinStockState extends State<SinStock> {
  DatabaseReference _dbItem;

  @override
  void initState() {
    super.initState();
    print('sandwich recibido: ' + widget.sandwich);
    _dbItem = FirebaseDatabase.instance
        .reference()
        .child('carta/${widget.sandwich}/sin-stock');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sandwich),
      ),
      body: Container(
        child: StreamBuilder(
            stream: _dbItem.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data != null) {
                if (snapshot.data.snapshot.value != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        String item = Map.from(snapshot.data.snapshot.value)
                            .entries
                            .elementAt(index)
                            .key;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              item,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            tileColor: Colors.deepPurple,
                            leading: Icon(
                              Icons.list,
                              color: Colors.white,
                            ),
                            onTap: () {
                              if (item == widget.local) {
                                _dbItem.update({widget.local: null});
                              }
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
                          Icons.check_circle_outline,
                          size: 100,
                        ),
                        Text(
                          'Disponible en todos los locales',
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
        child: Icon(Icons.local_fire_department_outlined),
        onPressed: () {
          _dbItem.update({widget.local: 1});
        },
      ),
    );
  }
}
