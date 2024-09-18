import 'package:client/domain/class.dart';
import 'package:client/main.dart';
import 'package:client/views/main_view.dart';
import 'package:client/views/schedule_view.dart';
import 'package:flutter/material.dart';

class SmallView extends MainView {
  SmallView(super.startYear, super.results);

  Row smallClassRow(Class aClass, int index, BuildContext context) {
    String getFee() {
      if (aClass.getFee() == '0') {
        return 'No fee';
      } else {
        return '${aClass.getFee()} fee';
      }
    }

    String gsCheck() {
      if (aClass.course.isGeneralStudies) {
        return 'GS';
      } else {
        return 'Not GS';
      }
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
        savedBox(aClass, index),
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Card(
                shape: StadiumBorder(
                  side: BorderSide(
                    width: 1,
                    color: aClass.saved ? Colors.blue : Colors.black,
                  ),
                ),
                margin: const EdgeInsets.all(10.0),
                key: Key('Class $index card'),
                elevation: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
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
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: [
                            Text(
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              '${aClass.getTitle()}\n',
                            ),
                            ElevatedButton(
                              key: const Key('Details Button'),
                              onPressed: () => {
                                results.updateInfo(index),
                              },
                              child: const Text('Tap for more details.'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      width: 125,
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
                              Text(
                                key: Key('$term Row'),
                                aClass.term.name,
                              ),
                              Text(
                                key: const Key('Cr Row'),
                                'Credits: ${credits.trim()}',
                              ),
                              Text(
                                key: const Key('Campus Row'),
                                aClass.getCampus(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            results.smallRowInfo[index]
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                      color: const Color.fromARGB(255, 240, 236, 220),
                    ),
                    margin: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      child: Column(
                        key: Key('Detail Row $index'),
                        children: [
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.black,
                                ),
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
                                        right: BorderSide(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          const Text('Room(s)'),
                                          Text(
                                            key: const Key('Room Row'),
                                            room,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 185,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 15.0,
                                      bottom: 15.0,
                                    ),
                                    child: Column(
                                      children: [
                                        const Text('Schedule'),
                                        Text(
                                          key: const Key('Schedule Row'),
                                          schedule,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 140,
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          const Text('Instructor(s)'),
                                          Text(
                                            key: const Key('Instructor Row'),
                                            profs,
                                          ),
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
                                      onPressed: () => {
                                        results.updateInfo(index),
                                      },
                                      style: ButtonStyle(
                                        textStyle: WidgetStateProperty
                                            .resolveWith<TextStyle?>(
                                          (states) =>
                                              const TextStyle(fontSize: 15),
                                        ),
                                        fixedSize: WidgetStateProperty.all(
                                          const Size.fromWidth(10),
                                        ),
                                      ),
                                      child: const Text('X'),
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
                                      right: BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Video',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 185,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                    bottom: 15.0,
                                  ),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    aClass.consent,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 140,
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      key: const Key('Status Row'),
                                      textAlign: TextAlign.center,
                                      aClass.isOpenForEnrollment
                                          ? 'Open'
                                          : 'Closed',
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
                  )
                : Container(),
          ],
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
          context,
        );
      },
    );
  }

  @override
  Widget view(
    int index,
    BuildContext context,
    // Function searchCriteriaWidget,
  ) {
    switch (index) {
      case 0:
        // Main Page
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              child: Text(
                key: const Key('Class Found'),
                '${results.classes.length} classes found.',
              ),
            ),
            Expanded(child: smallRowBuilder(results.classes)),
          ],
        );
      case 1:
        // Schedule Page
        return Column(
          children: [
            ScheduleView().build(),
            const SizedBox(height: 10),
            Expanded(child: smallRowBuilder(results.scheduleData)),
          ],
        );
      default:
        return const Column(children: [Placeholder()]);
    }
  }
}
