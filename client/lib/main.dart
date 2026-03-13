import 'package:client/domain/class.dart';
import 'package:client/domain/class_storage.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/views/base_views/large_view.dart';
import 'package:client/views/base_views/medium_view.dart';
import 'package:client/views/base_views/small_view.dart';
import 'package:client/views/error_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? errorMessage;
  try {
    await Filters().load(); // Load filters from local storage
    await ClassStorage().load(); // Load completed courses from local storage
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
      surface: const Color(0xFFF8F6F2),
    );
    return ShadApp.custom(
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadNeutralColorScheme.light(),
      ),
      appBuilder: (context) => MaterialApp(
        title: 'WWU Class Schedule',
        theme: ThemeData(
          tooltipTheme: const TooltipThemeData(preferBelow: false),
          colorScheme: colorScheme,
          useMaterial3: true,
        ),
        home: errorMessage != null ? _errorPage() : _homePage(),
      ),
    );
  }

  Widget _homePage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Filters>.value(value: Filters()),
        ChangeNotifierProvider<ClassStorage>.value(value: ClassStorage()),
      ],
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
