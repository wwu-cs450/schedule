import 'package:client/domain/class.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/general_studies.dart';
import 'package:client/views/class_list/class_list_cell.dart';
import 'package:flutter/material.dart';

enum ClassListSize { small, medium, large }

class ClassList extends StatefulWidget {
  const ClassList(
    this.data, {
    required this.size,
    required this.quarters,
    super.key,
  });

  final List<Class> data;
  final ClassListSize size;
  final List<String> quarters;

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  Class? detailsForClass;
  int startYear = Filters().term.startYear();

  List<int> getColor(int index) {
    if (index % 2 == 0) {
      return [0xFFc2c2c2, 0xFFf1f276, 0xFFf2b600, 0xFF8ca2bd, 0xFF53b573];
    } else {
      return [0xFFdbdbdb, 0xFFfeffa4, 0xFFffd34d, 0xFFb4c4d8, 0xFF8ad2a1];
    }
  }

  String getTerm(Class aClass, String key) {
    String term;
    if (key == 'Sum $startYear') {
      term = 'Summer $startYear';
    } else if (key == 'Fal $startYear') {
      term = 'Fall $startYear';
    } else if (key == 'Wtr ${startYear + 1}') {
      term = 'Winter ${startYear + 1}';
    } else if (key == 'Spr ${startYear + 1}') {
      term = 'Spring ${startYear + 1}';
    } else {
      term = 'Summer ${startYear + 1}';
    }
    if (aClass.term.name == term) {
      return aClass.course.number;
    } else {
      return ' ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        switch (widget.size) {
          case ClassListSize.large:
            return largeClassRow(widget.data[index], index);
          case ClassListSize.medium:
            return mediumClassRow(widget.data[index], index);
          case ClassListSize.small:
            return smallClassRow(widget.data[index], index, context);
        }
      },
    );
  }

  Widget smallClassRow(Class aClass, int index, BuildContext context) {
    String getFee() {
      if (aClass.getFee() == '0') {
        return 'No fee';
      } else {
        return '${aClass.getFee()} fee';
      }
    }

    String gsCheck() {
      return aClass.course.isGeneralStudies ? 'GS' : 'Not GS';
    }

    final term = aClass.term.name.split(' ')[0];
    final cNum = aClass.course.number;
    final room = aClass.classroom;
    final schedule = aClass.schedule.toString(is24hr: false);
    final profs = aClass.getInstructors();
    final credits = aClass.course.creditsMax == aClass.course.creditsMin
        ? '${aClass.course.creditsMax}'
        : '${aClass.course.creditsMin}-${aClass.course.creditsMax}';
    return Row(
      key: Key('Class $index'),
      children: [
        _savedBox(aClass, index),
        Stack(
          children: [
            _smallSummaryView(
              context,
              aClass,
              index,
              cNum,
              gsCheck,
              getFee,
              term,
              credits,
            ),
            aClass == detailsForClass
                ? Align(
                    alignment: Alignment.center, // Center the details container
                    child: _smallDetailsView(
                      index,
                      room,
                      schedule,
                      profs,
                      aClass,
                    ),
                  )
                : Align(alignment: Alignment.center, child: Container()),
          ],
        ),
      ],
    );
  }

  Widget mediumClassRow(Class aClass, int index) {
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
                _savedBox(aClass, index, bkgndColor: aColor[0]),
                ClassListCell('ClassNumber', aClass.getClN(), 50, aColor[0]),
                ClassListCell('Subject', subj, 90.0, aColor[0]),
                ClassListCell('Section', aClass.section, 30.0, aColor[0]),
                _termCell(aClass, aColor),
                ClassListCell('Title', aClass.getTitle(), 200.0, aColor[0]),
                ClassListCell('Credits', credits, 30.0, aColor[0]),
                ClassListCell('General Studies', gs, 30.0, aColor[0]),
                ClassListCell(
                  'Count',
                  '${enroll[0].trim()}  ',
                  42.5,
                  aColor[0],
                  'r',
                ),
                ClassListCell(
                  'Limit',
                  '${enroll[1].trim()}  ',
                  42.5,
                  aColor[0],
                  'r',
                ),
                _tooltipCell(
                  'Is Open',
                  status,
                  'Waitlist: ${aClass.getWList()}',
                  50.0,
                  aColor[0],
                ),
                _tooltipCell(
                  'Schedule',
                  schedule,
                  'Room: $room\nInstructor(s): $profs',
                  155.0,
                  aColor[0],
                ),
                ClassListCell('Campus', aClass.getCampus(), 60.0, aColor[0]),
                ClassListCell(
                  'Fee',
                  '${aClass.getFee()}  ',
                  40.0,
                  aColor[0],
                  'r',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget largeClassRow(Class aClass, int index) {
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
                _savedBox(aClass, index, bkgndColor: color[0]),
                ClassListCell('Class Number', aClass.getClN(), 45, color[0]),
                ClassListCell('Subject', aClass.getCode(), 50.0, color[0]),
                ClassListCell(
                  'Summer1',
                  getTerm(aClass, widget.quarters[0]),
                  50.0,
                  color[1],
                ),
                ClassListCell(
                  'Fall',
                  getTerm(aClass, widget.quarters[1]),
                  50.0,
                  color[2],
                ),
                ClassListCell(
                  'Winter',
                  getTerm(aClass, widget.quarters[2]),
                  50.0,
                  color[3],
                ),
                ClassListCell(
                  'Spring',
                  getTerm(aClass, widget.quarters[3]),
                  50.0,
                  color[4],
                ),
                ClassListCell(
                  'Summer2',
                  getTerm(aClass, widget.quarters[4]),
                  50.0,
                  color[1],
                ),
                ClassListCell('Section', aClass.section, 40.0, color[0], 'c'),
                aClass.course.isGeneralStudies
                    ? Tooltip(
                        // Show the General Studies category on hover
                        message:
                            gsCategory ??
                            '(General Studies category not found)',
                        child: ClassListCell(
                          'General Studies',
                          'GS',
                          30.0,
                          color[0],
                        ),
                      )
                    : ClassListCell('General Studies', '', 30.0, color[0]),
                ClassListCell('Cr', credits, 40.0, color[0]),
                ClassListCell('Title', aClass.getTitle(), 300.0, color[0]),
                ClassListCell('Is Open', status, 55.0, color[0]),
                ClassListCell('Enrollment', enroll[0], 55.0, color[0], 'r'),
                ClassListCell(
                  'EnrollmentLimit',
                  enroll[1],
                  55.0,
                  color[0],
                  'r',
                ),
                ClassListCell(
                  'WaitlistSize',
                  aClass.getWList(),
                  55.0,
                  color[0],
                  'r',
                ),
                ClassListCell(
                  'Fee',
                  '${aClass.getFee()}   ',
                  75.0,
                  color[0],
                  'r',
                ),
                ClassListCell('Schedule', schedule, 180.0, color[0]),
                ClassListCell('Classroom', room, 80.0, color[0]),
                ClassListCell('Instructors', profs, 200.0, color[0]),
                ClassListCell('Campus', aClass.getCampus(), 60.0, color[0]),
                ClassListCell('Video', '', 50.0, color[0], 'c', aClass.video),
                ClassListCell('Consent', aClass.consent, 190.0, color[0]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _savedBox(Class aClass, int index, {int? bkgndColor}) {
    return Semantics(
      label: 'Class saving checkbox.',
      hint: 'Click on this to save a class for later.',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        width: 30,
        child: Checkbox(
          key: Key('Class $index save box'),
          value: aClass.saved,
          onChanged: (bool? value) {
            setState(() {
              aClass.saved = value!;
            });
          },
        ),
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
    return ClassListCell(quarter, term, 70.0, color);
  }

  Widget _tooltipCell(
    String keyString,
    String input,
    String tooltip,
    double width,
    int bkgndColor,
  ) {
    return Semantics(
      label: '$keyString cell.',
      hint: 'The $keyString for this row is $input.',
      child: Tooltip(
        key: const Key('Hover Cell'),
        message: tooltip,
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          width: width,
          decoration: BoxDecoration(
            color: Color(bkgndColor),
            border: Border.all(color: Colors.white, width: 0.5),
          ),
          padding: const EdgeInsets.all(5),
          child: Text(
            key: Key('$keyString Cell'),
            input,
            style: const TextStyle(color: Color(0xFF00003e), fontSize: 12),
          ),
        ),
      ),
    );
  }

  // Small View Widgets

  Widget _smallSummaryView(
    BuildContext context,
    Class aClass,
    int index,
    String cNum,
    String Function() gsCheck,
    String Function() getFee,
    String term,
    String credits,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Card(
        color: Color.fromARGB(255, 236, 222, 199),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: aClass.saved ? Colors.blue : Colors.black,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10.0),
        key: Key('Class $index card'),
        elevation: 5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      key: const Key('Subject Row'),
                      '${aClass.getCode()} $cNum',
                    ),
                    Text(key: const Key('GS Row'), gsCheck()),
                    Text(key: const Key('Fee Row'), getFee()),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 1),
            Expanded(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1, color: Colors.black),
                    left: BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        '${aClass.getTitle()}\n',
                      ),
                      _smallDetailsButton(aClass),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 2),
            SizedBox(
              width: 125,
              // height: 100,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(key: Key('$term Row'), aClass.term.name),
                    Text(
                      key: const Key('Cr Row'),
                      'Credits: ${credits.trim()}',
                    ),
                    Text(key: const Key('Campus Row'), aClass.getCampus()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallDetailsView(
    int index,
    String room,
    String schedule,
    String profs,
    Class aClass,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF656950),
      ),
      margin: const EdgeInsets.all(10.0),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: SizedBox(
          child: Column(
            key: Key('Detail Row $index'),
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 1, color: Colors.black),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              const Text('Room(s)'),
                              Text(key: const Key('Room Row'), room),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 185,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: Column(
                          children: [
                            const Text('Schedule'),
                            Text(key: const Key('Schedule Row'), schedule),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 1, color: Colors.black),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              const Text('Instructor(s)'),
                              Text(key: const Key('Instructor Row'), profs),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SizedBox(
                        width: 30,
                        child: TextButton(
                          onPressed: () => detailsForClass = null,
                          style: ButtonStyle(
                            textStyle:
                                WidgetStateProperty.resolveWith<TextStyle?>(
                                  (states) => const TextStyle(fontSize: 15),
                                ),
                            fixedSize: WidgetStateProperty.all(
                              const Size.fromWidth(10),
                            ),
                          ),
                          child: Text(
                            'X',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 90,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(textAlign: TextAlign.center, 'Video'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 185,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Text(textAlign: TextAlign.center, aClass.consent),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 1, color: Colors.black),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          key: const Key('Status Row'),
                          textAlign: TextAlign.center,
                          aClass.isOpenForEnrollment ? 'Open' : 'Closed',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallDetailsButton(Class aClass) {
    return ElevatedButton(
      key: const Key('Details Button'),
      onPressed: () => detailsForClass = aClass,
      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF656950)),
      child: const Text(
        'Details',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
