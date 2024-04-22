import 'package:flutter/material.dart';
import 'package:schedule_client/domain/campus.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/domain/department.dart';
import 'package:schedule_client/domain/hourminute.dart';
import 'package:schedule_client/domain/query.dart';
import 'package:schedule_client/domain/subject.dart';
import 'package:schedule_client/domain/term.dart';
import 'package:schedule_client/views/multi_dropdown.dart';

class SearchCriteria extends ChangeNotifier {
  SearchCriteria(this.context);
  BuildContext context;
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
    'Instructor': '',
    'Schedule': <String>[],
    'Start Time': null,
    'End Time': null,
  };

  late Row sizingRow;
  final startYear = 2023;
  int _selectedIndex = 0;
  final List<String> keys = [];

  final List<Class> savedData = <Class>[];
  List<Class> scheduleData = <Class>[];
  List<Class> classes = <Class>[];

  void updateSchedule(Term term) {
    scheduleData = savedData.where((element) => element.term == term).toList();
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
    } else {
      savedData.remove(aClass);
      scheduleData.remove(aClass);
    }
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
    notifyListeners();
  }

  List<DropdownMenuEntry> dropdownEntries(String key) {
    final entries = <DropdownMenuEntry>[];
    Map<String, dynamic> map = {};

    switch (key) {
      case 'Campus':
        map = {for (final e in Campus.instances) '${e.code} ${e.name}': e};
        break;
      case 'Department':
        map = {for (final e in Department.instances) '${e.code} ${e.name}': e};
        break;
      case 'Subject':
        map = {for (final e in Subject.instances) '${e.code} ${e.name}': e};
        break;
      case 'Term':
        map = {for (final e in Term.instances) e.name: e};
        break;
      case 'Level':
        map = {
          'Any': 'Any',
          'Lower': 'Lower',
          'Upper': 'Upper',
          'Grad': 'Grad',
        };
        break;
      case 'Credits':
        map = {
          'Any': 'Any',
          '0': '0',
          '1': '1',
          '2': '2',
          '3': '3',
          '4': '4',
          '>4': '>4',
        };
        break;
      case 'Start Time':
        entries.add(const DropdownMenuEntry(value: null, label: 'Any Time'));
        for (HourMinute time = HourMinute(hour: 7, minute: 0);
            time <= HourMinute(hour: 20, minute: 0);
            time = time.add(const Duration(hours: 1))) {
          entries.add(
            DropdownMenuEntry(
              value: time,
              label: time.toString(is24hr: false),
            ),
          );
        }
        break;
      case 'End Time':
        entries.add(const DropdownMenuEntry(value: null, label: 'Any Time'));
        for (HourMinute time = HourMinute(hour: 7, minute: 50);
            time <= HourMinute(hour: 20, minute: 50);
            time = time.add(const Duration(hours: 1))) {
          entries.add(
            DropdownMenuEntry(
              value: time,
              label: time.toString(is24hr: false),
            ),
          );
        }
        break;
      default:
        assert(false);
    }
    if (map.isNotEmpty) {
      for (final key in map.keys) {
        entries.add(DropdownMenuEntry(value: map[key], label: key));
      }
    }
    return entries;
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

  Widget dropdownEntry(String keyString) {
    return Semantics(
      label: '$keyString Dropdown Menu',
      hint: 'Select a $keyString from the dropdown menu.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownMenu(
          menuHeight: 500,
          textStyle: const TextStyle(fontSize: 12),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            filled: true,
            fillColor: Color.fromARGB(255, 247, 246, 246),
          ),
          key: Key('$keyString Dropdown'),
          label: Text(
            keyString,
            style: const TextStyle(fontSize: 12),
          ),
          dropdownMenuEntries: dropdownEntries(keyString),
          initialSelection: _searchCriteria[keyString],
          onSelected: (value) {
            _searchCriteria[keyString] = value;
            doSearch();
          },
        ),
      ),
    );
  }

  List<Widget> gsSelector() {
    final widgets = <Widget>[];
    widgets.add(
      Semantics(
        label: 'Used to filter classes by General Studies.',
        hint: 'Check this box to filter classes by General Studies.',
        child: Checkbox(
          key: const Key('GS Checkbox'),
          value: _searchCriteria['GS'],
          onChanged: (bool? value) {
            _searchCriteria['GS'] = value!;
            doSearch();
          },
        ),
      ),
    );
    widgets.add(const Text('Only GS'));
    return widgets;
  }

  List<Widget> statusSelector() {
    final widgets = <Widget>[];
    widgets.add(
      Semantics(
        label: 'Used to filter classes by Open status.',
        hint: 'Check this box to filter classes by Open status.',
        child: Checkbox(
          key: const Key('Status Checkbox'),
          value: _searchCriteria['Status'],
          onChanged: (bool? value) {
            _searchCriteria['Status'] = value!;
            doSearch();
          },
        ),
      ),
    );
    widgets.add(const Text('Only Open'));
    return widgets;
  }

  Widget instructorTextField() {
    return Semantics(
      label: 'Used to search for a class by the instructor.',
      hint: 'Enter the name of an instructor to search.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          key: const Key('Instructor Text Box'),
          width: 100,
          height: 50,
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 247, 246, 246),
              labelText: 'Instructor',
              labelStyle: TextStyle(fontSize: 12),
            ),
            initialValue: _searchCriteria['Instructor'],
            onChanged: (value) {
              if (value.isNotEmpty) {
                _searchCriteria['Instructor'] = value;
              } else if (value.isEmpty) {
                _searchCriteria['Instructor'] = '';
              }
              doSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget classNumberTextField() {
    return Semantics(
      label: 'Used to search for a class by the class number.',
      hint: 'Enter a four digit number to search.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          key: const Key('Class Number Text Box'),
          width: 100,
          height: 50,
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 247, 246, 246),
              labelText: 'Class Number',
              labelStyle: TextStyle(fontSize: 12),
            ),
            initialValue: _searchCriteria['Class Number'] == 0
                ? ''
                : _searchCriteria['Class Number'].toString(),
            onChanged: (value) {
              if (value.length == 4) {
                try {
                  _searchCriteria['Class Number'] = int.parse(value);
                } on FormatException {
                  _searchCriteria['Class Number'] = 0;
                }
              } else if (value.isEmpty) {
                _searchCriteria['Class Number'] = 0;
              }
              doSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget searchCriteriaWidget() {
    scheduleData = savedData
        .where((element) => element.term == Term.instances.elementAt(2))
        .toList();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      key: const Key('Search Criteria Widget'),
      spacing: 8,
      runSpacing: 8,
      children: [
        classNumberTextField(),
        dropdownEntry('Department'),
        dropdownEntry('Subject'),
        dropdownEntry('Campus'),
        dropdownEntry('Level'),
        instructorTextField(),
        dropdownEntry('Term'),
        dropdownEntry('Credits'),
        selectWeekdays(),
        dropdownEntry('Start Time'),
        dropdownEntry('End Time'),
        ...statusSelector(),
        ...gsSelector(),
      ],
    );
  }
}
