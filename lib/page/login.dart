import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences/preferences_bloc.dart';
import 'package:waiters/bloc/preferences/preferences_event.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final mailController = TextEditingController();
  final passController = TextEditingController();
  PreferencesBloc prefs;

  @override
  void initState() {
    prefs = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return BlocBuilder(
      bloc: prefs,
      builder: (context, state) => Scaffold(
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ListView(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset('assets/login-logo.png')),
                SizedBox(height: 50),
                TextFormField(
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(labelText: 'Correo electronico'),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () => node.nextFocus()),
                TextFormField(
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => node.unfocus()),
                SizedBox(height: 30),
                RaisedButton(
                  child: Text(
                    'Iniciar Sesion',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    prefs.add(Login(mailController.text, passController.text));
                    await Future.delayed(Duration(seconds: 1));
                    if (state is LoginError) {
                      _onWidgetDidBuild(() async {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                state.error,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red),
                        );
                        print('Estado de error: ' + state.error);
                      });
                    }
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
        ),
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
