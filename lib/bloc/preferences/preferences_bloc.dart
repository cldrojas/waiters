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
    }
  }

  Stream<PreferencesState> _mapCambiarLocalToState(String local) async* {
    await _preferencesRepository.usuario;
    await _preferencesRepository.saveLocal(local);
    yield PreferencesLoaded(local: local);
  }

  Stream<PreferencesState> _mapLoadPreferencesToState() async* {
    var local = await _preferencesRepository.local;
    if (local == null) {
      local = 'lincoyan';
    }
    yield PreferencesLoaded(local: local);
  }

  Stream<PreferencesState> _mapLoginToState(
      String email, String password) async* {
    String local = await _preferencesRepository.local;
    Usuario user = await _preferencesRepository.login(email, password);
    if (user != null) {
      if (user.cargo == 'mesero') {
        await _preferencesRepository.saveUsuario(user);
        yield PreferencesLoaded(local: local, usuario: user);
      } else {
        yield LoginError('Solo los meseros pueden acceder a Waiters');
      }
    } else {
      yield LoginError('Usuario no encontrado');
    }
  }
}
