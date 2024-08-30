import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/views/main_view.dart';
import 'package:schedule_client/views/schedule_view.dart';

class WideView extends MainView {
  WideView(super.startYear, super.results);

  Widget wideHeaderRow() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          invisibleBox(),
          headerCell('Class#', 45),
          headerCell('Subject', 50.0),
          headerCell('Sum ${startYear % 1000}', 50.0),
          headerCell('Aut ${startYear % 1000}', 50.0),
          headerCell('Wtr ${(startYear + 1) % 1000}', 50.0),
          headerCell('Spr ${(startYear + 1) % 1000}', 50.0),
          headerCell('Sum ${(startYear + 1) % 1000}', 50.0),
          headerCell('Sec', 40.0),
          headerCell('GS', 30.0),
          headerCell('Cr', 40.0),
          headerCell('Course Title', 300.0),
          headerCell('Status', 55.0),
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

  Widget wideClassRow(
    Class aClass,
    int index,
  ) {
    final color = getColor(index);
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Color(color[0]),
          ),
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
                cell('GS', gs, 30.0, color[0]),
                cell('Cr', credits, 40.0, color[0]),
                cell('Title', aClass.getTitle(), 300.0, color[0]),
                cell('Status', status, 55.0, color[0]),
                cell('Enrollment', enroll[0], 55.0, color[0], 'r'),
                cell('EnrollmentLimit', enroll[1], 55.0, color[0], 'r'),
                cell('WaitlistSize', aClass.getWList(), 55.0, color[0], 'r'),
                cell('Fee', '${aClass.getFee()}   ', 75.0, color[0], 'r'),
                cell('Schedule', schedule, 180.0, color[0]),
                cell('Classroom', room, 80.0, color[0]),
                cell('Instructors', profs, 200.0, color[0]),
                cell('Campus', aClass.getCampus(), 60.0, color[0]),
                cell('Video', aClass.video, 50.0, color[0]),
                cell('Consent', aClass.consent, 190.0, color[0]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ListView wideRowBuilder(List<Class> data) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return wideClassRow(
          data[index],
          index,
        );
      },
    );
  }

  @override
  Widget view(
    int index,
    BuildContext context,
  ) {
    switch (index) {
      case 0:
        // Main Page
        return Column(
          children: [
            Semantics(
              child: Text(
                key: const Key('Class Found'),
                '${results.classes.length} classes found.',
              ),
            ),
            wideHeaderRow(),
            Expanded(
              child: wideRowBuilder(results.classes),
            ),
          ],
        );
      case 1:
        // Schedule Page
        return Column(
          children: [
            ScheduleView().build(),
            const SizedBox(height: 10),
            wideHeaderRow(),
            Expanded(child: wideRowBuilder(results.savedData)),
          ],
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }
}
