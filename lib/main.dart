import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/bloc/preferences_bloc.dart';
import 'package:waiters/page/home.dart';
import 'package:waiters/repository/preferences_repository_impl.dart';

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

class WaitersApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Waiters 1.0',
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: HomePage(),
        );
      },
    );
  }
}
