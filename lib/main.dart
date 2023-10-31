import 'package:flutter/material.dart';
import 'package:schedule/data_table.dart';
import 'package:schedule/query.dart';
import 'campus.dart';
import 'department.dart';
import 'subject.dart';
import 'term.dart';

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Campus? _campus;
  Department? _department;
  // Subject? _subject;
  // Term? _term;
  DataTableSource sectionData = TableData({});

  void updateResults() {
    sectionData = TableData(Query(_department, null).results());
  }

  List<DropdownMenuEntry> campusDropdownMenuEntries() {
    var campusList = Campus.instances;
    var campusEntries = <DropdownMenuEntry>[];
    for (final each in campusList) {
      campusEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    return campusEntries;
  }

  List<DropdownMenuEntry> deptDropdownMenuEntries() {
    var deptList = Department.instances;
    var deptEntries = <DropdownMenuEntry>[];
    deptEntries.add(const DropdownMenuEntry(value: null, label: "All"));
    for (final each in deptList) {
      deptEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    return deptEntries;
  }

  List<DropdownMenuEntry> subjDropdownMenuEntries() {
    var subjList = Subject.instances;
    var subjEntries = <DropdownMenuEntry>[];
    for (final each in subjList) {
      subjEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    return subjEntries;
  }

  List<DropdownMenuEntry> termDropdownMenuEntries() {
    var termList = Term.instances;
    var termEntries = <DropdownMenuEntry>[];
    for (final each in termList) {
      termEntries.add(DropdownMenuEntry(value: each, label: each.name));
    }
    return termEntries;
  }

  Widget searchCriteriaRow() {
    return Row(
      children: [
        const Spacer(),
        // Campus Dropdown
        Flexible(
          fit: FlexFit.loose,
          flex: 15,
          child: DropdownMenu(
            label: const Text('Campus'),
            dropdownMenuEntries: campusDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                // _campus = value;
              });
            },
          ),
        ),
        const Spacer(),
        // Department Dropdown
        Flexible(
          fit: FlexFit.loose,
          flex: 15,
          child: DropdownMenu(
            key: const Key("Department Dropdown"),
            label: const Text('Department'),
            dropdownMenuEntries: deptDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                _department = value;
              });
            },
          ),
        ),

        const Spacer(),
        // Subject Dropdown
        Flexible(
          fit: FlexFit.loose,
          flex: 15,
          child: DropdownMenu(
            label: const Text('Subject'),
            dropdownMenuEntries: subjDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                // _subject = value;
              });
            },
          ),
        ),

        const Spacer(),
        // Term Dropdown
        Flexible(
          fit: FlexFit.loose,
          flex: 15,
          child: DropdownMenu(
            label: const Text('Term'),
            dropdownMenuEntries: termDropdownMenuEntries(),
            onSelected: (value) {
              setState(() {
                // _term = value;
              });
            },
          ),
        ),
        const Spacer(),

        ElevatedButton(
          onPressed: () {
            setState(() {
              updateResults();
            });
          },
          child: const Text('Search'),
        ),
      ],
    );
  }

  Widget headerRow() {
    return const Row(
      children: [
        SizedBox(
          width: 80,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Subject'),
          ),
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Number'),
          ),
        ),
        SizedBox(
          width: 300,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Course Title'),
          ),
        ),
      ],
    );
  }

  List<Widget> classRows() {
    var sections = Query(_department, null).results();
    final rows = <Widget>[];
    for (final each in sections) {
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(each.course.subject!.code),
            ),
            SizedBox(
              width: 80,
              child: Text(each.course.number.toString()),
            ),
            SizedBox(
              width: 300,
              child: Text(each.course.title),
            ),
          ],
        ),
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: PaginatedDataTable(
          source: sectionData,
          header: searchCriteriaRow(),
          columns: const [
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('Number')),
            DataColumn(label: Text('Title'))
          ],
        ),
      ),
    );
  }
}
