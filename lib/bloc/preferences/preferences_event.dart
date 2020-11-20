import 'package:equatable/equatable.dart';

abstract class PreferencesEvent extends Equatable {}

class LoadPreferences extends PreferencesEvent {
  @override
  List<Object> get props => [];
}

class CambiarLocal extends PreferencesEvent {
  final String local;

  CambiarLocal(this.local);

  @override
  List<Object> get props => [local];
}

class CambiarTema extends PreferencesEvent {
  final bool dark;

  CambiarTema(this.dark);

  @override
  List<Object> get props => [dark];
}

class Login extends PreferencesEvent {
  final String mail;
  final String pass;

  Login(this.mail, this.pass);

  @override
  List<Object> get props => [mail, pass];
}

class Logout extends PreferencesEvent {
  @override
  List<Object> get props => [];
}
