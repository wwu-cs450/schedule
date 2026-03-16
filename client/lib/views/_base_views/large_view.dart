import 'package:client/domain/filters.dart';
import 'package:client/views/_base_views/abstract_view.dart';
import 'package:client/views/_shared_components/navigation_bar.dart';
import 'package:client/views/class_list/class_list.dart';
import 'package:client/views/class_list/class_list_page.dart';
import 'package:client/views/schedule_view.dart';
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
          body: selectedTab(
            _selectedIndex,
            ClassListPage(size: .large, quarters: qtrs),
            _scheduleView(),
          ),
          bottomNavigationBar: ScheduleNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
          ),
        );
      },
    );
  }

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

  Column _scheduleView() {
    return Column(
      children: [
        ScheduleView().build(),
        const SizedBox(height: 10),
        headerRow(),
        Expanded(
          child: ClassList(
            Filters().savedClasses(),
            size: ClassListSize.large,
            quarters: qtrs,
          ),
        ),
      ],
    );
  }
}
