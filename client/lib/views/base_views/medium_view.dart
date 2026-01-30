import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/views/base_views/abstract_view.dart';
import 'package:client/views/class_history_page.dart';
import 'package:client/views/schedule_view.dart';
import 'package:client/views/search_drawer.dart';
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
          drawer: _drawer(),
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

  Widget _classListView() {
    final classes = Filters().classes;
    return Column(
      children: [
        Center(
          child: Semantics(
            child: Text(
              key: const Key('Class Count'),
              '${classes.length} classes (from ${DataHandler.dateTime})',
            ),
          ),
        ),
        headerRow(),
        Expanded(child: rowBuilder(classes)),
      ],
    );
  }

  Widget classRow(Class aClass, int index) {
    // Default, Summer, Fall, Winter, Spring
    final cNum = aClass.course.number;
    final subj = '${aClass.getCode()} $cNum';
    final aColor = getColor(index);
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final room = aClass.classroom;
    final schedule = aClass.schedule.toString(is24hr: false);
    final profs = aClass.getInstructors();

    final credits = aClass.course.creditsMax == aClass.course.creditsMin
        ? '${aClass.course.creditsMax}'
        : '${aClass.course.creditsMin}-${aClass.course.creditsMax}';
    final enroll = [
      aClass.currEnrollment.toString(),
      aClass.maxEnrollment.toString(),
    ];

    return Row(
      key: Key('Class $index'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: Color(aColor[0])),
          position: DecorationPosition.background,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                savedBox(aClass, index, bkgndColor: aColor[0]),
                cell('ClassNumber', aClass.getClN(), 50, aColor[0]),
                cell('Subject', subj, 90.0, aColor[0]),
                cell('Section', aClass.section, 30.0, aColor[0]),
                _termCell(aClass, aColor),
                cell('Title', aClass.getTitle(), 200.0, aColor[0]),
                cell('Credits', credits, 30.0, aColor[0]),
                cell('General Studies', gs, 30.0, aColor[0]),
                cell('Count', '${enroll[0].trim()}  ', 42.5, aColor[0], 'r'),
                cell('Limit', '${enroll[1].trim()}  ', 42.5, aColor[0], 'r'),
                tooltipCell(
                  'Is Open',
                  status,
                  'Waitlist: ${aClass.getWList()}',
                  50.0,
                  aColor[0],
                ),
                tooltipCell(
                  'Schedule',
                  schedule,
                  'Room: $room\nInstructor(s): $profs',
                  155.0,
                  aColor[0],
                ),
                cell('Campus', aClass.getCampus(), 60.0, aColor[0]),
                cell('Fee', '${aClass.getFee()}  ', 40.0, aColor[0], 'r'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? _drawer() => _selectedIndex == 0 ? SearchDrawer() : null;

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

  Widget _termCell(Class aClass, List<int> colors) {
    late int color;
    String term = aClass.term.name;
    final pieces = term.split(' ');
    final quarter = pieces[0];
    final year = pieces[1];
    if (quarter == 'Summer') {
      term = 'Sum $year';
      color = colors[1];
    } else if (quarter == 'Fall') {
      term = 'Fal $year';
      color = colors[2];
    } else if (quarter == 'Winter') {
      term = 'Wtr $year';
      color = colors[3];
    } else if (quarter == 'Spring') {
      term = 'Spr $year';
      color = colors[4];
    }
    return cell(quarter, term, 70.0, color);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ListView rowBuilder(List<Class> data) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return classRow(data[index], index);
      },
    );
  }

  Column _scheduleView() {
    return Column(
      children: [
        ScheduleView().build(),
        const SizedBox(height: 10),
        headerRow(),
        Expanded(child: rowBuilder(Filters().savedClasses())),
      ],
    );
  }

  Widget _selectedTab() {
    if (_selectedIndex == 0) {
      return _classListView();
    } else if (_selectedIndex == 1) {
      return _scheduleView();
    } else if (_selectedIndex == 2) {
      return const ClassHistoryPage();
    } else {
      return Center(child: Text('Tab $_selectedIndex not found'));
    }
  }
}
