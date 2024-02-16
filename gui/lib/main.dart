import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gui/campus.dart';
import 'package:gui/class.dart';
import 'package:gui/data_handler.dart';
import 'package:gui/department.dart';
import 'package:gui/hourminute.dart';
import 'package:gui/query.dart';
import 'package:gui/subject.dart';
import 'package:gui/term.dart';
import 'package:multiselect/multiselect.dart';

void main() async {
  await DataHandler.fetchData();
  Class.instances;
  runApp(const MyApp());
  SemanticsBinding.instance.ensureSemantics();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WWU Class Schedule',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF656950),
          primary: const Color(0xFF656950),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'WWU Class Schedule'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  List<String> _scheduleList = [];
  HourMinute? _startTime;
  HourMinute? _endTime;

  final List<Class> _savedData = <Class>[]; // Saved class data
  List<Class> _classes = <Class>[];
  late Row sizingRow;
  Map<String, int> palette = {
    'green': 0xFF656950,
    'brown': 0xFF796249,
    'orange': 0xFFC36D2A,
    'tan': 0xFFC7AE86,
    'blue': 0xFF667FA4,
    'grey-brown': 0xFF877465,
    'brick-red': 0xFF961400,
  };
  final startYear = 2023;
  final List<String> keys = [];
  int selectedIndex = 0; // Page Index
  int lineHeight = 1;

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

  void doSearch() {
    _classes = Query(
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
    _classes.sort();
  }

  List<int> getColor(int index) {
    if (index % 2 == 0) {
      return [0xFFc2c2c2, 0xFFf1f276, 0xFFf2b600, 0xFF8ca2bd, 0xFF53b573];
    } else {
      return [0xFFdbdbdb, 0xFFfeffa4, 0xFFffd34d, 0xFFb4c4d8, 0xFF8ad2a1];
    }
  }

  int getLineHeight(Class aClass) {
    return max(
      max(
        aClass.schedule.toString().split('\n').length,
        aClass.classroom.split('\n').length,
      ),
      aClass.getInstructors().split('\n').length,
    );
  }

  String addLinesTo(String aString) {
    final initialCount = aString.split('\n').length;
    var result = aString;
    for (var i = initialCount; i < lineHeight; i++) {
      result += '\n';
    }
    return result.isNotEmpty ? result : ' ';
  }

  String getTerm(Class aClass, String key) {
    if (aClass.term.name == key) {
      return aClass.course.number;
    } else {
      return ' ';
    }
  }

  Widget savedBox(Class aClass) {
    return Semantics(
      label: 'Class saving checkbox.',
      hint: 'Click on this to save a class for later.',
      child: SizedBox(
        height: 10,
        width: 30,
        child: Checkbox(
          value: aClass.saved,
          onChanged: (bool? value) {
            setState(() {
              aClass.saved = value!;
              saveClass(aClass, aClass.saved);
            });
          },
        ),
      ),
    );
  }

  SizedBox invisibleBox() {
    return const SizedBox(
      height: 20,
      width: 30,
    );
  }

  void saveClass(Class aClass, bool shouldSave) {
    setState(() {
      if (shouldSave) {
        _savedData.add(aClass);
      } else {
        _savedData.remove(aClass);
      }
    });
  }

  List<String> multiDropdownValues(String keyString) {
    final List<String> values = [];
    if (keyString == 'Schedule') {
      return [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
    }
    return values;
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

  Widget multiDropdown(String keyString, List<String> inputList) {
    return Semantics(
      label: '$keyString multi-select dropdown Menu',
      hint: 'Select one or more of the objects from the dropdown menu.',
      child: SizedBox(
        width: 200,
        height: 50,
        child: DropDownMultiSelect(
          onChanged: (List<String> values) {
            setState(() {
              switch (keyString) {
                case 'Schedule':
                  _scheduleList = values;
                  break;
              }
              doSearch();
            });
          },
          options: multiDropdownValues(keyString),
          selectedValues: inputList,
          whenEmpty: 'Any Day',
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
            setState(() {
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
            });
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
            setState(() {
              _gsFlag = value!;
              doSearch();
            });
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
            setState(() {
              _statusFlag = value!;
              doSearch();
            });
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
              setState(() {
                if (value.isNotEmpty) {
                  _instructorString = value;
                }
                doSearch();
              });
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
              setState(() {
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
              });
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
        multiDropdown('Schedule', _scheduleList),
        dropdownEntry('Start Time'),
        dropdownEntry('End Time'),
        ...statusSelector(),
        ...gsSelector(),
      ],
    );
  }

  Widget cell(String keyString, String input, double width, int bkgndColor) {
    return Semantics(
      label: '$keyString cell.',
      hint: 'The $keyString for this row is $input.',
      child: Container(
        key: Key('$keyString Cell'),
        width: width,
        decoration: BoxDecoration(
          color: Color(bkgndColor),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          addLinesTo(input),
          style: const TextStyle(
            color: Color(0xFF00003e),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget headerCell(String input, double width) {
    return Semantics(
      // As with the Semantics,
      // the word on the cell will come after the semantic label.
      label: 'Below shows the: ',
      child: Container(
        width: width,
        key: Key('${input.trim()} Header Card'),
        decoration: BoxDecoration(
          color: Color(palette['blue']!),
          border: Border.all(color: Colors.black),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            input,
            style: const TextStyle(
              color: Color(0xFFffffff),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Row wideHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0, child: invisibleBox()),
        headerCell('Class#\n', 55),
        headerCell('Subject\n', 45.0),
        headerCell('Sum ${startYear % 1000}\n', 50.0),
        headerCell('Aut ${startYear % 1000}\n', 50.0),
        headerCell('Wtr ${(startYear + 1) % 1000}\n', 50.0),
        headerCell('Spr ${(startYear + 1) % 1000}\n', 50.0),
        headerCell('Sum ${(startYear + 1) % 1000}\n', 50.0),
        headerCell('Sec\n', 40.0),
        headerCell('GS\n', 25.0),
        headerCell('Cr\n', 30.0),
        headerCell('Course Title\n', 300.0),
        headerCell('Status\n', 65.0),
        headerCell('Enroll\nCount', 60.0),
        headerCell('Enroll\nLimit', 60.0),
        headerCell('Waitlist\n', 60.0),
        headerCell('Fee\n', 70.0),
        headerCell('Meeting Time\n', 145.0),
        headerCell('Classroom\n', 80.0),
        headerCell('Instructor(s)\n'.toString(), 200.0),
        headerCell('Campus\n', 60.0),
        headerCell('Video\n', 60.0),
        headerCell('Consent\n', 200.0),
      ],
    );
  }

  Row wideClassRow(Class aClass, int index) {
    lineHeight = getLineHeight(aClass);
    // Default, Summer, Fall, Winter, Spring
    final List<int> aColor = getColor(index);
    final instructors = aClass.getInstructors();
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final room = addLinesTo(aClass.classroom);
    final schedule = addLinesTo(aClass.schedule.toString());
    final instruct = addLinesTo(instructors);
    final qtrs = [
      'Summer $startYear',
      'Fall $startYear',
      'Winter ${startYear + 1}',
      'Spring ${startYear + 1}',
      'Summer ${startYear + 1}',
    ];
    final credits = addLinesTo(
      aClass.course.creditsMax == aClass.course.creditsMin
          ? '${aClass.course.creditsMax}'
          : '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString()),
      addLinesTo(aClass.maxEnrollment.toString()),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      key: const Key('Class'),
      children: [
        savedBox(aClass),
        cell('ClassNumber', aClass.getClN(), 55, aColor[0]),
        cell('Subject', aClass.getCode(), 45.0, aColor[0]),
        cell('Summer1', getTerm(aClass, qtrs[0]), 50.0, aColor[1]),
        cell('Fall', getTerm(aClass, qtrs[1]), 50.0, aColor[2]),
        cell('Winter', getTerm(aClass, qtrs[2]), 50.0, aColor[3]),
        cell('Spring', getTerm(aClass, qtrs[3]), 50.0, aColor[4]),
        cell('Summer2', getTerm(aClass, qtrs[4]), 50.0, aColor[1]),
        cell('Section', aClass.section, 40.0, aColor[0]),
        cell('GS', gs, 25.0, aColor[0]),
        cell('Cr', credits, 30.0, aColor[0]),
        cell('Title', aClass.course.title, 300.0, aColor[0]),
        cell('Status', status, 65.0, aColor[0]),
        cell('Enrollment', enroll[0], 60.0, aColor[0]),
        cell('EnrollmentLimit', enroll[1], 60.0, aColor[0]),
        cell('WaitlistSize', aClass.waitlist.toString(), 60.0, aColor[0]),
        cell('Fee', aClass.fee.toString(), 70.0, aColor[0]),
        cell('Schedule', schedule, 145.0, aColor[0]),
        cell('Classroom', room, 80.0, aColor[0]),
        cell('Instructors', instruct, 200.0, aColor[0]),
        cell('Campus', aClass.getCampus(), 60.0, aColor[0]),
        cell('Video', aClass.video, 60.0, aColor[0]),
        cell('Consent', aClass.consent, 200.0, aColor[0]),
      ],
    );
  }

  ListView wideRowBuilder(List<Class> classes) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        return wideClassRow(classes[index], index);
      },
    );
  }

  Column wideView() {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Color(0xFFa8ac9c)),
                child: searchCriteriaWidget(),
              ),
            ),
            Semantics(
              child: Text(
                key: const Key('Class Found'),
                '${_classes.length} classes found.',
              ),
            ),
            wideHeaderRow(),
            Expanded(child: wideRowBuilder(_classes)),
          ],
        );
      case 1:
        return Column(
          children: [
            Text('${_classes.length} classes found.'),
            wideHeaderRow(),
            Expanded(child: wideRowBuilder(_savedData)),
          ],
        );
      case 2:
        return const Column(
          children: [
            Placeholder(),
          ],
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }

  Row mediumHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0, child: invisibleBox()),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  headerCell('Class Number', 120),
                  headerCell('Subject', 80.0),
                  headerCell('Sum $startYear', 70.0),
                  headerCell('Aut $startYear', 70.0),
                  headerCell('Wtr ${startYear + 1}', 70.0),
                  headerCell('Spr ${startYear + 1}', 70.0),
                  headerCell('Sum ${startYear + 1}', 70.0),
                  headerCell('Sec', 40.0),
                  headerCell('GS', 45.0),
                  headerCell('Enroll Count', 85.0),
                  headerCell('Enroll Limit', 85.0),
                  headerCell('Status', 70.0),
                  headerCell('Waitlist', 65.0),
                ],
              ),
              Row(
                children: [
                  headerCell('Course Title', 310.0),
                  headerCell('Credits', 70.0),
                  headerCell('Meeting Time', 155.0),
                  headerCell('Classroom', 100.0),
                  headerCell('Instructor(s)', 150.0),
                  headerCell('Campus', 80.0),
                  headerCell('Fee', 70.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row mediumClassRow(Class aClass, int index) {
    lineHeight = getLineHeight(aClass);
    // Default, Summer, Fall, Winter, Spring
    final aColor = getColor(index);
    final instructors = aClass.getInstructors();
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final room = addLinesTo(aClass.classroom);
    final schedule = addLinesTo(aClass.schedule.toString());
    final instruct = addLinesTo(instructors);
    final qtrs = [
      'Summer $startYear',
      'Fall $startYear',
      'Winter ${startYear + 1}',
      'Spring ${startYear + 1}',
      'Summer ${startYear + 1}',
    ];
    final credits = addLinesTo(
      aClass.course.creditsMax == aClass.course.creditsMin
          ? '${aClass.course.creditsMax}'
          : '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString()),
      addLinesTo(aClass.maxEnrollment.toString()),
    ];
    final waitList = aClass.waitlist.toString();

    return Row(
      key: const Key('Class'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        savedBox(aClass), // create a checkbox for the row
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  cell('ClassNumber', aClass.getClN(), 120, aColor[0]),
                  cell('Subject', aClass.getCode(), 80.0, aColor[0]),
                  cell('Summer1', getTerm(aClass, qtrs[0]), 70.0, aColor[1]),
                  cell('Fall', getTerm(aClass, qtrs[1]), 70.0, aColor[2]),
                  cell('Winter', getTerm(aClass, qtrs[2]), 70.0, aColor[3]),
                  cell('Spring', getTerm(aClass, qtrs[3]), 70.0, aColor[4]),
                  cell('Summer2', getTerm(aClass, qtrs[4]), 70.0, aColor[1]),
                  cell('Section', aClass.section, 40.0, aColor[0]),
                  cell('GS', gs, 45.0, aColor[0]),
                  cell('Enrollment', enroll[0].trim(), 85.0, aColor[0]),
                  cell('EnrollmentLimit', enroll[1].trim(), 85.0, aColor[0]),
                  cell('Status', status, 70.0, aColor[0]),
                  cell('WaitlistSize', waitList, 65.0, aColor[0]),
                ],
              ),
              Row(
                children: [
                  cell('Title', aClass.course.title, 310.0, aColor[0]),
                  cell('Credits', credits, 70.0, aColor[0]),
                  cell('Schedule', schedule, 155.0, aColor[0]),
                  cell('Classroom', room, 100.0, aColor[0]),
                  cell('Instructors', instruct, 150.0, aColor[0]),
                  cell('Campus', aClass.getCampus(), 80.0, aColor[0]),
                  cell('Fee', aClass.fee.toString(), 70.0, aColor[0]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView mediumRowBuilder(List<Class> classes) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        return mediumClassRow(classes[index], index);
      },
    );
  }

  Column mediumView() {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Color(0xFFa8ac9c)),
                child: searchCriteriaWidget(),
              ),
            ),
            Semantics(
              child: Text(
                key: const Key('Class Found'),
                '${_classes.length} classes found.',
              ),
            ),
            mediumHeaderRow(),
            Expanded(child: mediumRowBuilder(_classes)),
          ],
        );
      case 1:
        return Column(
          children: [
            Text('${_classes.length} classes found.'),
            mediumHeaderRow(),
            Expanded(child: mediumRowBuilder(_savedData)),
          ],
        );
      case 2:
        return const Column(
          children: [
            Placeholder(),
          ],
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }

  Row smallHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0, child: invisibleBox()),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  headerCell('Class\nNumber', 120),
                  headerCell('Subject\n', 80.0),
                  headerCell('Sum\n$startYear', 55.0),
                  headerCell('Aut\n$startYear', 55.0),
                  headerCell('Wtr\n${startYear + 1}', 55.0),
                  headerCell('Spr\n${startYear + 1}', 55.0),
                  headerCell('Sum\n${startYear + 1}', 55.0),
                  headerCell('Sec\n', 40.0),
                  headerCell('Credits\n', 70.0),
                ],
              ),
              Row(
                children: [
                  headerCell('Course Title', 310.0),
                  headerCell('GS', 40.0),
                  headerCell('Enroll Count', 85.0),
                  headerCell('Enroll Limit', 85.0),
                  headerCell('Waitlist', 65.0),
                ],
              ),
              Row(
                children: [
                  headerCell('Meeting Time', 155.0),
                  headerCell('Classroom', 80.0),
                  headerCell('Instructor(s)'.toString(), 150.0),
                  headerCell('Campus', 60.0),
                  headerCell('Fee', 70.0),
                  headerCell('Status', 70.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row smallClassRow(Class aClass, int index) {
    lineHeight = getLineHeight(aClass);
    // Default, Summer, Fall, Winter, Spring
    final aColor = getColor(index);
    final instructors = aClass.getInstructors();
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final room = addLinesTo(aClass.classroom);
    final schedule = addLinesTo(aClass.schedule.toString());
    final instruct = addLinesTo(instructors);
    final qtrs = [
      'Summer $startYear',
      'Fall $startYear',
      'Winter ${startYear + 1}',
      'Spring ${startYear + 1}',
      'Summer ${startYear + 1}',
    ];
    final credits = addLinesTo(
      aClass.course.creditsMax == aClass.course.creditsMin
          ? '${aClass.course.creditsMax}'
          : '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString()),
      addLinesTo(aClass.maxEnrollment.toString()),
    ];
    final waitList = aClass.waitlist.toString();

    return Row(
      key: const Key('Class'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        savedBox(aClass), // create a checkbox for the row
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  cell('ClassNumber', aClass.getClN(), 120, aColor[0]),
                  cell('Subject', aClass.getCode(), 80.0, aColor[0]),
                  cell('Summer1', getTerm(aClass, qtrs[0]), 55.0, aColor[1]),
                  cell('Fall', getTerm(aClass, qtrs[1]), 55.0, aColor[2]),
                  cell('Winter', getTerm(aClass, qtrs[2]), 55.0, aColor[3]),
                  cell('Spring', getTerm(aClass, qtrs[3]), 55.0, aColor[4]),
                  cell('Summer2', getTerm(aClass, qtrs[4]), 55.0, aColor[1]),
                  cell('Section', aClass.section, 40.0, aColor[0]),
                  cell('Credits', credits, 70.0, aColor[0]),
                ],
              ),
              Row(
                children: [
                  cell('Title', aClass.course.title, 310.0, aColor[0]),
                  cell('GS', gs, 40.0, aColor[0]),
                  cell('Enrollment', enroll[0], 85.0, aColor[0]),
                  cell('EnrollmentLimit', enroll[1], 85.0, aColor[0]),
                  cell('WaitlistSize', waitList, 65.0, aColor[0]),
                ],
              ),
              Row(
                children: [
                  cell('Schedule', schedule, 155.0, aColor[0]),
                  cell('Classroom', room, 80.0, aColor[0]),
                  cell('Instructors', instruct, 150.0, aColor[0]),
                  cell('Campus', aClass.getCampus(), 60.0, aColor[0]),
                  cell('Fee', aClass.fee.toString(), 70.0, aColor[0]),
                  cell('Status', status, 70.0, aColor[0]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView smallRowBuilder(List<Class> classes) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        return smallClassRow(classes[index], index);
      },
    );
  }

  Column smallView() {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Color(0xFFa8ac9c)),
                child: searchCriteriaWidget(),
              ),
            ),
            Semantics(
              child: Text(
                key: const Key('Class Found'),
                '${_classes.length} classes found.',
              ),
            ),
            smallHeaderRow(),
            Expanded(child: smallRowBuilder(_classes)),
          ],
        );
      case 1:
        return Column(
          children: [
            Text('${_classes.length} classes found.'),
            smallHeaderRow(),
            Expanded(child: smallRowBuilder(_savedData)),
          ],
        );
      case 2:
        return const Column(
          children: [
            Placeholder(),
          ],
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: GoogleFonts.getFont('Playfair'),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if ((constraints.maxWidth >= 1835) &&
              (constraints.maxHeight > 355.0)) {
            return wideView();
          } else if ((constraints.maxWidth >= 970) &&
              (constraints.maxHeight > 355.0)) {
            return mediumView();
          } else if ((constraints.maxWidth >= 625) &&
              (constraints.maxHeight > 355.0)) {
            return smallView();
          } else {
            // tinyView
            return const Placeholder();
          }
        },
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'All Classes',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}
