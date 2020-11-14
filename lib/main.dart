import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences/preferences_bloc.dart';
import 'package:waiters/repository/preferences_repository_impl.dart';

import 'page/home.dart';
import 'page/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencesrRepository = PreferencesRepositoryImpl();
  // ignore: close_sinks
  final preferencesBloc = PreferencesBloc(
      preferencesRepository: preferencesrRepository,
      local: await preferencesrRepository.local);
  runApp(
    BlocProvider(
      create: (context) => preferencesBloc,
      child: WaitersApp(),
    ),
  );
}

class WaitersApp extends StatefulWidget {
  @override
  _WaitersAppState createState() => _WaitersAppState();
}

class _WaitersAppState extends State<WaitersApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Waiters 1.0',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.teal, brightness: Brightness.dark),
          home: state is PreferencesLoaded && state.usuario != null
              ? Home()
              : SignIn(),
        );
      },
    );
  }
}
