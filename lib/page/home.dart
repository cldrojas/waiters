import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waiters/widget/mesa.dart';

import 'info.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _dbRef;

  bool _signIn;
  String _local;

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.reference().child("masterino");
    _signIn = false;
    _local = 'lincoyan';
  }

  @override
  Widget build(BuildContext context) {
    return _signIn ? mainScaffold() : signInScaffold();
  }

  Widget mainScaffold() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 35,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => InfoPage(),
                      ),
                    );
                  }),
            )
          ],
        ),
        body: StreamBuilder(
          stream: _dbRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data.snapshot.value != null) {
              dynamic local = snapshot.data.snapshot.value['$_local'];
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: local.length,
                itemBuilder: (context, i) {
                  int mesa = i + 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Mesa(
                      local: _local,
                      estado: local['mesa-$mesa'],
                      index: i + 1,
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget signInScaffold() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset('assets/login-logo.png')),
            SizedBox(height: 50),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: 'Correo electronico'),
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 30),
            RaisedButton(
              child: Text(
                'iniciar sesion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                _signInAnon();
              },
              textColor: Colors.white,
              color: Colors.cyan,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }

  void _signInAnon() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    print("** user anon: ${user.isAnonymous}");
    print("** user uid: ${user.uid}");

    setState(() {
      if (user != null) {
        _signIn = true;
      } else {
        _signIn = false;
      }
    });
  }
}
