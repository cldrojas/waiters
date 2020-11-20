import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences/preferences_bloc.dart';

class SwitchTheme extends StatefulWidget {
  final bool darkTheme;

  const SwitchTheme({Key key, @required this.darkTheme}) : super(key: key);

  @override
  _SwitchThemeState createState() => _SwitchThemeState();
}

class _SwitchThemeState extends State<SwitchTheme> {
  PreferencesBloc _preferencesBloc;
  bool switchControl;
  var textHolder = 'Switch is OFF';

  @override
  void initState() {
    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context);
    switchControl = widget.darkTheme;
    super.initState();
  }

  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
        textHolder = 'Switch is ON';
      });
      _preferencesBloc.add(CambiarTema(true));
    } else {
      setState(() {
        switchControl = false;
        textHolder = 'Switch is OFF';
      });
      _preferencesBloc.add(CambiarTema(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.0,
          child: Switch(
            onChanged: toggleSwitch,
            value: switchControl,
            activeColor: Colors.green[300],
            activeTrackColor: Colors.green[900],
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
