import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences/preferences_bloc.dart';

class LocalPage extends StatefulWidget {
  final DatabaseReference reference;

  const LocalPage({Key key, this.reference}) : super(key: key);

  @override
  _LocalPageState createState() => _LocalPageState();
}

class _LocalPageState extends State<LocalPage> {
  PreferencesBloc prefs;
  DatabaseReference ref;
  @override
  void initState() {
    super.initState();
    prefs = BlocProvider.of<PreferencesBloc>(context);
    ref = FirebaseDatabase.instance.reference().child("local");
  }

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
                        String local = Map.from(snapshot.data.snapshot.value)
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
                              prefs.add(CambiarLocal(local));
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
