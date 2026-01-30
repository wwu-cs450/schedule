import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractPersister {
  static AbstractPersister get instance {
    _instance ??= BrowserPersister();
    return _instance!;
  }

  static set instance(AbstractPersister? instance) {
    _instance = instance;
  }

  static AbstractPersister? _instance;
  Future<String?> readPrefs();
  Future<void> writePrefs(String value);
  Future<String?> readCourseHistory();
  Future<void> writeCourseHistory(String value);
}

class BrowserPersister implements AbstractPersister {
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

  @override
  Future<String?> readCourseHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('courseHistory');
  }

  @override
  Future<void> writeCourseHistory(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('courseHistory', value);
  }
}

class MockPersister implements AbstractPersister {
  String? prefs;
  String? courseHistory;

  @override
  Future<String?> readPrefs() async {
    return prefs;
  }

  @override
  Future<void> writePrefs(String value) async {
    prefs = value;
  }

  @override
  Future<String?> readCourseHistory() async {
    return courseHistory;
  }

  @override
  Future<void> writeCourseHistory(String value) async {
    courseHistory = value;
  }
}
