import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:waiters/bloc/preferences_bloc.dart';
import 'package:waiters/page/select_local.dart';

class InfoPage extends StatefulWidget {
  final DatabaseReference reference;
  final PreferencesBloc prefsBloc;
  const InfoPage({
    Key key,
    this.reference,
    this.prefsBloc,
  }) : super(key: key);

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
              trailing: Icon(Icons.corporate_fare),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LocalPage(
                      reference: widget.reference,
                      prefsBloc: widget.prefsBloc,
                    ),
                  ),
                );
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
