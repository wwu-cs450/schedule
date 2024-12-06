import 'dart:convert';

import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/query.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:client/views/multi_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as a;

class SearchCriteria extends ChangeNotifier {
  SearchCriteria(this.context);
  BuildContext context;
  late List<Widget> criteria;
  final Map<String, dynamic> _searchCriteria = {
    'Campus': Campus.allCampuses(),
    'Department': Department.allDepartments(),
    'Subject': Subject.allSubjects(),
    'Term': Term.allTerms(),
    'Class Number': 0,
    'Level': 'Any',
    'Credits': 'Any',
    'GS': false,
    'Status': false,
    'Free Classrooms': false,
    'Instructor': '',
    'Schedule': <String>[],
    'Start Time': null,
    'End Time': null,
  };

  bool scheduleDownloaded = false;

  Term? _scheduleTerm;
  List<Class> scheduleData = <Class>[];

  Term get scheduleTerm {
    if (_scheduleTerm != null) {
      return _scheduleTerm!;
    }
    if (scheduleData.isNotEmpty) {
      return getTermForSchedule(scheduleData);
    }
    return Term.instances.elementAt(3);
  }

  set scheduleTerm(Term term) {
    _scheduleTerm = term;
  }

  Term getTermForSchedule(List<Class> scheduleData) {
    if (scheduleData.isNotEmpty) {
      final Term firstTerm = scheduleData.first.term;

      if (!scheduleData.contains(scheduleData.first)) {
        for (var i = 1; i < scheduleData.length; i++) {
          if (scheduleData[i].term != firstTerm) {
            return scheduleData[i].term;
          }
        }
      }
      return firstTerm;
    }
    return Term.instances.elementAt(3);
  }

  final startTimes = {
    'Any Time': null,
    for (HourMinute time = HourMinute(hour: 7, minute: 0);
        time <= HourMinute(hour: 20, minute: 0);
        time = time.add(const Duration(hours: 1)))
      time.toString(is24hr: false): time,
  };

  void saveTextFile(String text, String filename) {
    a.AnchorElement()
      // ignore: unsafe_html
      ..href =
          '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: utf8)}'
      ..download = filename
      ..style.display = 'none'
      ..click();
    scheduleDownloaded = true;
    notifyListeners();
  }

  final endTimes = {
    'Any Time': null,
    for (HourMinute time = HourMinute(hour: 7, minute: 50);
        time <= HourMinute(hour: 20, minute: 50);
        time = time.add(const Duration(hours: 1)))
      time.toString(is24hr: false): time,
  };

  late Row sizingRow;
  late List<bool> smallRowInfo;
  int _selectedIndex = 0;
  final List<String> keys = [];

  final List<Class> savedData = <Class>[];
  List<Class> classes = <Class>[];

  Widget? sidebar;

  void createDrawer() {
    criteria = getCriteria();
    sidebar = SizedBox(
      width: 216,
      child: Drawer(
        key: const Key('Search Criteria Drawer'),
        backgroundColor: const Color(0xFFa8ac9c),
        child: ListView(children: criteria),
      ),
    );
    notifyListeners();
  }

  void updateInfo(int index) {
    smallRowInfo[index] = !smallRowInfo[index];
    notifyListeners();
  }

  List<Widget> getCriteria() {
    return [
      textForm(key: 'Class Number', width: 100),
      menu(
        key: 'Department',
        items: {
          for (final e in Department.instances) '${e.code} ${e.name}': e,
        },
        selection: _searchCriteria['Department'],
        width: 200,
      ),
      menu(
        key: 'Subject',
        items: {for (final e in Subject.instances) '${e.code} ${e.name}': e},
        selection: _searchCriteria['Subject'],
        width: 200,
      ),
      menu(
        key: 'Campus',
        items: {for (final e in Campus.instances) '${e.code} ${e.name}': e},
        selection: _searchCriteria['Campus'],
        width: 200,
      ),
      menu(
        key: 'Level',
        items: {
          'Any Level': 'Any',
          'Lower (100-299)': 'Lower',
          'Upper (300-499)': 'Upper',
          'Grad (500+)': 'Grad',
        },
        selection: _searchCriteria['Level'],
        width: 200,
      ),
      textForm(key: 'Instructor', width: 100),
      menu(
        key: 'Term',
        items: {for (final e in Term.instances) e.name: e},
        selection: _searchCriteria['Term'],
        width: 200,
      ),
      menu(
        key: 'Credits',
        items: {
          'Any Credit': 'Any',
          '0 Cr': '0',
          '1 Cr': '1',
          '2 Cr': '2',
          '3 Cr': '3',
          '4 Cr': '4',
          '>4 Cr': '>4',
        },
        selection: _searchCriteria['Credits'],
        width: 200,
      ),
      selectWeekdays(),
      menu(
        key: 'Start Time',
        items: startTimes,
        selection: _searchCriteria['Start Time'],
        width: 200,
      ),
      menu(
        key: 'End Time',
        items: endTimes,
        selection: _searchCriteria['End Time'],
        width: 200,
      ),
      selector(key: 'GS'),
      selector(key: 'Status'),
      selector(key: 'Free Classrooms'),
    ];
  }

  void updateSchedule(Term term) {
    scheduleData = savedData.where((element) => element.term == term).toList();
    scheduleTerm = term;
    notifyListeners();
  }

  final inputList = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
  };

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void saveClass(
    Class aClass,
    bool shouldSave,
  ) {
    aClass.saved = shouldSave;
    if (shouldSave) {
      savedData.add(aClass);
      scheduleData.add(aClass);
    } else {
      savedData.remove(aClass);
      scheduleData.remove(aClass);
    }

    if (_scheduleTerm == null ||
        !savedData.any((element) => element.term == _scheduleTerm)) {
      _scheduleTerm = savedData.isNotEmpty ? savedData.first.term : null;
    }

    scheduleData =
        savedData.where((element) => element.term == scheduleTerm).toList();
    notifyListeners();
  }

  void doSearch() {
    classes = Query(
      department: _searchCriteria['Department'],
      subject: _searchCriteria['Subject'],
      term: _searchCriteria['Term'],
      campus: _searchCriteria['Campus'],
      classNumber: _searchCriteria['Class Number'],
      level: _searchCriteria['Level'],
      credits: _searchCriteria['Credits'],
      gs: _searchCriteria['GS'],
      status: _searchCriteria['Status'],
      instructor: _searchCriteria['Instructor'],
      scheduledDays: _searchCriteria['Schedule'],
      startTime: _searchCriteria['Start Time'],
      endTime: _searchCriteria['End Time'],
    ).results().toList();
    classes.sort();
    smallRowInfo = List.generate(classes.length, (index) => false);
    createDrawer();
  }

  Widget selectWeekdays() {
    return Semantics(
      label: 'Used to filter classes by days of the week.',
      hint: 'Select the days of the week to filter classes.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          key: const Key('Schedule Dropdown'),
          height: 50,
          child: MultiSelectDropdown(
            context: context,
            width: 200,
            allItems: inputList.keys.toList(),
            selectedItems: _searchCriteria['Schedule'],
            label: 'Weekdays',
            onChanged: () {
              doSearch();
            },
          ).build(),
        ),
      ),
    );
  }

  Widget selector({required String key}) {
    return SizedBox(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Semantics(
            label: 'Used to filter classes by General Studies.',
            hint: 'Check this box to filter classes by General Studies.',
            child: Checkbox(
              key: Key('$key Checkbox'),
              value: _searchCriteria[key],
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF656950); // Color when selected
                }
                return Colors.white; // White background when unselected
              }),
              checkColor: Colors.white, // Ensures checkmark is visible on white
              onChanged: (bool? value) {
                _searchCriteria[key] = value!;
                doSearch();
              },
            ),
          ),
          Text('Only ${key == 'Status' ? 'Open' : key}'),
        ],
      ),
    );
  }

  Widget textForm({required String key, required double width}) {
    return Semantics(
      label: 'Used to search for a class by the $key.',
      hint: 'Enter text here to search.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          key: Key('$key Text Box'),
          width: width,
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 247, 246, 246),
              labelText: key,
              labelStyle: const TextStyle(fontSize: 14),
            ),
            initialValue: key == 'Class Number'
                ? _searchCriteria[key] == 0
                    ? ''
                    : _searchCriteria[key].toString()
                : _searchCriteria[key],
            onChanged: (value) {
              if (key == 'Class Number') {
                if (value.length == 4) {
                  try {
                    _searchCriteria[key] = int.parse(value);
                  } on FormatException {
                    _searchCriteria[key] = 0;
                  }
                  doSearch();
                } else if (value.isEmpty) {
                  _searchCriteria[key] = 0;
                  doSearch();
                }
              } else {
                if (value.isNotEmpty) {
                  _searchCriteria[key] = value;
                } else if (value.isEmpty) {
                  _searchCriteria[key] = '';
                }
                doSearch();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget menu({
    required String key,
    required Map<String, dynamic> items,
    required double width,
    required dynamic selection,
  }) {
    return Semantics(
      hint: 'Select a $key from the dropdown menu.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownMenu(
          requestFocusOnTap: true,
          width: width,
          menuHeight: 500,
          textStyle: const TextStyle(fontSize: 14),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            filled: true,
            fillColor: Color.fromARGB(255, 247, 246, 246),
          ),
          key: Key('$key Dropdown'),
          label: Text(
            key,
            style: const TextStyle(fontSize: 14),
          ),
          dropdownMenuEntries: [
            for (final val in items.values)
              DropdownMenuEntry(
                value: val,
                label:
                    items.entries.firstWhere((entry) => entry.value == val).key,
              ),
          ],
          initialSelection: selection,
          onSelected: (value) {
            _searchCriteria[key] = value;
            doSearch();
          },
          /*
          The searchCallback is just a temporary patch until Flutter fixes the
          issue mentioned in #129
          */
          searchCallback: (entries, query) {
            if (query.isEmpty) {
              return null;
            }
            final int index = entries.indexWhere(
              (DropdownMenuEntry<dynamic> entry) =>
                  entry.label.toLowerCase().contains(query.toLowerCase()),
            );

            return index != -1 ? index : null;
          },
        ),
      ),
    );
  }
}
