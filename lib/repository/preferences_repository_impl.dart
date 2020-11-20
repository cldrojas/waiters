import 'dart:convert';

import 'package:waiters/model/usuario.dart';
import 'package:http/http.dart' as http;
import 'preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  @override
  Future<String> get local async {
    final prefs = await SharedPreferences.getInstance();
    var local = prefs.getString('local');
    print('getting local: $local');
    return local;
  }

  @override
  Future<void> saveLocal(String local) async {
    final prefs = await SharedPreferences.getInstance();
    print('saving local: $local');
    await prefs.setString('local', local);
  }

  @override
  Future<List<String>> get usuario async {
    final prefs = await SharedPreferences.getInstance();
    var lista = prefs.getStringList('usuario');
    print('getting user: $lista');
    return lista;
  }

  @override
  Future<void> saveUsuario(Usuario user) async {
    final prefs = await SharedPreferences.getInstance();
    print('saving user: $user');
    prefs.setStringList('usuario', [user.id, user.nombre, user.cargo]);
  }

  @override
  Future<void> deleteUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', null);
  }

  @override
  Future<Usuario> login(String usuario, String clave) async {
    final url = 'https://spinnet.cl/waiters/user/login.php';

    try {
      final response =
          await http.post(url, body: {'usuario': usuario, 'clave': clave});
      Usuario user;
      print('response status: ${response.statusCode}');
      print('response body: ${response.body}');
      if (response.body == '[]') {
        print('empty response from API');
        return null;
      } else if (response.body.length > 0) {
        user = Usuario.fromJson(json.decode(response.body)[0]);
        print('usuario obtenido: ${user.nombre}');
      }
      return user;
    } catch (e) {
      print('Error Repo: $e');
      return null;
    }
  }

  @override
  Future<void> saveTema(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    print('saving dark-theme: $dark');
    await prefs.setBool('dark', dark);
  }

  @override
  Future<bool> get dark async {
    final prefs = await SharedPreferences.getInstance();
    bool dark = prefs.getBool('dark');
    print('getting dark-theme: $dark');
    return dark;
  }
}
