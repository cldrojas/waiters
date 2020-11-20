import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences/preferences_bloc.dart';
import 'package:waiters/widget/mesa.dart';
import 'package:waiters/widget/switch.dart';

import 'disponibilidad.dart';
import 'select_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PreferencesBloc _preferencesBloc;
  DatabaseReference _dbRef;

  @override
  void initState() {
    _dbRef = FirebaseDatabase.instance.reference().child("local");
    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String local, usuario;
    bool mesero = false;
    bool selected = true;

    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (buildcontext, state) {
        if (state is PreferencesLoaded) {
          print('bloc builder home state: $state');
          local = state.local;
          usuario = state.usuario.nombre;
          selected = state.dark;
          print(
              'Bloc(local: $local, usuario: $usuario, dark theme: $selected)');
        }
        return StreamBuilder(
          stream: _dbRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              dynamic locales = snapshot.data.snapshot.value['$local'];
              print('locales del builder: $locales');
              print(
                  'variable mesero = ${snapshot.data.snapshot.value['$local']['mesero']}');
              snapshot.data.snapshot.value['$local']['mesero'] == 'false'
                  ? mesero = false
                  : mesero = true;
              return Scaffold(
                appBar: AppBar(
                  title: GestureDetector(
                    child: Text(
                      'Local vinculado: $local',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: mesero == false ? Colors.white : Colors.green,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor:
                      mesero == false ? Colors.teal : Colors.tealAccent,
                ),
                drawer: Drawer(
                  child: Center(
                    child: ListView(
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(color: Colors.orange),
                          child: Row(
                            children: [
                              Text(
                                usuario,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 27),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Seleccionar local',
                          ),
                          trailing: Icon(Icons.corporate_fare),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocalPage(
                                  reference: _dbRef,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Modificar disponibilidad'),
                          trailing: Icon(Icons.calendar_today_rounded),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisponibilidadPage(
                                  local: local,
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Cerrar sesion'),
                          trailing: Icon(Icons.logout),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          onTap: () {
                            _preferencesBloc.add(Logout());
                            print('cerrando sesion...');
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text('Dark theme'),
                          trailing: SwitchTheme(
                            darkTheme: selected,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                body: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: locales.length - 1,
                  itemBuilder: (context, i) {
                    int mesa = i + 1;
                    print(locales['mesa-$mesa']);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Mesa(
                        local: local,
                        estado: locales['mesa-$mesa'],
                        index: i + 1,
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }
}
