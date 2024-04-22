import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/views/main_view.dart';
import 'package:schedule_client/views/schedule_view.dart';

class MediumView extends MainView {
  MediumView(super.startYear, super.results);

  Row mediumHeaderRow() {
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
                  headerCell('Class Number', 120),
                  headerCell('Subject', 80.0),
                  headerCell('Sum $startYear', 70.0),
                  headerCell('Aut $startYear', 70.0),
                  headerCell('Wtr ${startYear + 1}', 70.0),
                  headerCell('Spr ${startYear + 1}', 70.0),
                  headerCell('Sum ${startYear + 1}', 70.0),
                  headerCell('Sec', 40.0),
                  headerCell('GS', 45.0),
                  headerCell('Enroll Count', 85.0),
                  headerCell('Enroll Limit', 85.0),
                  headerCell('Status', 70.0),
                  headerCell('Waitlist', 65.0),
                ],
              ),
              Row(
                children: [
                  headerCell('Course Title', 310.0),
                  headerCell('Credits', 70.0),
                  headerCell('Meeting Time', 155.0),
                  headerCell('Classroom', 100.0),
                  headerCell('Instructor(s)', 150.0),
                  headerCell('Campus', 80.0),
                  headerCell('Fee', 70.0),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row mediumClassRow(
    Class aClass,
    int index,
  ) {
    final h = aClass.getLineHeight();
    // Default, Summer, Fall, Winter, Spring
    final aColor = getColor(index);
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
      key: Key('Class $index'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        savedBox(aClass, index),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              Row(
                children: [
                  cell('ClassNumber', aClass.getClN(), 120, aColor[0], h),
                  cell('Subject', aClass.getCode(), 80.0, aColor[0], h),
                  cell('Summer1', getTerm(aClass, qtrs[0]), 70.0, aColor[1], h),
                  cell('Fall', getTerm(aClass, qtrs[1]), 70.0, aColor[2], h),
                  cell('Winter', getTerm(aClass, qtrs[2]), 70.0, aColor[3], h),
                  cell('Spring', getTerm(aClass, qtrs[3]), 70.0, aColor[4], h),
                  cell('Summer2', getTerm(aClass, qtrs[4]), 70.0, aColor[1], h),
                  cell('Section', aClass.section, 40.0, aColor[0], h),
                  cell('GS', gs, 45.0, aColor[0], h),
                  cell('Enrollment', enroll[0].trim(), 85.0, aColor[0], h),
                  cell('EnrollmentLimit', enroll[1].trim(), 85.0, aColor[0], h),
                  cell('Status', status, 70.0, aColor[0], h),
                  cell('WaitlistSize', aClass.getWList(), 65.0, aColor[0], h),
                ],
              ),
              Row(
                children: [
                  cell('Title', aClass.getTitle(), 310.0, aColor[0], h),
                  cell('Credits', credits, 70.0, aColor[0], h),
                  cell('Schedule', schedule, 155.0, aColor[0], h),
                  cell('Classroom', room, 100.0, aColor[0], h),
                  cell('Instructors', profs, 150.0, aColor[0], h),
                  cell('Campus', aClass.getCampus(), 80.0, aColor[0], h),
                  cell('Fee', aClass.getFee(), 70.0, aColor[0], h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  ListView mediumRowBuilder(List<Class> data) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return mediumClassRow(
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
            mediumHeaderRow(),
            Expanded(child: mediumRowBuilder(results.classes)),
          ],
        );
      case 1:
        // Schedule Page
        return Column(
          children: [
            ScheduleView().build(),
            mediumHeaderRow(),
            Expanded(child: mediumRowBuilder(results.savedData)),
          ],
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }
}
