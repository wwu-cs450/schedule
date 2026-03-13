import 'dart:async';
import 'dart:convert';

import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/persister.dart';
import 'package:client/domain/query.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';

final allClassDays = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];

class Filters extends ChangeNotifier {
  // Factory constructor to return the singleton instance
  factory Filters() {
    _instance ??= Filters._privateConstructor();
    return _instance!;
  }
  // Private constructor
  Filters._privateConstructor() {
    _reset();
  }

  // Singleton instance
  static Filters? _instance;

  final classes = <Class>[];
  Term? _scheduleTerm;

  late List<Campus> _campuses;
  late List<Department> _departments;
  late List<Subject> _subjects;
  late Term _term;
  late int _classNumber;
  late List<String> _levels;
  late List<String> _credits;
  late bool _isGS;
  late bool _isOpen;
  late String _instructor;
  late List<String> _schedule;
  late String _scheduleLogic;
  late HourMinute? _startTime;
  late HourMinute? _endTime;
  late bool _isNotTaken;
  late bool _isFreeClassrooms;
  late bool _isHideConflicting;

  // Getters
  List<Campus> get campuses => _campuses;
  List<Department> get departments => _departments;
  List<Subject> get subjects => _subjects;
  Term get term => _term;
  int get classNumber => _classNumber;
  List<String> get levels => _levels;
  List<String> get credits => _credits;
  bool get isGS => _isGS;
  bool get isOpen => _isOpen;
  String get instructor => _instructor;
  List<String> get schedule => _schedule;
  String get scheduleLogic => _scheduleLogic;
  HourMinute? get startTime => _startTime;
  HourMinute? get endTime => _endTime;
  bool get isNotTaken => _isNotTaken;
  bool get isFreeClassrooms => _isFreeClassrooms;
  bool get isHideConflicting => _isHideConflicting;

  int get activeFilterCount {
    int count = 0;

    // Check each filter against its default value
    if (_campuses.isNotEmpty) {
      count++;
    }
    if (_departments.isNotEmpty) {
      count++;
    }
    if (_subjects.isNotEmpty) {
      count++;
    }
    if (_term != Term.defaultTerm()) {
      count++;
    }
    if (_classNumber != 0) {
      count++;
    }
    if (_levels.length != 3 ||
        !['Lower', 'Upper', 'Grad'].every(_levels.contains)) {
      count++;
    }
    if (_credits.length != 6 ||
        !['0', '1', '2', '3', '4', '>4'].every(_credits.contains)) {
      count++;
    }
    if (_isGS) {
      count++;
    }
    if (_isOpen) {
      count++;
    }
    if (_instructor.isNotEmpty) {
      count++;
    }
    if (_schedule.length != allClassDays.length || _scheduleLogic != 'Any') {
      count++;
    }
    if (_startTime != null) {
      count++;
    }
    if (_endTime != null) {
      count++;
    }
    if (_isNotTaken) {
      count++;
    }
    if (_isFreeClassrooms) {
      count++;
    }
    if (_isHideConflicting) {
      count++;
    }

    return count;
  }

  Term get scheduleTerm {
    if (_scheduleTerm == null) {
      Set terms = savedClasses().map((e) => e.term).toSet();
      if (terms.isEmpty) {
        terms = Term.instances.toSet();
      }
      final sortedTerms = terms.toList()..sort();
      _scheduleTerm = sortedTerms.first;
    }
    return _scheduleTerm!;
  }

  set scheduleTerm(Term value) {
    _scheduleTerm = value;
    notifyListeners();
  }

  void unsaveAll() {
    for (final each in classes) {
      each.saved = false;
    }
    notifyListeners();
  }

  // Setters
  Future<void> setCampuses(List<Campus> value) async {
    _campuses = value;
    await update();
  }

  Future<void> setDepartments(List<Department> value) async {
    _departments = value;
    await update();
  }

  Future<void> setSubjects(List<Subject> value) async {
    _subjects = value;
    await update();
  }

  Future<void> setTerm(Term value) async {
    _term = value;
    await update();
  }

  Future<void> setClassNumber(int value) async {
    _classNumber = value;
    await update();
  }

  Future<void> setLevels(List<String> value) async {
    _levels = value;
    await update();
  }

  Future<void> setCredits(List<String> value) async {
    _credits = value;
    await update();
  }

  Future<void> setIsGS(bool value) async {
    _isGS = value;
    await update();
  }

  Future<void> setIsOpen(bool value) async {
    _isOpen = value;
    await update();
  }

  Future<void> setInstructor(String value) async {
    _instructor = value;
    await update();
  }

  Future<void> setSchedule(List<String> value) async {
    _schedule = value;
    await update();
  }

  Future<void> setScheduleLogic(String value) async {
    _scheduleLogic = value;
    await update();
  }

  Future<void> setStartTime(HourMinute? value) async {
    _startTime = value;
    await update();
  }

  Future<void> setEndTime(HourMinute? value) async {
    _endTime = value;
    await update();
  }

  Future<void> setIsNotTaken(bool value) async {
    _isNotTaken = value;
    await update();
  }

  Future<void> setIsFreeClassrooms(bool value) async {
    _isFreeClassrooms = value;
    await update();
  }

  Future<void> setIsHideConflicting(bool value) async {
    _isHideConflicting = value;
    await update();
  }

  Future<void> reset() async {
    _reset();
    await update();
  }

  void _reset() {
    _campuses = [];
    _departments = [];
    _subjects = [];
    _term = Term.defaultTerm();
    _classNumber = 0;
    _levels = ['Lower', 'Upper', 'Grad'];
    _credits = ['0', '1', '2', '3', '4', '>4'];
    _isGS = false;
    _isOpen = false;
    _instructor = '';
    _schedule = allClassDays;
    _scheduleLogic = 'Any';
    _startTime = null;
    _endTime = null;
    _isNotTaken = false;
    _isFreeClassrooms = false;
    _isHideConflicting = false;
  }

  static void clearInstance() {
    _instance = null;
  }

  Future<void> save() async {
    final Map<String, dynamic> toSave = {
      'Campuses': campuses.map((c) => c.code).toList(),
      'Departments': departments.map((d) => d.code).toList(),
      'Subjects': subjects.map((s) => s.code).toList(),
      'Term': term.code,
      'Class Number': classNumber,
      'Levels': levels,
      'Credits': credits,
      'GS': isGS,
      'IsOpen': isOpen,
      'Instructor': instructor,
      'ScheduleLogic': scheduleLogic,
      'Schedule': schedule,
    };
    await AbstractPersister.instance.writePrefs(jsonEncode(toSave));
  }

  Future<void> load() async {
    final String? savedCriteria = await AbstractPersister.instance.readPrefs();
    if (savedCriteria == null) {
      return;
    }
    final Map<String, dynamic> loadedCriteria = jsonDecode(savedCriteria);

    // Load campuses (with backward compatibility for single Campus)
    if (loadedCriteria.containsKey('Campuses')) {
      _campuses = (loadedCriteria['Campuses'] as List)
          .map((code) => Campus.fromCode(code))
          .where((c) => c != Campus.allCampuses())
          .toList();
    } else if (loadedCriteria.containsKey('Campus')) {
      final campus = Campus.fromCode(loadedCriteria['Campus']);
      _campuses = campus == Campus.allCampuses() ? [] : [campus];
    } else {
      _campuses = [];
    }

    // Load departments (with backward compatibility)
    if (loadedCriteria.containsKey('Departments')) {
      _departments = (loadedCriteria['Departments'] as List)
          .map((code) => Department.fromCode(code))
          .where((d) => d != Department.allDepartments())
          .toList();
    } else if (loadedCriteria.containsKey('Department')) {
      final dept = Department.fromCode(loadedCriteria['Department']);
      _departments = dept == Department.allDepartments() ? [] : [dept];
    } else {
      _departments = [];
    }

    // Load subjects (with backward compatibility)
    if (loadedCriteria.containsKey('Subjects')) {
      _subjects = (loadedCriteria['Subjects'] as List)
          .map((code) => Subject.fromCode(code))
          .where((s) => s != Subject.allSubjects())
          .toList();
    } else if (loadedCriteria.containsKey('Subject')) {
      final subj = Subject.fromCode(loadedCriteria['Subject']);
      _subjects = subj == Subject.allSubjects() ? [] : [subj];
    } else {
      _subjects = [];
    }

    _term = Term.fromCode(loadedCriteria['Term']) ?? Term.defaultTerm();
    _classNumber = loadedCriteria['Class Number'];

    // Load levels (with backward compatibility)
    if (loadedCriteria.containsKey('Levels')) {
      final levelsData = loadedCriteria['Levels'];
      if (levelsData is List) {
        _levels = List<String>.from(levelsData);
      } else if (levelsData is String) {
        _levels = levelsData.split(',').where((l) => l.isNotEmpty).toList();
      } else {
        _levels = ['Lower', 'Upper', 'Grad'];
      }
    } else if (loadedCriteria.containsKey('Level')) {
      final levelData = loadedCriteria['Level'];
      if (levelData is String) {
        _levels = levelData.split(',').where((l) => l.isNotEmpty).toList();
      } else {
        _levels = ['Lower', 'Upper', 'Grad'];
      }
    } else {
      _levels = ['Lower', 'Upper', 'Grad'];
    }

    // Load credits (with backward compatibility)
    if (loadedCriteria.containsKey('Credits')) {
      final creditsData = loadedCriteria['Credits'];
      if (creditsData is List) {
        _credits = List<String>.from(creditsData);
      } else if (creditsData is String) {
        _credits = creditsData.split(',').where((c) => c.isNotEmpty).toList();
      } else {
        _credits = ['0', '1', '2', '3', '4', '>4'];
      }
    } else {
      _credits = ['0', '1', '2', '3', '4', '>4'];
    }

    _isGS = loadedCriteria['GS'];
    _isOpen = loadedCriteria['Status'] ?? loadedCriteria['IsOpen'];
    _instructor = loadedCriteria['Instructor'];
    _scheduleLogic = loadedCriteria['ScheduleLogic'] ?? 'Any';
    _schedule = loadedCriteria['Schedule'] != null
        ? List<String>.from(loadedCriteria['Schedule'])
        : allClassDays;
    // startTime = null;
    // endTime = null;
    // notTaken = false;
    // freeClassrooms = false;
    return;
  }

  List<Class> savedClasses() {
    return classes.where((element) => element.saved).toList();
  }

  List<Class> savedClassesForScheduleTerm() {
    return savedClasses()
        .where((element) => element.term == scheduleTerm)
        .toList();
  }

  Future<void> update() async {
    await save();
    classes.clear();
    classes.addAll(Query().results().toList()..sort());
    notifyListeners();
  }
}
