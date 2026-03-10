import 'package:client/domain/filters.dart';
import 'package:client/views/base_views/abstract_view.dart';
import 'package:client/views/class_history_page.dart';
import 'package:client/views/class_list/class_list.dart';
import 'package:client/views/class_list/class_list_page.dart';
import 'package:client/views/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MediumView extends AbstractView {
  const MediumView({super.key});

  @override
  MediumViewState createState() => MediumViewState();
}

class MediumViewState extends AbstractViewState {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<Filters>(
      builder: (context, filters, child) {
        setTerm(filters.term);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            title: Text(
              'WWU Class Schedule',
              style: GoogleFonts.getFont('Playfair'),
            ),
          ),
          body: _selectedTab(),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
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
                key: Key('MyClassHistoryPage'),
                icon: Icon(Icons.school_outlined),
                label: 'My Class History',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget headerRow() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          invisibleBox(),
          headerCell('Class #', 50),
          headerCell('Subject', 90.0),
          headerCell('Sec', 30.0),
          headerCell('Term', 70.0),
          headerCell('Title', 200.0),
          headerCell('Cr', 30.0),
          headerCell('GS', 30.0),
          Column(
            children: [
              Row(children: [headerCell('Enrollment', 85.0)]),
              Row(
                children: [
                  headerCell('Count', 42.5),
                  headerCell('Limit', 42.5),
                ],
              ),
            ],
          ),
          headerCell('Is Open', 50.0),
          headerCell('Meeting Time', 155.0),
          headerCell('Campus', 60.0),
          headerCell('Fee   ', 40.0),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Column _scheduleView() {
    return Column(
      children: [
        ScheduleView().build(),
        const SizedBox(height: 10),
        headerRow(),
        Expanded(
          child: ClassList(
            Filters().savedClasses(),
            size: ClassListSize.medium,
            quarters: qtrs,
          ),
        ),
      ],
    );
  }

  Widget _selectedTab() {
    if (_selectedIndex == 0) {
      return ClassListPage(
        header: headerRow(),
        size: ClassListSize.medium,
        quarters: qtrs,
      );
    } else if (_selectedIndex == 1) {
      return _scheduleView();
    } else if (_selectedIndex == 2) {
      return const ClassHistoryPage();
    } else {
      return Center(child: Text('Tab $_selectedIndex not found'));
    }
  }
}
