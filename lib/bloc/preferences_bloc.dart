import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waiters/repository/preferences_repository.dart';

abstract class PreferencesEvent extends Equatable {}

class CambiarLocal extends PreferencesEvent {
  final String local;

  CambiarLocal(this.local);

  @override
  List<Object> get props => [local];
}

class Login extends PreferencesEvent {
  final String usuario;

  Login(this.usuario);

  @override
  List<Object> get props => [usuario];
}

class PreferencesState extends Equatable {
  final String local;

  PreferencesState(this.local);

  @override
  List<Object> get props => [local];
}

class PreferencesBloc extends Bloc<PreferencesEvent, PreferencesState> {
  final PreferencesRepository _preferencesRepository;
  final PreferencesState _initialState;

  PreferencesBloc({
    @required PreferencesRepository preferencesRepository,
    @required String local,
  })  : assert(preferencesRepository != null),
        _preferencesRepository = preferencesRepository,
        _initialState = PreferencesState('lincoyan');

  @override
  PreferencesState get initialState => _initialState;

  @override
  Stream<PreferencesState> mapEventToState(PreferencesEvent event) async* {
    if (event is CambiarLocal) {
      await _preferencesRepository.saveLocal(event.local);
      yield PreferencesState(event.local);
    } else if (event is Login) {
      await _preferencesRepository.login(event.usuario);
    }
  }
}
