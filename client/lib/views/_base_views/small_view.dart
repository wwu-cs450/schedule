import 'package:client/domain/filters.dart';
import 'package:client/views/_base_views/abstract_view.dart';
import 'package:client/views/_shared_components/navigation_bar.dart';
import 'package:client/views/class_list/class_list.dart';
import 'package:client/views/class_list/class_list_page.dart';
import 'package:client/views/schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SmallView extends AbstractView {
  const SmallView({super.key});

  @override
  SmallViewState createState() => SmallViewState();
}

class SmallViewState extends AbstractViewState {
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
            ClassListPage(size: .small, quarters: qtrs),
            _scheduleView(),
          ),
          bottomNavigationBar: ScheduleNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            smallView: true,
          ),
        );
      },
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
        ScheduleView().build(context),
        const SizedBox(height: 10),
        Expanded(
          child: ClassListPage(size: ClassListSize.small, quarters: qtrs),
        ),
      ],
    );
  }
}
