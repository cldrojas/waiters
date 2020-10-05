import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
        icon = Icons.accessibility_new;
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
        break;
      case 'pidiendo':
        color = Colors.lightBlue;
        icon = Icons.border_color;
        break;
    }

    return GestureDetector(
      onTap: () {
        FirebaseDatabase.instance
            .reference()
            .child("masterino/${widget.local}")
            .update({'mesa-${widget.index}': 'pidiendo'});
      },
      child: Container(
          height: 200,
          color: color,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  top: 60,
                  left: 10,
                  child: Text('Mesa ${widget.index}',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              Positioned(
                top: 10,
                left: 10,
                child: Icon(
                  icon,
                  size: 40,
                ),
              ),
            ],
          )),
    );
  }
}
