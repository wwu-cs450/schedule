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
  Campus _campus = Campus.allCampuses();
  Department _department = Department.allDepartments();
  Subject _subject = Subject.allSubjects();
  Term _term = Term.allTerms();
  int _classNumber = 0;
  String _levelString = '';
  String _creditString = '';
  bool _gsFlag = false;
  bool _statusFlag = false;
  String _instructorString = '';

  final List<String> _scheduleList = [];

  HourMinute? _startTime;
  HourMinute? _endTime;

  late Row sizingRow;
  final startYear = 2023;
  int _selectedIndex = 0; // Page Index
  final List<String> keys = [];

  final List<Class> savedData = <Class>[];
  List<Class> classes = <Class>[];

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
    }
    notifyListeners();
  }

  void doSearch() {
    classes = Query(
      department: _department,
      subject: _subject,
      term: _term,
      campus: _campus,
      classNumber: _classNumber,
      level: _levelString,
      credits: _creditString,
      gs: _gsFlag,
      status: _statusFlag,
      instructor: _instructorString,
      scheduledDays: _scheduleList,
      startTime: _startTime,
      endTime: _endTime,
    ).results().toList();
    classes.sort();
    notifyListeners();
  }

  // We will need to adjust this in the future, but for now it isn't used.
  // void inputQuarters() {
  //   final List<Class> classData = Query(
  //     department: _department,
  //     subject: _subject,
  //     term: _term,
  //     campus: _campus,
  //   ).results().toList();
  //   startYear = int.parse(classData.first.term.code.toString().substring(1, 3));
  //   for (final aClass in classData) {
  //     final code = int.parse(aClass.term.code.toString().substring(1, 3));
  //     if (code.compareTo(startYear) < 0) {
  //       startYear = code;
  //     }
  //   }
  // }

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
        map = {for (final e in Term.instances) '${e.code} ${e.name}': e};
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
            selectedItems: _scheduleList,
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
          key: Key('$keyString Dropdown'),
          label: Text(
            keyString,
            style: const TextStyle(fontSize: 12),
          ),
          dropdownMenuEntries: dropdownEntries(keyString),
          onSelected: (value) {
            switch (keyString) {
              case 'Campus':
                _campus = value;
                break;
              case 'Department':
                _department = value;
                break;
              case 'Subject':
                _subject = value;
                break;
              case 'Term':
                _term = value;
                break;
              case 'Level':
                _levelString = value;
                break;
              case 'Credits':
                _creditString = value;
                break;
              case 'Start Time':
                _startTime = value;
                break;
              case 'End Time':
                _endTime = value;
            }
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
          value: _gsFlag,
          onChanged: (bool? value) {
            _gsFlag = value!;
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
          value: _statusFlag,
          onChanged: (bool? value) {
            _statusFlag = value!;
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
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Instructor',
              labelStyle: TextStyle(fontSize: 12),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _instructorString = value;
              } else if (value.isEmpty) {
                _instructorString = '';
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
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Class Number',
              labelStyle: TextStyle(fontSize: 12),
            ),
            onChanged: (value) {
              if (value.length == 4) {
                try {
                  _classNumber = int.parse(value);
                } on FormatException {
                  _classNumber = 0;
                }
              } else if (value.isEmpty) {
                _classNumber = 0;
              }
              doSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget searchCriteriaWidget() {
    return Wrap(
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
