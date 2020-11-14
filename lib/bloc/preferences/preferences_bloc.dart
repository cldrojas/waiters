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

  PreferencesBloc({
    @required PreferencesRepository preferencesRepository,
    @required String local,
  })  : assert(preferencesRepository != null),
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
    }
  }

  Stream<PreferencesState> _mapCambiarLocalToState(String local) async* {
    print('cambiar local event');
    Usuario user = await _preferencesRepository.usuario;
    print('nombre: ${user.nombre}');
    await _preferencesRepository.saveLocal(local);
    yield PreferencesLoaded(local: local, usuario: user);
  }

  Stream<PreferencesState> _mapLoadPreferencesToState() async* {
    var local = await _preferencesRepository.local;
    var usuario = await _preferencesRepository.usuario;
    if (local != null && usuario != null) {
      yield PreferencesLoaded(local: local, usuario: usuario);
    } else {
      yield PreferencesLoaded(local: 'lincoyan');
    }
  }

  Stream<PreferencesState> _mapLoginToState(
      String email, String password) async* {
    print('login to state');
    String local = await _preferencesRepository.local;
    Usuario user = await _preferencesRepository.login(email, password);
    if (user != null) {
      print('user != null');
      if (user.cargo == 'mesero') {
        print('cargo == mesero');
        await _preferencesRepository.saveUsuario(user);
        print('usuario guardado');
        yield PreferencesLoaded(local: local, usuario: user);
      } else {
        print('agregando error al stream: solo meseros');
        yield LoginError('Solo los meseros pueden acceder a Waiters');
        await Future.delayed(Duration(seconds: 1));
        yield PreferencesLoaded(local: local);
      }
    } else {
      yield LoginError('Usuario no encontrado');
      await Future.delayed(Duration(seconds: 1));
      yield PreferencesLoaded(local: local);
    }
  }

  Stream<PreferencesState> _mapLogOutToState() async* {
    _preferencesRepository.deleteUsuario();
    var local = await _preferencesRepository.local;
    yield PreferencesLoaded(local: local);
  }
}
