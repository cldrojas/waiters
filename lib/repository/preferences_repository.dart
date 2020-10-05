abstract class PreferencesRepository {
  Future<void> saveLocal(String local);
  Future<String> get local;
}
