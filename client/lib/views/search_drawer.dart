import 'dart:math';

import 'package:client/domain/campus.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:client/views/multi_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchDrawer extends StatelessWidget {
  const SearchDrawer({super.key});

  // This seems to take a while, but timing shows only 3ms
  List<Widget> _allFilters(BuildContext context) {
    final classNumber = Filters().classNumber.toString();
    return [
      _searchHeading(),
      _classNumberField(classNumber),
      _departmentDropdown(),
      _subjectDropdown(),
      _campusDropdown(),
      _levelDropdown(),
      _instructorField(),
      _termDrowdown(),
      _creditsDropdown(),
      _weekdaysDropdown(context),
      _startTimeDropdown(),
      _endTimeDropdown(),
      _isGsCheckbox(),
      _isOpenCheckbox(),
      _isNotTakenCheckbox(),
      _freeClassroomsCheckbox(),
      _clearFiltersButton(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Filters>(
      builder: (context, filters, child) {
        return SizedBox(
          width: 216,
          child: Drawer(
            key: const Key('Search Criteria Drawer'),
            backgroundColor: const Color(0xFFa8ac9c),
            child: ListView(children: _filters(context)),
          ),
        );
      },
    );
  }

  Widget _campusDropdown() {
    return _dropdown(
      key: 'Campus',
      width: 200,
      items: {for (final e in Campus.instances) '${e.code} ${e.name}': e},
      selection: Filters().campus,
      onSelected: (value) async {
        await Filters().setCampus(value);
      },
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

  Widget _classNumberField(String classNumber) {
    return _textField(
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
      },
    );
  }

  Widget _clearFiltersButton() {
    final buttonColor = const Color.fromARGB(255, 255, 229, 238);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        key: const Key('Clear Filters Button'),
        onPressed: () async {
          await Filters().reset();
        },
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
        child: Text(
          'Clear Filters',
          style: TextStyle(color: Colors.black), // Set the text color to black
        ),
      ),
    );
  }

  Widget _creditsDropdown() {
    return _dropdown(
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
      },
    );
  }

  Widget _departmentDropdown() {
    return _dropdown(
      key: 'Department',
      width: 200,
      items: {for (final e in Department.instances) '${e.code} ${e.name}': e},
      selection: Filters().department,
      onSelected: (value) async {
        await Filters().setDepartment(value);
      },
    );
  }

  Widget _dropdown({
    required String key,
    required Map<String, dynamic> items,
    required double width,
    required dynamic selection,
    required onSelected,
  }) {
    final entries = <DropdownMenuEntry>[];
    for (final entry in items.entries) {
      entries.add(
        DropdownMenuEntry(
          value: entry.value,
          label: entry.key,
          labelWidget: Row(
            children: [
              Expanded(
                child: Text(entry.key, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      );
    }
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
              borderSide: BorderSide(color: Colors.black),
            ),
            filled: true,
            fillColor: Color.fromARGB(255, 247, 246, 246),
          ),
          key: Key('$key Dropdown'),
          label: Text(key, style: const TextStyle(fontSize: 14)),
          dropdownMenuEntries: entries,
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

  Widget _endTimeDropdown() {
    return _dropdown(
      key: 'End Time',
      width: 200,
      items: _endTimes,
      selection: Filters().endTime,
      onSelected: (value) async {
        await Filters().setEndTime(value);
      },
    );
  }

  Map<String, HourMinute?> get _endTimes {
    return {
      'Any Time': null,
      for (
        HourMinute time = HourMinute(hour: 7, minute: 50);
        time <= HourMinute(hour: 20, minute: 50);
        time = time.add(const Duration(hours: 1))
      )
        time.toString(is24hr: false): time,
    };
  }

  List<Widget> _filters(BuildContext context) {
    return Filters().isFreeClassrooms
        ? _freeClassroomFilters(context)
        : _allFilters(context);
  }

  List<Widget> _freeClassroomFilters(BuildContext context) {
    return [
      _termDrowdown(),
      _weekdaysDropdown(context),
      _startTimeDropdown(),
      _endTimeDropdown(),
      _freeClassroomsCheckbox(),
    ];
  }

  Widget _freeClassroomsCheckbox() {
    return _checkbox(
      key: 'Free Classrooms',
      value: Filters().isFreeClassrooms,
      onChanged: () async {
        await Filters().setIsFreeClassrooms(!Filters().isFreeClassrooms);
      },
    );
  }

  Widget _instructorField() {
    return _textField(
      key: 'Instructor',
      width: 100,
      value: Filters().instructor,
      onChanged: (value) async {
        await Filters().setInstructor(value);
      },
    );
  }

  Widget _isGsCheckbox() {
    return _checkbox(
      key: 'General Studies',
      value: Filters().isGS,
      onChanged: () async {
        await Filters().setIsGS(!Filters().isGS);
      },
    );
  }

  Widget _isNotTakenCheckbox() {
    return _checkbox(
      key: 'Not Taken',
      value: Filters().isNotTaken,
      onChanged: () async {
        await Filters().setIsNotTaken(!Filters().isNotTaken);
      },
    );
  }

  Widget _isOpenCheckbox() {
    return _checkbox(
      key: 'Is Open',
      value: Filters().isOpen,
      onChanged: () async {
        await Filters().setIsOpen(!Filters().isOpen);
      },
    );
  }

  Widget _levelDropdown() {
    return _dropdown(
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
      },
    );
  }

  Padding _searchHeading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Search Criteria', style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _startTimeDropdown() {
    return _dropdown(
      key: 'Start Time',
      width: 200,
      items: startTimes,
      selection: Filters().startTime,
      onSelected: (value) async {
        await Filters().setStartTime(value);
      },
    );
  }

  Map<String, HourMinute?> get startTimes {
    return {
      'Any Time': null,
      for (
        HourMinute time = HourMinute(hour: 7, minute: 0);
        time <= HourMinute(hour: 20, minute: 0);
        time = time.add(const Duration(hours: 1))
      )
        time.toString(is24hr: false): time,
    };
  }

  Widget _subjectDropdown() {
    return _dropdown(
      key: 'Subject',
      width: 200,
      items: {for (final e in Subject.instances) '${e.code} ${e.name}': e},
      selection: Filters().subject,
      onSelected: (value) async {
        await Filters().setSubject(value);
      },
    );
  }

  Widget _termDrowdown() {
    return _dropdown(
      key: 'Term',
      width: 200,
      items: {for (final e in Term.instances) e.name: e},
      selection: Filters().term,
      onSelected: (value) async {
        await Filters().setTerm(value);
      },
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

  Widget _weekdaysDropdown(BuildContext context) {
    final inputList = {
      'Sunday': false,
      'Monday': false,
      'Tuesday': false,
      'Wednesday': false,
      'Thursday': false,
      'Friday': false,
    };
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
              // doSearch();
            },
          ).build(),
        ),
      ),
    );
  }
}
