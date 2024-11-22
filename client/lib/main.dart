import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/views/error_view.dart';
import 'package:client/views/medium_view.dart';
import 'package:client/views/search_criteria.dart';
import 'package:client/views/small_view.dart';
import 'package:client/views/wide_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? errorMessage;
  try {
    await DataHandler.fetchData();
    Class.instances;
  } catch (e) {
    errorMessage = e.toString();
  }
  runApp(MyApp(errorMessage: errorMessage));
}

late SearchCriteria results;
const startYear = 2024;

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.errorMessage});
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    results = SearchCriteria(context);
    return ChangeNotifierProvider<SearchCriteria>.value(
      value: results,
      child: MaterialApp(
        title: 'WWU Class Schedule',
        theme: ThemeData(
          tooltipTheme: const TooltipThemeData(preferBelow: false),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF656950),
            primary: const Color(0xFF656950),
          ),
          useMaterial3: true,
        ),
        home: errorMessage == null
            ? const HomePage(title: 'WWU Class Schedule')
            : Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: ErrorDisplay(errorMessage: errorMessage!),
              ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    results.doSearch();
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
              if ((constraints.maxWidth >= 1850) &&
                  (constraints.maxHeight > 355.0)) {
                return WideView(startYear, results).view(
                  results.selectedIndex,
                  context,
                );
              } else if ((constraints.maxWidth >= 970) &&
                  (constraints.maxHeight > 355.0)) {
                return MediumView(startYear, results).view(
                  results.selectedIndex,
                  context,
                );
              } else {
                return SmallView(startYear, results).view(
                  results.selectedIndex,
                  context,
                );
              }
            },
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: results.selectedIndex,
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
              NavigationDestination(
                key: Key('Pdf Page'),
                icon: Icon(Icons.checklist),
                label: 'PDF Upload',
              ),
            ],
          ),
          drawer: results.sidebar,
        );
      },
    );
  }
}
