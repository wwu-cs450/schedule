import 'dart:convert';

import 'package:client/domain/course.dart';
import 'package:client/domain/models/completed_course.dart';
import 'package:client/domain/persister.dart';
import 'package:flutter/material.dart';

class ClassStorage extends ChangeNotifier {
  factory ClassStorage() => _instance;

  ClassStorage._internal();
  // Assuming this is a singleton
  static final ClassStorage _instance = ClassStorage._internal();

  // List to store completed classes
  final List<CompletedCourse> _classes = [];

  // Add classes to the storage
  Future<void> addClasses(List<CompletedCourse> classes) async {
    _classes.addAll(classes);
    await save();
    notifyListeners();
  }

  // Retrieve the stored classes
  List<CompletedCourse> get classes => _classes;

  // Clear all stored classes
  Future<bool> clearTranscript() async {
    if (_classes.isEmpty) {
      return false;
    } else {
      _classes.clear();
      await save();
      notifyListeners();
      return true;
    }
  }

  bool haveTaken(Course course) {
    final normalizedCourse = _normalizeCourseCode(
      '${course.subject.code} ${course.number}',
    );
    final normalizedCourseNoSuffix = _normalizeCourseCode(
      '${course.subject.code} ${_numericPrefix(course.number)}',
    );

    return _classes.any((each) {
      final completed = _normalizeCourseCode(each.course);
      return completed == normalizedCourse ||
          completed == normalizedCourseNoSuffix;
    });
  }

  static String _normalizeCourseCode(String value) {
    return value.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
  }

  static String _numericPrefix(String courseNumber) {
    final match = RegExp(r'^\d+').firstMatch(courseNumber);
    return match?.group(0) ?? courseNumber;
  }

  // Save completed courses to persistent storage
  Future<void> save() async {
    final List<Map<String, dynamic>> jsonList = _classes
        .map((course) => course.toJson())
        .toList();
    await AbstractPersister.instance.writeCourseHistory(jsonEncode(jsonList));
  }

  // Load completed courses from persistent storage
  Future<void> load() async {
    final String? savedCourses = await AbstractPersister.instance
        .readCourseHistory();
    if (savedCourses == null) {
      return;
    }
    try {
      final List<dynamic> jsonList = jsonDecode(savedCourses);
      _classes.clear();
      _classes.addAll(
        jsonList.map((json) => CompletedCourse.fromJson(json)).toList(),
      );
      notifyListeners();
    } catch (e) {
      // Handle corrupted data gracefully
      _classes.clear();
    }
  }
}
