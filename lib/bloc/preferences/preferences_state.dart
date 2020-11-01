import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:waiters/model/usuario.dart';

abstract class PreferencesState extends Equatable {
  PreferencesState([List props = const []]) : super();
}

class PreferencesNotLoaded extends PreferencesState {
  @override
  List<Object> get props => [];
}

class PreferencesLoaded extends PreferencesState {
  final String local;
  final Usuario usuario;
  PreferencesLoaded({@required this.local, this.usuario}) : super([local]);

  @override
  List<Object> get props => [local, usuario];
}

class LoginError extends PreferencesState {
  final String error;

  LoginError(this.error);

  @override
  List<Object> get props => [error];
}
