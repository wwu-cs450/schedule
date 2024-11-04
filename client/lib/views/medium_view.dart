import 'package:client/domain/class.dart';
import 'package:client/views/audit_view.dart';
import 'package:client/views/main_view.dart';
import 'package:client/views/schedule_view.dart';
import 'package:flutter/material.dart';

class MediumView extends MainView {
  MediumView(super.startYear, super.results);

  Row mediumHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Opacity(opacity: 0, child: invisibleBox()),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.white),
          ),
          position: DecorationPosition.foreground,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    headerCell('Status', 50.0),
                    headerCell('Meeting Time', 155.0),
                    headerCell('Campus', 60.0),
                    headerCell('Fee   ', 40.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget mediumTermCell(Class aClass, List<int> colors) {
    late int color;
    String term = mediumTerm(aClass);
    final cellKey = term.split(' ')[0];
    if (term == 'Summer $startYear') {
      term = 'Sum $startYear';
      color = colors[1];
    } else if (term == 'Fall $startYear') {
      term = 'Aut $startYear';
      color = colors[2];
    } else if (term == 'Winter ${startYear + 1}') {
      term = 'Wtr ${startYear + 1}';
      color = colors[3];
    } else if (term == 'Spring ${startYear + 1}') {
      term = 'Spr ${startYear + 1}';
      color = colors[4];
    } else if (term == 'Summer ${startYear + 1}') {
      term = 'Sum ${startYear + 1}';
      color = colors[1];
    }
    return cell(cellKey, term, 70.0, color);
  }

  Widget mediumClassRow(
    Class aClass,
    int index,
  ) {
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
          decoration: BoxDecoration(
            color: Color(aColor[0]),
          ),
          position: DecorationPosition.background,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                savedBox(aClass, index, bkgndColor: aColor[0]),
                cell('ClassNumber', aClass.getClN(), 50, aColor[0]),
                cell('Subject', subj, 90.0, aColor[0]),
                cell('Section', aClass.section, 30.0, aColor[0]),
                mediumTermCell(aClass, aColor),
                cell('Title', aClass.getTitle(), 200.0, aColor[0]),
                cell('Credits', credits, 30.0, aColor[0]),
                cell('GS', gs, 30.0, aColor[0]),
                cell('Count', '${enroll[0].trim()}  ', 42.5, aColor[0], 'r'),
                cell('Limit', '${enroll[1].trim()}  ', 42.5, aColor[0], 'r'),
                tooltipCell(
                  'Status',
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
            mediumHeaderRow(),
            Expanded(child: mediumRowBuilder(results.classes)),
          ],
        );
      case 1:
        // Schedule Page
        return Column(
          children: [
            ScheduleView().build(),
            const SizedBox(height: 10),
            mediumHeaderRow(),
            Expanded(child: mediumRowBuilder(results.savedData)),
          ],
        );
      case 2:
        // Audit Page
        return const AuditView();
      default:
        return const Column(children: [Placeholder()]);
    }
  }
}
