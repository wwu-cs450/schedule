import 'package:flutter/material.dart';
// import 'package:flutter/semantics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/domain/data_handler.dart';
import 'package:schedule_client/views/medium_view.dart';
import 'package:schedule_client/views/search_criteria.dart';
import 'package:schedule_client/views/small_view.dart';
import 'package:schedule_client/views/wide_view.dart';

void main() async {
  await DataHandler.fetchData();
  Class.instances;
  runApp(const MyApp());
  // SemanticsBinding.instance.ensureSemantics();
}

late SearchCriteria results;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    results = SearchCriteria(context);
    return ChangeNotifierProvider<SearchCriteria>.value(
      value: results,
      child: MaterialApp(
        title: 'WWU Class Schedule',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF656950),
            primary: const Color(0xFF656950),
          ),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'WWU Class Schedule'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({required this.title, super.key});
  final String title;
  final startYear = 2023;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchCriteria>(
      builder: (context, appData, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text(
              title,
              style: GoogleFonts.getFont('Playfair'),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if ((constraints.maxWidth >= 1835) &&
                  (constraints.maxHeight > 355.0)) {
                return WideView(startYear, results).view(
                  results.selectedIndex,
                  context,
                  results.searchCriteriaWidget,
                );
              } else if ((constraints.maxWidth >= 970) &&
                  (constraints.maxHeight > 355.0)) {
                return MediumView(startYear, results).view(
                  results.selectedIndex,
                  context,
                  results.searchCriteriaWidget,
                );
              } else if ((constraints.maxWidth >= 625) &&
                  (constraints.maxHeight > 355.0)) {
                return SmallView(startYear, results).view(
                  results.selectedIndex,
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
              results.selectedIndex = index;
            },
            destinations: const <Widget>[
              NavigationDestination(
                key: Key('Main Page'),
                icon: Icon(Icons.list),
                label: 'All Classes',
              ),
              NavigationDestination(
                key: Key('Schedule Page'),
                icon: Icon(Icons.schedule),
                label: 'Schedule',
              ),
            ],
          ),
        );
      },
    );
  }
}
