import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/views/main_view.dart';
import 'package:schedule_client/views/schedule_view.dart';

class WideView extends MainView {
  WideView(super.startYear, super.results);

  Row wideHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0, child: invisibleBox()),
        headerCell('Class#\n', 55),
        headerCell('Subject\n', 45.0),
        headerCell('Sum ${startYear % 1000}\n', 50.0),
        headerCell('Aut ${startYear % 1000}\n', 50.0),
        headerCell('Wtr ${(startYear + 1) % 1000}\n', 50.0),
        headerCell('Spr ${(startYear + 1) % 1000}\n', 50.0),
        headerCell('Sum ${(startYear + 1) % 1000}\n', 50.0),
        headerCell('Sec\n', 40.0),
        headerCell('GS\n', 25.0),
        headerCell('Cr\n', 30.0),
        headerCell('Course Title\n', 300.0),
        headerCell('Status\n', 65.0),
        headerCell('Enroll\nCount', 60.0),
        headerCell('Enroll\nLimit', 60.0),
        headerCell('Waitlist\n', 60.0),
        headerCell('Fee\n', 70.0),
        headerCell('Meeting Time\n', 160.0),
        headerCell('Classroom\n', 80.0),
        headerCell('Instructor(s)\n'.toString(), 200.0),
        headerCell('Campus\n', 60.0),
        headerCell('Video\n', 60.0),
        headerCell('Consent\n', 200.0),
      ],
    );
  }

  Row wideClassRow(
    Class aClass,
    int index,
  ) {
    final h = aClass.getLineHeight();
    final color = getColor(index);
    final gs = aClass.course.isGeneralStudies ? 'GS' : ' ';
    final status = aClass.isOpenForEnrollment ? 'Open' : 'Closed';
    final room = addLinesTo(aClass.classroom, h);
    final schedule = addLinesTo(aClass.schedule.toString(is24hr: false), h);
    final profs = addLinesTo(aClass.getInstructors(), h);
    final credits = addLinesTo(
      aClass.course.creditsMax == aClass.course.creditsMin
          ? '${aClass.course.creditsMax}'
          : '${aClass.course.creditsMin}-${aClass.course.creditsMax}',
      h,
    );
    final enroll = [
      addLinesTo(aClass.currEnrollment.toString(), h),
      addLinesTo(aClass.maxEnrollment.toString(), h),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      key: const Key('Class'),
      children: [
        savedBox(aClass),
        cell('ClassNumber', aClass.getClN(), 55, color[0], h),
        cell('Subject', aClass.getCode(), 45.0, color[0], h),
        cell('Summer1', getTerm(aClass, qtrs[0]), 50.0, color[1], h),
        cell('Fall', getTerm(aClass, qtrs[1]), 50.0, color[2], h),
        cell('Winter', getTerm(aClass, qtrs[2]), 50.0, color[3], h),
        cell('Spring', getTerm(aClass, qtrs[3]), 50.0, color[4], h),
        cell('Summer2', getTerm(aClass, qtrs[4]), 50.0, color[1], h),
        cell('Section', aClass.section, 40.0, color[0], h),
        cell('GS', gs, 25.0, color[0], h),
        cell('Cr', credits, 30.0, color[0], h),
        cell('Title', aClass.getTitle(), 300.0, color[0], h),
        cell('Status', status, 65.0, color[0], h),
        cell('Enrollment', enroll[0], 60.0, color[0], h),
        cell('EnrollmentLimit', enroll[1], 60.0, color[0], h),
        cell('WaitlistSize', aClass.getWList(), 60.0, color[0], h),
        cell('Fee', aClass.getFee(), 70.0, color[0], h),
        cell('Schedule', schedule, 160.0, color[0], h),
        cell('Classroom', room, 80.0, color[0], h),
        cell('Instructors', profs, 200.0, color[0], h),
        cell('Campus', aClass.getCampus(), 60.0, color[0], h),
        cell('Video', aClass.video, 60.0, color[0], h),
        cell('Consent', aClass.consent, 200.0, color[0], h),
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
    Function searchCriteriaWidget,
  ) {
    switch (index) {
      case 0:
        // Main Page
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Color(0xFFa8ac9c)),
                child: searchCriteriaWidget(),
              ),
            ),
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
        // Saved Classes Page
        return Column(
          children: [
            wideHeaderRow(),
            Expanded(
              child: wideRowBuilder(results.savedData),
            ),
          ],
        );
      case 2:
        // Schedule Page
        return SingleChildScrollView(
          child: ScheduleView().build(),
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }
}
