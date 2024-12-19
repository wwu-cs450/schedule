import 'dart:convert';

import 'package:client/domain/campus.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/prefs.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';

class SearchCriteria {
  // Factory constructor to return the singleton instance
  factory SearchCriteria() {
    _instance ??= SearchCriteria._privateConstructor();
    return _instance!;
  }
  // Private constructor
  SearchCriteria._privateConstructor();

  // Singleton instance
  static SearchCriteria? _instance;

  Map<String, dynamic> criteria = {
    'Campus': Campus.allCampuses(),
    'Department': Department.allDepartments(),
    'Subject': Subject.allSubjects(),
    'Term': Term.allTerms(),
    'Class Number': 0,
    'Level': 'Any',
    'Credits': 'Any',
    'GS': false,
    'Status': false,
    'Instructor': '',
    'Schedule': <String>[],
    'Start Time': null,
    'End Time': null,
    'Not Taken': false,
    'Free Classrooms': false,
  };

  static void clearInstance() {
    _instance = null;
  }

  Future<void> save() async {
    final Map<String, dynamic> toSave = {
      'Campus': criteria['Campus'].code,
      'Department': criteria['Department'].code,
      'Subject': criteria['Subject'].code,
      'Term': criteria['Term'].code,
      'Class Number': 0,
      'Level': 'Any',
      'Credits': 'Any',
      'GS': false,
      'Status': false,
      'Instructor': '',
      'Schedule': <String>[],
      'Start Time': null,
      'End Time': null,
    };
    await AbstractPrefs.instance.writePrefs(jsonEncode(toSave));
  }

  Future<void> load() async {
    final String? savedCriteria = await AbstractPrefs.instance.readPrefs();
    if (savedCriteria == null) {
      return;
    }
    final Map<String, dynamic> loadedCriteria = jsonDecode(savedCriteria);
    final List<String> scheduledDays = [];
    for (final each in loadedCriteria['Schedule']) {
      scheduledDays.add(each);
    }
    loadedCriteria['Schedule'] = scheduledDays;
    loadedCriteria['Campus'] = Campus.instances
        .firstWhere((campus) => campus.code == loadedCriteria['Campus']);
    loadedCriteria['Department'] = Department.instances.firstWhere(
      (department) => department.code == loadedCriteria['Department'],
    );
    loadedCriteria['Subject'] = Subject.instances
        .firstWhere((subject) => subject.code == loadedCriteria['Subject']);
    loadedCriteria['Term'] = Term.instances
        .firstWhere((term) => term.code == loadedCriteria['Term']);
    criteria.addAll(loadedCriteria);
    return;
  }
}
