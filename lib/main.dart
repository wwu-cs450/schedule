import 'package:flutter/material.dart';
import 'package:schedule/query.dart';
import 'package:schedule/class.dart';
import 'package:schedule/campus.dart';
import 'package:schedule/department.dart';
import 'package:schedule/subject.dart';
import 'package:schedule/term.dart';

void main() {
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
  Campus _campus = Campus.allCampuses(); // Stores list of campuses
  Department _department =
      Department.allDepartments(); // Stores list of departments
  Subject _subject = Subject.allSubjects(); // Stores list of subjects
  Term _term = Term.allTerms(); // Stores list of terms
  int _classNumber = 0;
  List<Class> _data = <Class>[]; // To store data to be sorted
  final List<Class> _savedData = <Class>[]; // Saved class data
  List<Class> _classes = <Class>[];
  late Row sizingRow;

  void sortData() {
    _data.sort((a, b) {
      final aKey =
          '${a.course.subject!.code} ${a.course.number} ${a.term.code} ${a.section}';
      final bKey =
          '${b.course.subject!.code} ${b.course.number} ${b.term.code} ${b.section}';
      return aKey.compareTo(bKey);
    });
  }

  void pressSearch() {
    _data = Query(
      department: _department,
      subject: _subject,
      term: _term,
      campus: _campus,
      classNumber: _classNumber,
    ).results().toList();
    _classes = [];
    sortData();
  }

  void updateClasses() {
    _classes = _savedData + _data;
  }

  Card cardNumber(Class offeredClass) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: const Color(0xFFB0B0B0),
      shadowColor: Colors.black,
      elevation: 15,
      child: SizedBox(
        width: 80,
        height: 50,
        child: Center(
          child:
              // this should be the subject followed by the code
              Text(
            (offeredClass.course.subject?.code ?? '') +
                offeredClass.course.number.toString(),
          ),
        ),
      ),
    );
  }

  Card cardTerm(Class offeredClass) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: const Color(0xFFB0B0B0),
      shadowColor: Colors.black,
      elevation: 15,
      child: SizedBox(
        width: 95,
        height: 50,
        child: Center(child: Text(offeredClass.term.name)),
      ),
    );
  }

  Card cardClassNumber(Class offeredClass) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: const Color(0xFFB0B0B0),
      shadowColor: Colors.black,
      elevation: 15,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(child: Text(offeredClass.classNumber.toString())),
      ),
    );
  }

  Card cardTitle(Class offeredClass) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: const Color(0xFFB0B0B0),
      shadowColor: Colors.black,
      elevation: 15,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 225,
          height: 50,
          child: Center(child: Text(offeredClass.course.title)),
        ),
      ),
    );
  }

  Card cardCampus(Class offeredClass) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      color: const Color(0xFFB0B0B0),
      shadowColor: Colors.black,
      elevation: 15,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 200,
          height: 50,
          child: Center(child: Text(offeredClass.campus.name)),
        ),
      ),
    );
  }

  Row classRow(Class offeredClass, int index) {
    return Row(
      key: Key('Class-$index'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // create a checkbox for the row
        savedBox(offeredClass),
        // create box for class number (NOT COURSE NUMBER, etc NOT 141)
        cardClassNumber(offeredClass),
        // create box for the course number
        cardNumber(offeredClass),
        // create a box for the class title
        cardTitle(offeredClass),
        // create box for the class times
        cardTerm(offeredClass),
        // create box for campus location
        cardCampus(offeredClass),
        // create box for classNumber
      ],
    );
  }

  Checkbox savedBox(Class offeredClass) {
    return Checkbox(
      value: offeredClass.saved,
      onChanged: (bool? value) {
        setState(() {
          offeredClass.saved = value!;
          saveClass(offeredClass, offeredClass.saved);
        });
      },
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
    updateClasses();
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

  Padding campusDropdown() {
    return Padding(
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
    );
  }

  Padding classNumberTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 100,
        height: 50,
        child: TextField(
          decoration: const InputDecoration(
            labelText: 'Class Number',
          ),
          onChanged: (value) {
            setState(() {
              if (value == '0' || value == '') {
                _classNumber = 0;
              } else if (value.length < 4) {
                return;
              } else {
                _classNumber = int.parse(value);
              }
            });
          },
        ),
      ),
    );
  }

  Padding departmentDropdown() {
    return Padding(
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
    );
  }

  Padding subjectDropdown() {
    return Padding(
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
    );
  }

  Padding termDropdown() {
    return Padding(
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
    );
  }

  Padding searchButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        key: const Key('Search Button'),
        onPressed: () {
          setState(() {
            pressSearch();
            updateClasses();
          });
        },
        child: const Text('Search'),
      ),
    );
  }

  Widget searchCriteriaWidget() {
    return Wrap(
      key: const Key('Search Criteria Widget'),
      spacing: 8,
      runSpacing: 8,
      children: [
        campusDropdown(), // Campus Dropdown
        departmentDropdown(), // Department Dropdown
        subjectDropdown(), // Subject Dropdown
        termDropdown(), // Term Dropdown
        classNumberTextField(),
        // const Spacer(),
        searchButton(),
      ],
    );
  }

  Widget classNumberCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      key: const Key('Class Number Header Card'),
      child: const SizedBox(
        width: 50,
        height: 50,
        child: Center(child: Text('Class#')),
      ),
    );
  }

  Widget courseCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      key: const Key('Course Header Card'),
      child: const SizedBox(
        width: 80,
        height: 50,
        child: Center(child: Text('Course')),
      ),
    );
  }

  Widget titleCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      key: const Key('Title Header Card'),
      child: const SizedBox(
        width: 225,
        height: 50,
        child: Center(child: Text('Title')),
      ),
    );
  }

  Widget termCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      key: const Key('Term Header Card'),
      child: const SizedBox(
        width: 95,
        height: 50,
        child: Center(child: Text('Term')),
      ),
    );
  }

  Widget campusCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      key: const Key('Campus Header Card'),
      child: const SizedBox(
        width: 200,
        height: 50,
        child: Center(child: Text('Campus')),
      ),
    );
  }

  ListView rowBuilder() {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: _classes.length,
      itemBuilder: (context, index) {
        return classRow(_classes[index], index);
      },
    );
  }

  Row headerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        classNumberCard(),
        courseCard(),
        titleCard(),
        termCard(),
        campusCard(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    sizingRow = const Row();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          searchCriteriaWidget(),
          Text('${(_savedData + _data).length} classes found.'),
          headerRow(),
          Expanded(child: rowBuilder()),
        ],
      ),
    );
  }
}
