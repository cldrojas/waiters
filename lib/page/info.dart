import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('configuracion'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text('Seleccionar local'),
              trailing: Icon(Icons.business),
              onTap: () {
                //TODO: show floating window select list
              },
            ),
            ListTile(
              title: Text('Cerrar sesion'),
              trailing: Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              onTap: () {
                //TODO: implement logout functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
