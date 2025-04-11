import 'package:client/domain/class.dart';
import 'package:client/domain/data_handler.dart';
import 'package:client/domain/filters.dart';
import 'package:client/views/abstract_view.dart';
import 'package:client/views/schedule_view.dart';
import 'package:client/views/search_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SmallView extends AbstractView {
  const SmallView({super.key});

  @override
  SmallViewState createState() => SmallViewState();
}

class SmallViewState extends AbstractViewState {
  Class? detailsForClass;
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
            ],
          ),
        );
      },
    );
  }

  Widget _classListView(List<Class> classes) {
    classes.sort();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          child: Text(
            key: const Key('Class Count'),
            '${classes.length} classes (from ${DataHandler.dateTime})',
          ),
        ),
        Expanded(child: _rowBuilder(classes)),
      ],
    );
  }

  Row _classRow(Class aClass, int index, BuildContext context) {
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
    final credits =
        aClass.course.creditsMax == aClass.course.creditsMin
            ? '${aClass.course.creditsMax}'
            : '${aClass.course.creditsMin}-${aClass.course.creditsMax}';
    return Row(
      key: Key('Class $index'),
      children: [
        savedBox(aClass, index),
        Stack(
          children: [
            _summaryView(
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
                  child: _detailsView(index, room, schedule, profs, aClass),
                )
                : Align(alignment: Alignment.center, child: Container()),
          ],
        ),
      ],
    );
  }

  ElevatedButton _detailsButton(Class aClass) {
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

  Container _detailsView(
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

  Widget? _drawer() => _selectedIndex == 0 ? SearchDrawer() : null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ListView _rowBuilder(List<Class> data) {
    return ListView.builder(
      key: const Key('Results'),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _classRow(data[index], index, context);
      },
    );
  }

  Column _scheduleView() {
    return Column(
      children: [
        ScheduleView().build(),
        const SizedBox(height: 10),
        Expanded(
          child: _classListView(Filters().savedClassesForScheduleTerm()),
        ),
      ],
    );
  }

  Widget _selectedTab() {
    if (_selectedIndex == 0) {
      return _classListView(Filters().classes);
    } else if (_selectedIndex == 1) {
      return _scheduleView();
    } else {
      return Center(child: Text('Tab $_selectedIndex not found'));
    }
  }

  SizedBox _summaryView(
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
                      _detailsButton(aClass),
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
}
