import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  String? _department;

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
              setState(() {
                _department = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {});
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
    const classes = [
      ['CPTR', '141', 'Fundamentals of Programming I'],
      ['CPTR', '142', 'Fundamentals of Programming II'],
      ['CPTR', '450', 'Software Engineering'],
      ['ENGR', '121', 'Intro to Engineering'],
    ];
    final rows = <Widget>[];
    for (final each in classes) {
      if (_department == 'Computer Science' && each[0] == 'CPTR' ||
          _department == 'Engineering' && each[0] == 'ENGR') {
        rows.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(each[0]),
              ),
              SizedBox(
                width: 80,
                child: Text(each[1]),
              ),
              SizedBox(
                width: 300,
                child: Text(each[2]),
              ),
            ],
          ),
        ));
      }
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
      body: Center(
        child: Column(
          children: <Widget>[
            searchCriteriaRow(),
            const Divider(
              height: 8,
              thickness: 2,
            ),
            headerRow(),
            ...classRows(),
          ],
        ),
      ),
    );
  }
}
