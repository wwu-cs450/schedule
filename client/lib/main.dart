import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/views/error_view.dart';
import 'package:client/views/medium_view.dart';
import 'package:client/views/search_drawer.dart';
import 'package:client/views/small_view.dart';
import 'package:client/views/wide_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? errorMessage;
  String dateTime = '';
  try {
    await Filters().load();
    await DataHandler.fetchData();
    Class.instances;
    dateTime = await DataHandler.fetchDateTime();
  } catch (e) {
    errorMessage = e.toString();
  }
  runApp(MyApp(dateTime: dateTime, errorMessage: errorMessage));
}

late SearchCriteriaView results;
const startYear = 2024;

class MyApp extends StatelessWidget {
  const MyApp({required this.dateTime, super.key, this.errorMessage});
  final String? errorMessage;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    results = SearchCriteriaView(context);
    return ChangeNotifierProvider<SearchCriteriaView>.value(
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
            ? HomePage(title: 'WWU Class Schedule', dateTime: dateTime)
            : Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: ErrorDisplay(errorMessage: errorMessage!),
              ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({required this.title, required this.dateTime, super.key});
  final String title;
  final String dateTime;

  @override
  Widget build(BuildContext context) {
    results.doSearch();
    return Consumer<SearchCriteriaView>(
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
                return WideView(startYear, results, dateTime).view(
                  results.selectedIndex,
                  context,
                );
              } else if ((constraints.maxWidth >= 970) &&
                  (constraints.maxHeight > 355.0)) {
                return MediumView(startYear, results, dateTime).view(
                  results.selectedIndex,
                  context,
                );
              } else {
                return SmallView(startYear, results, dateTime).view(
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
              NavigationDestination(
                key: Key('Bulletin Page'),
                icon: Icon(Icons.checklist),
                label: 'Bulletin Scanner',
              ),
            ],
          ),
          drawer: results.sidebar,
        );
      },
    );
  }
}
