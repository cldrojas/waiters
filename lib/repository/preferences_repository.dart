import 'package:waiters/model/usuario.dart';

abstract class PreferencesRepository {
  Future<void> saveLocal(String local);
  Future<String> get local;
  Future<void> saveUsuario(Usuario usuario);
  Future<Usuario> get usuario;
  Future<void> deleteUsuario();
  Future<Usuario> login(String email, String password);
}
