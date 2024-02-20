import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gui/domain/class.dart';
import 'package:gui/domain/data_handler.dart';
import 'package:gui/views/medium_view.dart';
import 'package:gui/views/search_criteria.dart';
import 'package:gui/views/small_view.dart';
import 'package:gui/views/wide_view.dart';

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
  void setNewState(String key, dynamic statefulObject, dynamic value) {
    setState(() {
      if (key == 'Saved Box') {
        statefulObject.saved = value;
      } else if (key == 'Search Classes') {
        final List<Class> classes = value;
        classes.sort();
        statefulObject.classes = classes;
      }
    });
  }

  SearchCriteria createResults() {
    return SearchCriteria(setNewState);
  }

  late SearchCriteria results = createResults();

  int selectedIndex = 0; // Page Index
  final startYear = 2023;

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
            return WideView(startYear, results, setNewState).view(
              selectedIndex,
              context,
              results.searchCriteriaWidget,
            );
          } else if ((constraints.maxWidth >= 970) &&
              (constraints.maxHeight > 355.0)) {
            return MediumView(startYear, results, setNewState)
                .view(selectedIndex, context, results.searchCriteriaWidget);
          } else if ((constraints.maxWidth >= 625) &&
              (constraints.maxHeight > 355.0)) {
            return SmallView(startYear, results, setNewState).view(
              selectedIndex,
              context,
              results.searchCriteriaWidget,
            );
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
