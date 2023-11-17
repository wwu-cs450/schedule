import 'package:flutter/material.dart';
import 'package:schedule/data_table.dart';
import 'package:schedule/query.dart';
import 'package:schedule/class.dart';
import 'package:schedule/campus.dart';
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';

void main() {
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
  Map<String, int> timesPressed = {'Number': 0, 'Subject': 0, 'Title': 0};
  List<Class> _data = <Class>[]; // To store data to be sorted
  final List<Class> _savedData = <Class>[]; // Saved class data
  late DataTableSource classData;
  String? sortOption;

  void sortData() {
    if (sortOption != null) {
      if (sortOption == 'Number') {
        if (timesPressed['Number'] == 0) {
          timesPressed['Number'] = 1;
          _data.sort((a, b) {
            return a.course.number - b.course.number;
          });
        } else {
          _data = _data.reversed.toList();
          timesPressed['Number'] = 0;
        }
      }

      if (sortOption == 'Subject') {
        if (timesPressed['Subject'] == 0) {
          _data.sort((a, b) {
            return a.course.subject!.name.compareTo(b.course.subject!.name);
          });
          timesPressed['Subject'] = 1;
        } else {
          _data = _data.reversed.toList();
          timesPressed['Subject'] = 0;
        }
      }

      if (sortOption == 'Title') {
        if (timesPressed['Title'] == 0) {
          _data.sort((a, b) {
            return a.course.title.compareTo(b.course.title);
          });
          timesPressed['Title'] = 1;
        } else {
          _data = _data.reversed.toList();
          timesPressed['Title'] = 0;
        }
      }
    }
  }

  void updateData() {
    _data = Query(
      department: _department,
      subject: _subject,
      term: _term,
      campus: _campus,
    ).results().toList();
  }

  void updateResults() {
    sortData();
    classData = TableData(_savedData + _data, _savedData, saveClass);
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
    updateResults();
  }

  List<DropdownMenuEntry> campusDropdownMenuEntries() {
    final campusList = Campus.instances;
    final campusEntries = <DropdownMenuEntry>[];
    for (final each in campusList) {
      campusEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    return campusEntries;
  }

  List<DropdownMenuEntry> deptDropdownMenuEntries() {
    final deptList = Department.instances;
    final deptEntries = <DropdownMenuEntry>[];
    for (final each in deptList) {
      deptEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    deptEntries.sort((a, b) {
      return a.label.compareTo(b.label);
    });
    return deptEntries;
  }

  List<DropdownMenuEntry> subjDropdownMenuEntries() {
    final subjList = Subject.instances;
    final subjEntries = <DropdownMenuEntry>[];
    for (final each in subjList) {
      subjEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    subjEntries.sort((a, b) {
      return a.label.compareTo(b.label);
    });
    return subjEntries;
  }

  List<DropdownMenuEntry> termDropdownMenuEntries() {
    final termList = Term.instances;
    final termEntries = <DropdownMenuEntry>[];
    for (final each in termList) {
      termEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    return termEntries;
  }

  Widget searchCriteriaWidget() {
    return Wrap(
      key: const Key('Search Criteria Widget'),
      spacing: 8,
      runSpacing: 8,
      children: [
        // Campus Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu(
            key: const Key('Campus Dropdown'),
            label: const Text('Campus'),
            dropdownMenuEntries: campusDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                _campus = value;
              });
            },
          ),
        ),
        // Department Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu(
            key: const Key('Department Dropdown'),
            label: const Text('Department'),
            dropdownMenuEntries: deptDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                _department = value;
              });
            },
          ),
        ),

        // Subject Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu(
            key: const Key('Subject Dropdown'),
            label: const Text('Subject'),
            dropdownMenuEntries: subjDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                _subject = value;
              });
            },
          ),
        ),

        // Term Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu(
            key: const Key('Term Dropdown'),
            label: const Text('Term'),
            dropdownMenuEntries: termDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                _term = value;
              });
            },
          ),
        ),
        // const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            key: const Key('Search Button'),
            onPressed: () {
              setState(() {
                updateData();
                updateResults();
              });
            },
            child: const Text('Search'),
          ),
        ),
      ],
    );
  }

  Widget sortBySubject() {
    return ElevatedButton(
      key: const Key('Subject Header Button'),
      onPressed: () {
        sortOption = 'Subject';
        setState(() {
          updateResults();
        });
      },
      child: const Text('Subject'),
    );
  }

  Widget sortByNumber() {
    return ElevatedButton(
      key: const Key('Number Header Button'),
      onPressed: () {
        sortOption = 'Number';
        setState(() {
          updateResults();
        });
      },
      child: const Text('Number'),
    );
  }

  Widget sortByTitle() {
    return ElevatedButton(
      key: const Key('Title Header Button'),
      onPressed: () {
        sortOption = 'Title';
        setState(() {
          updateResults();
        });
      },
      child: const Text('Title'),
    );
  }

  @override
  Widget build(BuildContext context) {
    classData = TableData(_savedData + _data, _savedData, saveClass);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            searchCriteriaWidget(),
            PaginatedDataTable(
              key: const Key('Results'),
              showCheckboxColumn: true,
              source: classData,
              columns: [
                DataColumn(label: sortBySubject()),
                DataColumn(label: sortByNumber()),
                DataColumn(label: sortByTitle()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
