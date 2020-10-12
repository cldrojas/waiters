import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences_bloc.dart';

class LocalPage extends StatefulWidget {
  final DatabaseReference reference;
  final PreferencesBloc prefsBloc;

  const LocalPage({Key key, this.reference, this.prefsBloc}) : super(key: key);

  @override
  _LocalPageState createState() => _LocalPageState();
}

Map<String, dynamic> getJson(json) {
  return Map.from(json);
}

class _LocalPageState extends State<LocalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seleccionar Local')),
      body: BlocBuilder<PreferencesBloc, PreferencesState>(
        builder: (context, state) {
          return StreamBuilder(
              stream: widget.reference.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    !snapshot.hasError &&
                    snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data.snapshot.value.length,
                      itemBuilder: (context, index) {
                        String local = getJson(snapshot.data.snapshot.value)
                            .entries
                            .elementAt(index)
                            .key;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text(
                              local,
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: Icon(
                              Icons.list,
                              color: Colors.white,
                            ),
                            tileColor: Colors.deepPurple,
                            onTap: () {
                              widget.prefsBloc.add(CambiarLocal(local));
                              Navigator.pop(context);
                            },
                          ),
                        );
                      });
                } else {
                  return CircularProgressIndicator();
                }
              });
        },
      ),
    );
  }
}
