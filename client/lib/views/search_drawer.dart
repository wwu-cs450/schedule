import 'dart:convert';

import 'package:client/domain/campus.dart';
import 'package:client/domain/class.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/query.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:client/main.dart';
import 'package:client/views/multi_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as a;

class SearchCriteriaView extends ChangeNotifier {
  SearchCriteriaView(this.context);

  BuildContext context;
  late List<Widget> criteria;

  Future<void> _updateSearchCriteria() async {
    doSearch();
    notifyListeners();
  }

  bool get isFreeClassroomsOnly => Filters().isFreeClassrooms;

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

  late Widget sidebar;

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

  void deselectAllTerms() {
    for (final aClass in scheduleData) {
      aClass.saved = false;
    }
    savedData.clear();
    scheduleData.clear();
    _scheduleTerm = null;
    notifyListeners();
  }

  void updateInfo(int index) {
    smallRowInfo[index] = !smallRowInfo[index];
    notifyListeners();
  }

  List<Widget> getCriteria() {
    final classNumber = Filters().classNumber.toString();
    return [
      !results.isFreeClassroomsOnly
          ? _textField(
              key: 'Class Number',
              width: 100,
              value: classNumber == '0' ? '' : classNumber,
              onChanged: (value) async {
                var classNumber = 0;
                if (value.length == 4) {
                  try {
                    classNumber = int.parse(value);
                  } on FormatException {
                    // not a number
                  }
                }
                await Filters().setClassNumber(classNumber);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _dropdown(
              key: 'Department',
              width: 200,
              items: {
                for (final e in Department.instances) '${e.code} ${e.name}': e,
              },
              selection: Filters().department,
              onSelected: (value) async {
                await Filters().setDepartment(value);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _dropdown(
              key: 'Subject',
              width: 200,
              items: {
                for (final e in Subject.instances) '${e.code} ${e.name}': e,
              },
              selection: Filters().subject,
              onSelected: (value) async {
                await Filters().setSubject(value);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _dropdown(
              key: 'Campus',
              width: 200,
              items: {
                for (final e in Campus.instances) '${e.code} ${e.name}': e,
              },
              selection: Filters().campus,
              onSelected: (value) async {
                await Filters().setCampus(value);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _dropdown(
              key: 'Level',
              width: 200,
              items: {
                'Any Level': 'Any',
                'Lower (100-299)': 'Lower',
                'Upper (300-499)': 'Upper',
                'Grad (500+)': 'Grad',
              },
              selection: Filters().level,
              onSelected: (value) async {
                await Filters().setLevel(value);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _textField(
              key: 'Instructor',
              width: 100,
              value: Filters().instructor,
              onChanged: (value) async {
                await Filters().setInstructor(value);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      _dropdown(
        key: 'Term',
        width: 200,
        items: {for (final e in Term.instances) e.name: e},
        selection: Filters().term,
        onSelected: (value) async {
          await Filters().setTerm(value);
          await _updateSearchCriteria();
        },
      ),
      !results.isFreeClassroomsOnly
          ? _dropdown(
              key: 'Credits',
              width: 200,
              items: {
                'Any Credit': 'Any',
                '0 Cr': '0',
                '1 Cr': '1',
                '2 Cr': '2',
                '3 Cr': '3',
                '4 Cr': '4',
                '>4 Cr': '>4',
              },
              selection: Filters().credits,
              onSelected: (value) async {
                await Filters().setCredits(value);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      selectWeekdays(),
      _dropdown(
        key: 'Start Time',
        width: 200,
        items: startTimes,
        selection: Filters().startTime,
        onSelected: (value) async {
          await Filters().setStartTime(value);
          await _updateSearchCriteria();
        },
      ),
      _dropdown(
        key: 'End Time',
        width: 200,
        items: endTimes,
        selection: Filters().endTime,
        onSelected: (value) async {
          await Filters().setEndTime(value);
          await _updateSearchCriteria();
        },
      ),
      !results.isFreeClassroomsOnly
          ? _checkbox(
              key: 'General Studies',
              value: Filters().isGS,
              onChanged: () async {
                await Filters().setIsGS(!Filters().isGS);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _checkbox(
              key: 'Is Open',
              value: Filters().isOpen,
              onChanged: () async {
                await Filters().setIsOpen(!Filters().isOpen);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      !results.isFreeClassroomsOnly
          ? _checkbox(
              key: 'Not Taken',
              value: Filters().isNotTaken,
              onChanged: () async {
                await Filters().setIsNotTaken(!Filters().isNotTaken);
                await _updateSearchCriteria();
              },
            )
          : Container(),
      _checkbox(
        key: 'Free Classrooms',
        value: Filters().isFreeClassrooms,
        onChanged: () async {
          await Filters().setIsFreeClassrooms(!Filters().isFreeClassrooms);
          await _updateSearchCriteria();
        },
      ),
      clearFiltersButton(),
    ];
  }

  Widget clearFiltersButton() {
    final buttonColor = const Color.fromARGB(255, 255, 229, 238);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        key: const Key('Clear Filters Button'),
        onPressed: () {
          Filters().reset();
          doSearch();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        child: Text(
          'Clear Filters',
          style: TextStyle(color: Colors.black), // Set the text color to black
        ),
      ),
    );
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
      searchCriteria: Filters(),
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
            selectedItems: Filters().schedule,
            onChanged: () {
              doSearch();
            },
          ).build(),
        ),
      ),
    );
  }

  Widget _checkbox({
    required String key,
    required bool value,
    required onChanged,
  }) {
    return SizedBox(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Semantics(
            label: 'Used to filter classes by $key.',
            hint: 'Check this box to filter classes by $key.',
            child: Checkbox(
              key: Key('$key Checkbox'),
              value: value,
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF656950); // Color when selected
                }
                return Colors.white; // White background when unselected
              }),
              checkColor: Colors.white, // Ensures checkmark is visible on white
              onChanged: (bool? value) async {
                await onChanged();
              },
            ),
          ),
          Text(key),
        ],
      ),
    );
  }

  Widget _textField({
    required String key,
    required double width,
    required value,
    required onChanged,
  }) {
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
              labelStyle: const TextStyle(fontSize: 12),
            ),
            initialValue: value,
            onChanged: (value) async {
              await onChanged(value);
            },
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String key,
    required Map<String, dynamic> items,
    required double width,
    required dynamic selection,
    required onSelected,
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
          onSelected: (value) async {
            await onSelected(value);
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
