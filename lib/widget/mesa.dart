import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:waiters/page/pedido.dart';

class Mesa extends StatefulWidget {
  final int index;
  final String local;
  final String estado;
  const Mesa({Key key, this.index, this.local, this.estado}) : super(key: key);

  @override
  _MesaState createState() => _MesaState();
}

class _MesaState extends State<Mesa> {
  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (widget.estado) {
      case 'libre':
        color = Colors.green;
        icon = Icons.deck;
        break;
      case 'ocupada':
        color = Colors.blue;
        icon = Icons.brunch_dining;
        break;
      case 'mesero':
        color = Colors.teal;
        icon = Icons.campaign;
        break;
      case 'cuenta':
        color = Colors.red;
        icon = Icons.attach_money;
        break;
      case 'pidiendo':
        color = Colors.lightBlue;
        icon = Icons.border_color;
        break;
      case 'cocinando':
        color = Colors.cyanAccent;
        icon = Icons.emoji_food_beverage_rounded;
        break;
    }

    return GestureDetector(
      onTap: () {
        FirebaseDatabase.instance
            .reference()
            .child("local/${widget.local}")
            .update({'mesa-${widget.index}': 'pidiendo'});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PedidoPage(
                      local: widget.local,
                      mesa: widget.index,
                    )));
      },
      onLongPress: () {
        FirebaseDatabase.instance
            .reference()
            .child("local/${widget.local}")
            .update({'mesa-${widget.index}': 'cocinando'});
      },
      child: Container(
          height: 200,
          color: color,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 100,
                  left: 40,
                  child: Text('Mesa ${widget.index}',
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold))),
              Positioned(
                top: 20,
                left: 50,
                child: Icon(
                  icon,
                  size: 60,
                ),
              ),
            ],
          )),
    );
  }
}
