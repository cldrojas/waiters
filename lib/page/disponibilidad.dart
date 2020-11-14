import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'sin-stock.dart';

class DisponibilidadPage extends StatefulWidget {
  final String local;

  const DisponibilidadPage({Key key, @required this.local}) : super(key: key);
  @override
  _DisponibilidadPageState createState() => _DisponibilidadPageState();
}

class _DisponibilidadPageState extends State<DisponibilidadPage> {
  DatabaseReference _dbCarta =
      FirebaseDatabase.instance.reference().child('carta');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              labelText: 'dispo', hintStyle: TextStyle(color: Colors.white)),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SinStock(
                                            sandwich: item,
                                            local: widget.local,
                                          )));
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
    );
  }
}
