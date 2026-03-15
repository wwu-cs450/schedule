import 'package:client/views/ai_advisor_page/ai_advisor_page.dart';
import 'package:client/views/class_history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleNavigationBar extends StatelessWidget {
  const ScheduleNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.smallView = false,
    super.key,
  });

  final int selectedIndex;
  final void Function(int) onDestinationSelected;
  final bool smallView;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
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

        if (!smallView)
          NavigationDestination(
            key: Key('MyClassHistoryPage'),
            icon: Icon(Icons.school_outlined),
            label: 'My Class History',
          ),

        NavigationDestination(
          key: Key('AiAdvisorPage'),
          icon: Icon(CupertinoIcons.sparkles),
          label: 'AI Advisor',
        ),
      ],
    );
  }
}

Widget selectedTab(
  int selectedIndex,
  Widget classListView,
  Widget scheduleView,
) {
  if (selectedIndex == 0) {
    return classListView;
  } else if (selectedIndex == 1) {
    return scheduleView;
  } else if (selectedIndex == 2) {
    return const ClassHistoryPage();
  } else if (selectedIndex == 3) {
    return const AiAdvisorPage();
  } else {
    return Center(child: Text('Tab $selectedIndex not found'));
  }
}
