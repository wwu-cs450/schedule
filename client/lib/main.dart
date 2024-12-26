import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/views/error_view.dart';
import 'package:client/views/large_view.dart';
import 'package:client/views/medium_view.dart';
import 'package:client/views/small_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? errorMessage;
  try {
    await Filters().load(); // Load filters from local storage
    await DataHandler.fetchData(); // Fetch class data from server
    Class.instances; // Initialize the class list
    await Filters().update();
  } catch (e) {
    errorMessage = e.toString();
  }
  runApp(Schedule(errorMessage: errorMessage));
}

class Schedule extends StatelessWidget {
  const Schedule({super.key, this.errorMessage});
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF656950),
      primary: const Color(0xFF656950),
    );
    return MaterialApp(
      title: 'WWU Class Schedule',
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(preferBelow: false),
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: errorMessage != null ? _errorPage() : _homePage(),
      // ),
    );
  }

  Widget _homePage() {
    return ChangeNotifierProvider<Filters>.value(
      value: Filters(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 510.0) {
            return const ErrorDisplay(
              errorMessage: 'Window is too small to display schedule.',
            );
          } else if (constraints.maxWidth < 970.0) {
            return SmallView();
          } else if (constraints.maxWidth < 1850.0) {
            return MediumView();
          } else {
            return LargeView();
          }
        },
      ),
    );
  }

  Widget _errorPage() {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: ErrorDisplay(errorMessage: errorMessage!),
    );
  }
}
