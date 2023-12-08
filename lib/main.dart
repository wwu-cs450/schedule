import 'dart:math';

import 'package:flutter/material.dart';
import 'package:schedule/data_handler.dart';
import 'package:schedule/query.dart';
import 'package:schedule/class.dart';
import 'package:schedule/campus.dart';
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';

void main() async {
  await DataHandler.fetchData();
  Class.instances;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WWU Class Schedule',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
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
  List<Class> _data = <Class>[]; // To store data to be sorted
  final List<Class> _savedData = <Class>[]; // Saved class data
  List<Class> _classes = <Class>[];
  final startYear = 2023;
  final List<String> keys = [];

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
    _data = Query(
      department: _department,
      subject: _subject,
      term: _term,
      campus: _campus,
      classNumber: _classNumber,
    ).results().toList();
    // Sorting will be changed by Issue 63.
    _data.sort((a, b) {
      final aKey =
          '${a.course.subject.code} ${a.course.number} ${a.term.code} ${a.section}';
      final bKey =
          '${b.course.subject.code} ${b.course.number} ${b.term.code} ${b.section}';
      return aKey.compareTo(bKey);
    });

    _classes = _savedData + _data;
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

  String addLinesTo(String aString, int lineHeight) {
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

  SizedBox savedBox(Class aClass) {
    return SizedBox(
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
        _data.remove(aClass);
      } else {
        _savedData.remove(aClass);
        _data.add(aClass);
      }
    });
    _classes = _savedData + _data;
  }

  List<DropdownMenuEntry> dropdownEntries(String key) {
    final entries = <DropdownMenuEntry>[];
    dynamic instances;
    switch (key) {
      case 'Campus':
        instances = Campus.instances;
        break;
      case 'Department':
        instances = Department.instances;
        break;
      case 'Subject':
        instances = Subject.instances;
        break;
      case 'Term':
        instances = Term.instances;
        break;
      default:
        assert(false);
    }
    if (instances != null) {
      for (final instance in instances) {
        entries.add(DropdownMenuEntry(value: instance, label: instance.name));
      }
    }
    return entries;
  }

  Padding dropdownEntry(String keyString) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu(
        key: Key('$keyString Dropdown'),
        label: Text(keyString),
        dropdownMenuEntries: dropdownEntries(keyString),
        onSelected: (value) {
          setState(() {
            if (keyString == 'Campus') {
              _campus = value;
              doSearch();
            } else if (keyString == 'Department') {
              _department = value;
              doSearch();
            } else if (keyString == 'Subject') {
              _subject = value;
              doSearch();
            } else if (keyString == 'Term') {
              _term = value;
              doSearch();
            }
          });
        },
      ),
    );
  }

  Padding classNumberTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        key: const Key('Class Number Dropdown'),
        width: 100,
        height: 50,
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Class Number',
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _classNumber = 0;
                doSearch();
              } else if (value.length == 4) {
                _classNumber = int.parse(value);
                doSearch();
              }
            });
          },
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
        dropdownEntry('Campus'),
        dropdownEntry('Department'),
        dropdownEntry('Subject'),
        dropdownEntry('Term'),
        classNumberTextField(),
      ],
    );
  }

  Container cell(String input, double width, int bkgndColor, int lineHeight) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color(bkgndColor),
        border: Border.all(color: Colors.white),
      ),
      child: Text(
        addLinesTo(input, lineHeight),
        style: const TextStyle(color: Color(0xFF00003e)),
      ),
    );
  }

  Container headerCell(String input, double width) {
    return Container(
      width: width,
      key: Key('$input Header Card'),
      decoration: BoxDecoration(
        color: const Color(0xFF336699),
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        input,
        style: const TextStyle(color: Color(0xFFffffff)),
      ),
    );
  }

  Row wideHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0, child: invisibleBox()),
        headerCell('Class\nNumber', 60),
        headerCell('Subject\n', 80.0),
        headerCell('Sum $startYear', 55.0),
        headerCell('Aut $startYear', 55.0),
        headerCell('Wtr ${startYear + 1}', 55.0),
        headerCell('Spr ${startYear + 1}', 55.0),
        headerCell('Sum ${startYear + 1}', 55.0),
        headerCell('Sec\n', 40.0),
        headerCell('GS\n', 40.0),
        headerCell('Credits\n', 60.0),
        headerCell('Course Title\n', 300.0),
        headerCell('Status\n', 65.0),
        headerCell('Enroll\nCount', 60.0),
        headerCell('Enroll\nLimit', 60.0),
        headerCell('Waitlist\n', 60.0),
        headerCell('Fee\n', 70.0),
        headerCell('Meeting Time\n', 145.0),
        headerCell('Classroom\n', 80.0),
        headerCell('Instructor(s)\n'.toString(), 150.0),
        headerCell('Campus\n', 200.0),
      ],
    );
  }

  Row wideClassRow(Class aClass, int index) {
    // Default, Summer, Fall, Winter, Spring
    final List<int> aColor = getColor(index);
    final instructors = aClass.getInstructors();
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final lineHeight = getLineHeight(aClass);
    final room = addLinesTo(aClass.classroom, lineHeight);
    final schedule = addLinesTo(aClass.schedule.toString(), lineHeight);
    final instruct = addLinesTo(instructors, lineHeight);
    final qtrs = [
      'Summer $startYear',
      'Fall $startYear',
      'Winter ${startYear + 1}',
      'Spring ${startYear + 1}',
      'Summer ${startYear + 1}',
    ];
    final credits = addLinesTo(
      '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
      lineHeight,
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString(), lineHeight),
      addLinesTo(aClass.maxEnrollment.toString(), lineHeight),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      key: Key('Class-$index'),
      children: [
        savedBox(aClass),

        // Class # Cell
        cell(aClass.getClN(), 60, aColor[0], lineHeight),

        // Subject Cell
        cell(aClass.getCode(), 80.0, aColor[0], lineHeight),

        // Summer 2023
        cell(getTerm(aClass, qtrs[0]), 55.0, aColor[1], lineHeight),

        // Fall 2023
        cell(getTerm(aClass, qtrs[1]), 55.0, aColor[2], lineHeight),

        // Winter 2024
        cell(getTerm(aClass, qtrs[2]), 55.0, aColor[3], lineHeight),

        // Spring 2024
        cell(getTerm(aClass, qtrs[3]), 55.0, aColor[4], lineHeight),

        // Summer 2024
        cell(getTerm(aClass, qtrs[4]), 55.0, aColor[1], lineHeight),

        // Class Section Cell
        cell(aClass.section, 40.0, aColor[0], lineHeight),

        // General Studies Cell
        cell(gs, 40.0, aColor[0], lineHeight),

        // Credits Cell
        cell(credits, 60.0, aColor[0], lineHeight),

        // Title Cell
        cell(aClass.course.title, 300.0, aColor[0], lineHeight),

        // Status Cell
        cell(status, 65.0, aColor[0], lineHeight),

        // Enrollment Count Cell
        cell(enroll[0], 60.0, aColor[0], lineHeight),

        // Enrollment Limit Cell
        cell(enroll[1], 60.0, aColor[0], lineHeight),

        // Waitlist Cell
        cell(aClass.waitlist.toString(), 60.0, aColor[0], lineHeight),

        // Fee Cell
        cell(aClass.fee.toString(), 70.0, aColor[0], lineHeight),

        // Schedule Cell
        cell(schedule, 145.0, aColor[0], lineHeight),

        // Classroom Cell
        cell(room, 80.0, aColor[0], lineHeight),

        // Instructor(s) Cell
        cell(instruct, 150.0, aColor[0], lineHeight),
        // Campus Cell
        cell(aClass.getCampus(), 200.0, aColor[0], lineHeight),
      ],
    );
  }

  ListView wideRowBuilder() {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        return wideClassRow(_classes[index], index);
      },
    );
  }

  Column wideView() {
    return Column(
      children: [
        searchCriteriaWidget(),
        Text('${(_savedData + _data).length} classes found.'),
        wideHeaderRow(),
        Expanded(child: wideRowBuilder()),
      ],
    );
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
    // Default, Summer, Fall, Winter, Spring
    final aColor = getColor(index);
    final instructors = aClass.getInstructors();
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final lineHeight = getLineHeight(aClass);
    final room = addLinesTo(aClass.classroom, lineHeight);
    final schedule = addLinesTo(aClass.schedule.toString(), lineHeight);
    final instruct = addLinesTo(instructors, lineHeight);
    final qtrs = [
      'Summer $startYear',
      'Fall $startYear',
      'Winter ${startYear + 1}',
      'Spring ${startYear + 1}',
      'Summer ${startYear + 1}',
    ];
    final credits = addLinesTo(
      '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
      lineHeight,
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString(), lineHeight),
      addLinesTo(aClass.maxEnrollment.toString(), lineHeight),
    ];

    return Row(
      key: Key('Class-$index'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        savedBox(aClass), // create a checkbox for the row
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            key: Key('Class-$index'),
            children: [
              Row(
                children: [
                  // Class # Cell
                  cell(aClass.getClN(), 120, aColor[0], 1),
                  // Subject Cell
                  cell(aClass.getCode(), 80.0, aColor[0], 1),
                  // Summer 2023
                  cell(getTerm(aClass, qtrs[0]), 70.0, aColor[1], 1),
                  // Fall 2023
                  cell(getTerm(aClass, qtrs[1]), 70.0, aColor[2], 1),
                  // Winter 2024
                  cell(getTerm(aClass, qtrs[2]), 70.0, aColor[3], 1),
                  // Spring 2024
                  cell(getTerm(aClass, qtrs[3]), 70.0, aColor[4], 1),
                  // Summer 2024
                  cell(getTerm(aClass, qtrs[4]), 70.0, aColor[1], 1),
                  // Class Section Cell
                  cell(aClass.section, 40.0, aColor[0], 1),
                  // General Studies Cell
                  cell(gs, 45.0, aColor[0], 1),
                  // Enrollment Count Cell
                  cell(enroll[0].trim(), 85.0, aColor[0], 1),
                  // Enrollment Limit Cell
                  cell(enroll[1].trim(), 85.0, aColor[0], 1),
                  // Status Cell
                  cell(status, 70.0, aColor[0], 1),
                  // Waitlist Cell
                  cell(aClass.waitlist.toString(), 65.0, aColor[0], 1),
                ],
              ),
              Row(
                children: [
                  // Title Cell
                  cell(aClass.course.title, 310.0, aColor[0], lineHeight),
                  // Credits Cell
                  cell(credits, 70.0, aColor[0], lineHeight),
                  // Schedule Cell
                  cell(schedule, 155.0, aColor[0], lineHeight),
                  // Classroom Cell
                  cell(room, 100.0, aColor[0], lineHeight),
                  // Instructor(s) Cell
                  cell(instruct, 150.0, aColor[0], lineHeight),
                  // Campus Cell
                  cell(aClass.getCampus(), 80.0, aColor[0], lineHeight),
                  // Fee Cell
                  cell(aClass.fee.toString(), 70.0, aColor[0], lineHeight),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView mediumRowBuilder() {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        return mediumClassRow(_classes[index], index);
      },
    );
  }

  Column mediumView() {
    return Column(
      children: [
        searchCriteriaWidget(),
        Text('${(_savedData + _data).length} classes found.'),
        mediumHeaderRow(),
        Expanded(child: mediumRowBuilder()),
      ],
    );
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
    // Default, Summer, Fall, Winter, Spring
    final aColor = getColor(index);
    final instructors = aClass.getInstructors();
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final lineHeight = getLineHeight(aClass);
    final room = addLinesTo(aClass.classroom, lineHeight);
    final schedule = addLinesTo(aClass.schedule.toString(), lineHeight);
    final instruct = addLinesTo(instructors, lineHeight);
    final qtrs = [
      'Summer $startYear',
      'Fall $startYear',
      'Winter ${startYear + 1}',
      'Spring ${startYear + 1}',
      'Summer ${startYear + 1}',
    ];
    final credits = addLinesTo(
      '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
      lineHeight,
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString(), lineHeight),
      addLinesTo(aClass.maxEnrollment.toString(), lineHeight),
    ];

    return Row(
      key: Key('Class-$index'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        savedBox(aClass), // create a checkbox for the row
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            key: Key('Class-$index'),
            children: [
              Row(
                children: [
                  // Class # Cell
                  cell(aClass.getClN(), 120, aColor[0], lineHeight),
                  // Subject Cell
                  cell(aClass.getCode(), 80.0, aColor[0], lineHeight),
                  // Summer 2023
                  cell(getTerm(aClass, qtrs[0]), 55.0, aColor[1], lineHeight),
                  // Fall 2023
                  cell(getTerm(aClass, qtrs[1]), 55.0, aColor[2], lineHeight),
                  // Winter 2024
                  cell(getTerm(aClass, qtrs[2]), 55.0, aColor[3], lineHeight),
                  // Spring 2024
                  cell(getTerm(aClass, qtrs[3]), 55.0, aColor[4], lineHeight),
                  // Summer 2024
                  cell(getTerm(aClass, qtrs[4]), 55.0, aColor[1], lineHeight),
                  // Class Section Cell
                  cell(aClass.section, 40.0, aColor[0], lineHeight),
                  // Credits Cell
                  cell(credits, 70.0, aColor[0], lineHeight),
                ],
              ),
              Row(
                children: [
                  // Title Cell
                  cell(aClass.course.title, 310.0, aColor[0], lineHeight),
                  // General Studies Cell
                  cell(gs, 40.0, aColor[0], lineHeight),
                  // Enrollment Count Cell
                  cell(enroll[0], 85.0, aColor[0], lineHeight),
                  // Enrollment Limit Cell
                  cell(enroll[1], 85.0, aColor[0], lineHeight),
                  // Waitlist Cell
                  cell(aClass.waitlist.toString(), 65.0, aColor[0], lineHeight),
                ],
              ),
              Row(
                children: [
                  // Schedule Cell
                  cell(schedule, 155.0, aColor[0], lineHeight),
                  // Classroom Cell
                  cell(room, 80.0, aColor[0], lineHeight),
                  // Instructor(s) Cell
                  cell(instruct, 150.0, aColor[0], lineHeight),
                  // Campus Cell
                  cell(aClass.getCampus(), 60.0, aColor[0], lineHeight),
                  // Fee Cell
                  cell(aClass.fee.toString(), 70.0, aColor[0], lineHeight),
                  // Status Cell
                  cell(status, 70.0, aColor[0], lineHeight),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView smallRowBuilder() {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        return smallClassRow(_classes[index], index);
      },
    );
  }

  Column smallView() {
    return Column(
      children: [
        searchCriteriaWidget(),
        Text('${(_savedData + _data).length} classes found.'),
        smallHeaderRow(),
        Expanded(child: smallRowBuilder()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if ((constraints.maxWidth >= 1780) &&
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
    );
  }
}
