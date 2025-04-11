import 'dart:async';
import 'dart:convert';

import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/prefs.dart';
import 'package:client/domain/query.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';

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

  late Campus _campus;
  late Department _department;
  late Subject _subject;
  late Term _term;
  late int _classNumber;
  late String _level;
  late String _credits;
  late bool _isGS;
  late bool _isOpen;
  late String _instructor;
  late List<String> _schedule;
  late HourMinute? _startTime;
  late HourMinute? _endTime;
  late bool _isNotTaken;
  late bool _isFreeClassrooms;

  // Getters
  Campus get campus => _campus;
  Department get department => _department;
  Subject get subject => _subject;
  Term get term => _term;
  int get classNumber => _classNumber;
  String get level => _level;
  String get credits => _credits;
  bool get isGS => _isGS;
  bool get isOpen => _isOpen;
  String get instructor => _instructor;
  List<String> get schedule => _schedule;
  HourMinute? get startTime => _startTime;
  HourMinute? get endTime => _endTime;
  bool get isNotTaken => _isNotTaken;
  bool get isFreeClassrooms => _isFreeClassrooms;

  Term get scheduleTerm {
    if (_scheduleTerm == null) {
      Set terms = savedClasses().map((e) => e.term).toSet();
      if (terms.isEmpty) {
        terms = Term.instances;
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
  Future<void> setCampus(Campus value) async {
    _campus = value;
    await update();
  }

  Future<void> setDepartment(Department value) async {
    _department = value;
    await update();
  }

  Future<void> setSubject(Subject value) async {
    _subject = value;
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

  Future<void> setLevel(String value) async {
    _level = value;
    await update();
  }

  Future<void> setCredits(String value) async {
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

  Future<void> reset() async {
    _reset();
    await update();
  }

  void _reset() {
    _campus = Campus.allCampuses();
    _department = Department.allDepartments();
    _subject = Subject.allSubjects();
    _term = Term.defaultTerm();
    _classNumber = 0;
    _level = 'Any';
    _credits = 'Any';
    _isGS = false;
    _isOpen = false;
    _instructor = '';
    _schedule = <String>[];
    _startTime = null;
    _endTime = null;
    _isNotTaken = false;
    _isFreeClassrooms = false;
  }

  static void clearInstance() {
    _instance = null;
  }

  Future<void> save() async {
    final Map<String, dynamic> toSave = {
      'Campus': campus.code,
      'Department': department.code,
      'Subject': subject.code,
      'Term': term.code,
      'Class Number': classNumber,
      'Level': level,
      'Credits': credits,
      'GS': isGS,
      'IsOpen': isOpen,
      'Instructor': instructor,
      // 'Schedule': <String>[],
      // 'Start Time': null,
      // 'End Time': null,
      // 'Not Taken': false,
      // 'Free Classrooms': false,
    };
    await AbstractPrefs.instance.writePrefs(jsonEncode(toSave));
  }

  Future<void> load() async {
    final String? savedCriteria = await AbstractPrefs.instance.readPrefs();
    if (savedCriteria == null) {
      return;
    }
    final Map<String, dynamic> loadedCriteria = jsonDecode(savedCriteria);
    _campus = Campus.fromCode(loadedCriteria['Campus']);
    _department = Department.fromCode(loadedCriteria['Department']);
    _subject = Subject.fromCode(loadedCriteria['Subject']);
    _term = Term.fromCode(loadedCriteria['Term']) ?? Term.defaultTerm();
    _classNumber = loadedCriteria['Class Number'];
    _level = loadedCriteria['Level'];
    _credits = loadedCriteria['Credits'];
    _isGS = loadedCriteria['GS'];
    _isOpen = loadedCriteria['Status'] ?? loadedCriteria['IsOpen'];
    _instructor = loadedCriteria['Instructor'];
    // schedule.clear();
    // for (final each in loadedCriteria['Schedule']) {
    //   schedule.add(each);
    // }
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
