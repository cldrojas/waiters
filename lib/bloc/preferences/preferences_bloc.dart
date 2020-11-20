import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/model/usuario.dart';
import 'package:waiters/repository/preferences_repository.dart';

import 'preferences_event.dart';
import 'preferences_state.dart';

export 'preferences_event.dart';
export 'preferences_state.dart';

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository _preferencesRepository;
  final PreferencesState _initialState;

  PreferencesBloc(
      {@required PreferencesRepository preferencesRepository,
      String local,
      bool dark})
      : assert(preferencesRepository != null),
        _preferencesRepository = preferencesRepository,
        _initialState = PreferencesNotLoaded();

  @override
  PreferencesState get initialState => _initialState;

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    if (event is LoadPreferences) {
      yield* _mapLoadPreferencesToState();
    } else if (event is CambiarLocal) {
      yield* _mapCambiarLocalToState(event.local);
    } else if (event is Login) {
      yield* _mapLoginToState(event.mail, event.pass);
    } else if (event is Logout) {
      yield* _mapLogOutToState();
    } else if (event is CambiarTema) {
      yield* _mapCambiarTemaToState(event.dark);
    }
  }

  Stream<PreferencesState> _mapCambiarLocalToState(String local) async* {
    print('cambiar local event');
    Usuario user = Usuario.fromList(await _preferencesRepository.usuario);
    bool dark = await _preferencesRepository.dark;
    print('nombre: ${user.nombre}');
    await _preferencesRepository.saveLocal(local);
    yield PreferencesLoaded(local: local, usuario: user, dark: dark);
  }

  Stream<PreferencesState> _mapCambiarTemaToState(bool dark) async* {
    Usuario user = Usuario.fromList(await _preferencesRepository.usuario);
    String local = await _preferencesRepository.local;
    await _preferencesRepository.saveTema(dark);
    yield PreferencesLoaded(local: local, usuario: user, dark: dark);
  }

  Stream<PreferencesState> _mapLoadPreferencesToState() async* {
    print('Loading preferences...');
    var local = await _preferencesRepository.local;
    var dark = await _preferencesRepository.dark;
    print('Preferences loaded: local $local, tema $dark');
    if (local == null) local = 'lincoyan';
    if (dark == null) dark = true;
    yield PreferencesLoaded(local: local, dark: dark);
  }

  Stream<PreferencesState> _mapLoginToState(
      String email, String password) async* {
    print('login to state');
    String local = await _preferencesRepository.local;
    bool dark = await _preferencesRepository.dark;
    if (local == null) local = 'lincoyan';
    if (dark == null) dark = true;
    Usuario user = await _preferencesRepository.login(email, password);
    if (user != null) {
      print('user != null');
      if (user.cargo == 'mesero') {
        print('cargo == mesero');
        await _preferencesRepository.saveUsuario(user);
        print('usuario guardado: ${user.nombre} Local asignado: $local');
        yield PreferencesLoaded(local: local, usuario: user, dark: dark);
      } else {
        print('agregando error al stream: solo meseros');
        yield LoginError('Solo los meseros pueden acceder a Waiters');
        await Future.delayed(Duration(seconds: 1));
        yield PreferencesLoaded(local: local, dark: dark);
      }
    } else {
      yield LoginError('Usuario no encontrado');
      await Future.delayed(Duration(seconds: 1));
      yield PreferencesLoaded(local: local, dark: dark);
    }
  }

  Stream<PreferencesState> _mapLogOutToState() async* {
    _preferencesRepository.deleteUsuario();
    var local = await _preferencesRepository.local;
    bool dark = await _preferencesRepository.dark;
    yield PreferencesLoaded(local: local, dark: dark);
  }
}
