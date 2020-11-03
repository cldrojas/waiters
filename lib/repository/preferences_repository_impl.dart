import 'dart:convert';

import 'package:waiters/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  @override
  Future<String> get local async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('local');
  }

  @override
  Future<void> saveLocal(String local) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('local', local);
  }

  @override
  Future<Usuario> get usuario async {
    final prefs = await SharedPreferences.getInstance();
    return Usuario.fromList(prefs.getStringList('usuario'));
  }

  @override
  Future<void> saveUsuario(Usuario user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('usuario', [user.id, user.nombre, user.cargo]);
  }

  @override
  Future<void> deleteUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', null);
  }

  @override
  Future<Usuario> login(String correo, String clave) async {
    final url = 'http://spinnet.cl/waiters/user/login.php';

    try {
      final response =
          await http.post(url, body: {'correo': correo, 'clave': clave});
      Usuario user;
      print('created user');
      print('response status: ${response.statusCode}');
      print('response body: ${response.body}');
      if (response.body == '[]') {
        print('empty response from API');
        return null;
      } else if (response.body.length > 0) {
        user = Usuario.fromList(json.decode(response.body));
        print('usuario obtenido: ${user.nombre}');
      }
      return user;
    } catch (e) {
      print('Error Repo: $e');
      return null;
    }
  }
}
