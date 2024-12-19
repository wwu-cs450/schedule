import 'package:client/domain/completed_classes.dart';
import 'package:client/domain/course.dart';

class ClassStorage {
  factory ClassStorage() => _instance;

  ClassStorage._internal();
  // Assuming this is a singleton
  static final ClassStorage _instance = ClassStorage._internal();

  // List to store completed classes
  final List<CompletedClass> _classes = [];

  // Add classes to the storage
  void addClasses(List<CompletedClass> classes) {
    _classes.addAll(classes);
  }

  // Retrieve the stored classes
  List<CompletedClass> get classes => _classes;

  // Clear all stored classes
  bool clearTranscript() {
    if (_classes.isEmpty) {
      return false;
    } else {
      _classes.clear();
      return true;
    }
  }

  bool haveTaken(Course course) {
    return _classes.any(
      (each) =>
          each.subject == course.subject.code &&
          each.classNumber == course.number,
    );
  }
}
