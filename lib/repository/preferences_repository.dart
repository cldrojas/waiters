import 'package:waiters/model/usuario.dart';

abstract class PreferencesRepository {
  Future<void> saveLocal(String local);
  Future<void> saveUsuario(Usuario usuario);
  Future<void> saveTema(bool dark);

  Future<String> get local;
  Future<List<String>> get usuario;
  Future<bool> get dark;

  Future<void> deleteUsuario();
  Future<Usuario> login(String email, String password);
}
