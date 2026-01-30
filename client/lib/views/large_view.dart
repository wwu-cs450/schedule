import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/general_studies.dart';
import 'package:client/views/abstract_view.dart';
import 'package:client/views/pdf_upload_page.dart';
import 'package:client/views/schedule_view.dart';
import 'package:client/views/search_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LargeView extends AbstractView {
  const LargeView({super.key});

  @override
  LargeViewState createState() => LargeViewState();
}

class LargeViewState extends AbstractViewState {
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
                key: Key('Pdf Page'),
                icon: Icon(Icons.file_upload),
                label: 'PDF Upload',
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
    final color = getColor(index);
    final gsCategory = GeneralStudies.findCategory(aClass.course.title);
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: Color(color[0])),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              key: Key('Class $index'),
              children: [
                savedBox(aClass, index, bkgndColor: color[0]),
                cell('Class Number', aClass.getClN(), 45, color[0]),
                cell('Subject', aClass.getCode(), 50.0, color[0]),
                cell('Summer1', getTerm(aClass, qtrs[0]), 50.0, color[1]),
                cell('Fall', getTerm(aClass, qtrs[1]), 50.0, color[2]),
                cell('Winter', getTerm(aClass, qtrs[2]), 50.0, color[3]),
                cell('Spring', getTerm(aClass, qtrs[3]), 50.0, color[4]),
                cell('Summer2', getTerm(aClass, qtrs[4]), 50.0, color[1]),
                cell('Section', aClass.section, 40.0, color[0], 'c'),
                aClass.course.isGeneralStudies
                    ? Tooltip(
                        // Show the General Studies category on hover
                        message:
                            gsCategory ??
                            '(General Studies category not found)',
                        child: cell('General Studies', 'GS', 30.0, color[0]),
                      )
                    : cell('General Studies', '', 30.0, color[0]),
                cell('Cr', credits, 40.0, color[0]),
                cell('Title', aClass.getTitle(), 300.0, color[0]),
                cell('Is Open', status, 55.0, color[0]),
                cell('Enrollment', enroll[0], 55.0, color[0], 'r'),
                cell('EnrollmentLimit', enroll[1], 55.0, color[0], 'r'),
                cell('WaitlistSize', aClass.getWList(), 55.0, color[0], 'r'),
                cell('Fee', '${aClass.getFee()}   ', 75.0, color[0], 'r'),
                cell('Schedule', schedule, 180.0, color[0]),
                cell('Classroom', room, 80.0, color[0]),
                cell('Instructors', profs, 200.0, color[0]),
                cell('Campus', aClass.getCampus(), 60.0, color[0]),
                cell('Video', '', 50.0, color[0], 'c', aClass.video),
                cell('Consent', aClass.consent, 190.0, color[0]),
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
          headerCell('Class#', 45),
          headerCell('Subject', 50.0),
          headerCell('Sum ${startYear % 1000}', 50.0),
          headerCell('Fal ${startYear % 1000}', 50.0),
          headerCell('Wtr ${(startYear + 1) % 1000}', 50.0),
          headerCell('Spr ${(startYear + 1) % 1000}', 50.0),
          headerCell('Sum ${(startYear + 1) % 1000}', 50.0),
          headerCell('Sec', 40.0),
          headerCell('GS', 30.0),
          headerCell('Cr', 40.0),
          headerCell('Course Title', 300.0),
          headerCell('Is Open', 55.0),
          headerCell('Count', 55.0),
          headerCell('Limit', 55.0),
          headerCell('Waitlist', 55.0),
          headerCell('Fee   ', 75.0),
          headerCell('Meeting Time', 180.0),
          headerCell('Classroom', 80.0),
          headerCell('Instructor(s)', 200.0),
          headerCell('Campus', 60.0),
          headerCell('Video', 50.0),
          headerCell('Consent', 190.0),
        ],
      ),
    );
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
      return const PdfView();
    } else {
      return Center(child: Text('Tab $_selectedIndex not found'));
    }
  }
}
