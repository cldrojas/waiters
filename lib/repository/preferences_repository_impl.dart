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
}
