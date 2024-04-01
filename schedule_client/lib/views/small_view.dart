import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/views/main_view.dart';
import 'package:schedule_client/views/schedule_view.dart';

class SmallView extends MainView {
  SmallView(super.startYear, super.results);

  Row smallHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(opacity: 0, child: invisibleBox()),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  headerCell('Class\nNumber', 120),
                  headerCell('Subject\n', 80.0),
                  headerCell('Sum\n$startYear', 55.0),
                  headerCell('Aut\n$startYear', 55.0),
                  headerCell('Wtr\n${startYear + 1}', 55.0),
                  headerCell('Spr\n${startYear + 1}', 55.0),
                  headerCell('Sum\n${startYear + 1}', 55.0),
                  headerCell('Sec\n', 40.0),
                  headerCell('Credits\n', 70.0),
                ],
              ),
              Row(
                children: [
                  headerCell('Course Title', 310.0),
                  headerCell('GS', 40.0),
                  headerCell('Enroll Count', 85.0),
                  headerCell('Enroll Limit', 85.0),
                  headerCell('Waitlist', 65.0),
                ],
              ),
              Row(
                children: [
                  headerCell('Meeting Time', 155.0),
                  headerCell('Classroom', 80.0),
                  headerCell('Instructor(s)'.toString(), 150.0),
                  headerCell('Campus', 60.0),
                  headerCell('Fee', 70.0),
                  headerCell('Status', 70.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row smallClassRow(
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
      key: const Key('Class'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        savedBox(aClass), // create a checkbox for the row
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  cell('ClassNumber', aClass.getClN(), 120, color[0], h),
                  cell('Subject', aClass.getCode(), 80.0, color[0], h),
                  cell('Summer1', getTerm(aClass, qtrs[0]), 55.0, color[1], h),
                  cell('Fall', getTerm(aClass, qtrs[1]), 55.0, color[2], h),
                  cell('Winter', getTerm(aClass, qtrs[2]), 55.0, color[3], h),
                  cell('Spring', getTerm(aClass, qtrs[3]), 55.0, color[4], h),
                  cell('Summer2', getTerm(aClass, qtrs[4]), 55.0, color[1], h),
                  cell('Section', aClass.section, 40.0, color[0], h),
                  cell('Credits', credits, 70.0, color[0], h),
                ],
              ),
              Row(
                children: [
                  cell('Title', aClass.getTitle(), 310.0, color[0], h),
                  cell('GS', gs, 40.0, color[0], h),
                  cell('Enrollment', enroll[0], 85.0, color[0], h),
                  cell('EnrollmentLimit', enroll[1], 85.0, color[0], h),
                  cell('WaitlistSize', aClass.getWList(), 65.0, color[0], h),
                ],
              ),
              Row(
                children: [
                  cell('Schedule', schedule, 155.0, color[0], h),
                  cell('Classroom', room, 80.0, color[0], h),
                  cell('Instructors', profs, 150.0, color[0], h),
                  cell('Campus', aClass.getCampus(), 60.0, color[0], h),
                  cell('Fee', aClass.getFee(), 70.0, color[0], h),
                  cell('Status', status, 70.0, color[0], h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView smallRowBuilder(List<Class> data) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return smallClassRow(
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
            smallHeaderRow(),
            Expanded(child: smallRowBuilder(results.classes)),
          ],
        );
      case 1:
        // Saved Classes Page
        return Column(
          children: [
            smallHeaderRow(),
            Expanded(child: smallRowBuilder(results.savedData)),
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
