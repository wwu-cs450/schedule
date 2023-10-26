import 'package:flutter/material.dart';
// import 'package:schedule/section.dart';
import 'package:schedule/query.dart';
import 'package:schedule/data_table.dart';

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
  DataTableSource sectionData = TableData({});

  void updateResults() {
    sectionData = TableData(Query().results);
  }

  List<DropdownMenuEntry> dropdownMenuEntries() {
    var departments = ['Computer Science', 'Engineering', 'Math'];
    var entries = <DropdownMenuEntry>[];
    for (final each in departments) {
      entries.add(DropdownMenuEntry(value: each, label: each));
    }
    return entries;
  }

  Widget searchCriteriaRow() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownMenu(
            label: const Text('Department'),
            dropdownMenuEntries: dropdownMenuEntries(),
            onSelected: (value) {
              setState(() {});
            },
          ),
        ),
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
