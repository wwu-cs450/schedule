import 'dart:async';
import 'dart:convert';

import 'package:client/domain/campus.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/prefs.dart';
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
    reset();
  }

  // Singleton instance
  static Filters? _instance;

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

  // Setters
  Future<void> setCampus(Campus value) async {
    _campus = value;
    await save();
    notifyListeners();
  }

  Future<void> setDepartment(Department value) async {
    _department = value;
    await save();
    notifyListeners();
  }

  Future<void> setSubject(Subject value) async {
    _subject = value;
    await save();
    notifyListeners();
  }

  Future<void> setTerm(Term value) async {
    _term = value;
    await save();
    notifyListeners();
  }

  Future<void> setClassNumber(int value) async {
    _classNumber = value;
    await save();
    notifyListeners();
  }

  Future<void> setLevel(String value) async {
    _level = value;
    await save();
    notifyListeners();
  }

  Future<void> setCredits(String value) async {
    _credits = value;
    await save();
    notifyListeners();
  }

  Future<void> setIsGS(bool value) async {
    _isGS = value;
    await save();
    notifyListeners();
  }

  Future<void> setIsOpen(bool value) async {
    _isOpen = value;
    await save();
    notifyListeners();
  }

  Future<void> setInstructor(String value) async {
    _instructor = value;
    await save();
    notifyListeners();
  }

  Future<void> setSchedule(List<String> value) async {
    _schedule = value;
    await save();
    notifyListeners();
  }

  Future<void> setStartTime(HourMinute? value) async {
    _startTime = value;
    await save();
    notifyListeners();
  }

  Future<void> setEndTime(HourMinute? value) async {
    _endTime = value;
    await save();
    notifyListeners();
  }

  Future<void> setIsNotTaken(bool value) async {
    _isNotTaken = value;
    await save();
    notifyListeners();
  }

  Future<void> setIsFreeClassrooms(bool value) async {
    _isFreeClassrooms = value;
    await save();
    notifyListeners();
  }

  void reset() {
    _campus = Campus.allCampuses();
    _department = Department.allDepartments();
    _subject = Subject.allSubjects();
    _term = Term.allTerms();
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
    notifyListeners();
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
    _term = Term.fromCode(loadedCriteria['Term']);
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
}
