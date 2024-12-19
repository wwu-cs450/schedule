import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractPrefs {
  static AbstractPrefs get instance {
    _instance ??= Prefs();
    return _instance!;
  }

  static set instance(AbstractPrefs? instance) {
    _instance = instance;
  }

  static AbstractPrefs? _instance;
  Future<String?> readPrefs();
  Future<void> writePrefs(String value);
}

class Prefs implements AbstractPrefs {
  @override
  Future<String?> readPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('searchCriteria');
  }

  @override
  Future<void> writePrefs(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('searchCriteria', value);
  }
}

class MockPrefs implements AbstractPrefs {
  String? prefs;

  @override
  Future<String?> readPrefs() async {
    return prefs;
  }

  @override
  Future<void> writePrefs(String value) async {
    prefs = value;
  }
}
