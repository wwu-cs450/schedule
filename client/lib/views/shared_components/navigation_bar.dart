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
      ],
    );
  }
}
