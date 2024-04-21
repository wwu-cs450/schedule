import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/domain/hourminute.dart';
import 'package:schedule_client/domain/term.dart';
import 'package:schedule_client/main.dart';

class ScheduleView {
  ScheduleView() {
    _terms = _termEntries();
    _terms.removeAt(0);
  }
  BuildContext context = results.context;
  late List<DropdownMenuEntry> _terms;
  late final Term term = _terms[1].value;

  List<DropdownMenuEntry> _termEntries() {
    final entries = <DropdownMenuEntry>[];
    final Map<String, dynamic> map = {
      for (final e in Term.instances) e.name: e,
    };
    for (final key in map.keys) {
      entries.add(DropdownMenuEntry(value: map[key], label: key));
    }

    return entries;
  }

  Widget _termDropdown() {
    return Semantics(
      label: 'Schedule View Term Dropdown Menu',
      hint: 'Select a term from the dropdown menu.',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownMenu(
          key: const Key('Schedule View Term Dropdown'),
          label: const Text(
            'Term',
            style: TextStyle(fontSize: 12),
          ),
          dropdownMenuEntries: _terms,
          initialSelection: term,
          onSelected: (value) {
            results.updateSchedule(value);
          },
        ),
      ),
    );
  }

  DecoratedBox _cellBox(
    String timeDayTitle,
    double fontSize,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: timeDayTitle.split('\n').length > 1
            ? const Color.fromARGB(255, 255, 130, 121)
            : Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            timeDayTitle,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ),
    );
  }

  TableCell tableCell(String input, double fontSz, TextAlign alignOpt) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      child: _cellBox(input, fontSz),
    );
  }

  TableRow _scheduleHeader() {
    const alignOpt = TextAlign.center;
    return TableRow(
      children: [
        tableCell(' ', 16.0, alignOpt),
        tableCell('Sunday', 16.0, alignOpt),
        tableCell('Monday', 16.0, alignOpt),
        tableCell('Tuesday', 16.0, alignOpt),
        tableCell('Wednesday', 16.0, alignOpt),
        tableCell('Thursday', 16.0, alignOpt),
        tableCell('Friday', 16.0, alignOpt),
      ],
    );
  }

  TableRow _scheduleRow(String time, List<String> classNames) {
    const alignOpt = TextAlign.left;

    return TableRow(
      children: [
        tableCell(time, 12.0, alignOpt),
        tableCell(classNames[7], 12.0, alignOpt),
        tableCell(classNames[1], 12.0, alignOpt),
        tableCell(classNames[2], 12.0, alignOpt),
        tableCell(classNames[3], 12.0, alignOpt),
        tableCell(classNames[4], 12.0, alignOpt),
        tableCell(classNames[5], 12.0, alignOpt),
      ],
    );
  }

  List<TableRow> _scheduleRows(List<Class> classes) {
    final rows = <TableRow>[];

    for (HourMinute time = HourMinute(hour: 7, minute: 0);
        time <= HourMinute(hour: 20, minute: 0);
        time = time.add(const Duration(hours: 1))) {
      final List<String> cNames = ['', '', '', '', '', '', '', ''];

      // Iterate through each class
      // Note: day = 1 is Monday, day = 7 is Sunday. (DateTime requirement)
      for (final aClass in classes) {
        final title = aClass.getTitle();
        for (final i in [1, 2, 3, 4, 5, 7]) {
          // Occurs on the day AND the time
          if (aClass.schedule.isAt(day: i, time: time)) {
            cNames[i] += '$title\n';
          }
        }
      }

      // Trim trailing whitespace, if any.
      for (var i = 0; i < 8; i++) {
        cNames[i] = cNames[i].trim();
      }

      rows.add(_scheduleRow(time.toString(is24hr: false), cNames));
    }
    return rows;
  }

  Widget build() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xFFa8ac9c)),
            child: _termDropdown(),
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FixedColumnWidth(100),
            1: IntrinsicColumnWidth(flex: 1.0),
            2: IntrinsicColumnWidth(flex: 1.0),
            3: IntrinsicColumnWidth(flex: 1.0),
            4: IntrinsicColumnWidth(flex: 1.0),
            5: IntrinsicColumnWidth(flex: 1.0),
            6: IntrinsicColumnWidth(flex: 1.0),
          },
          children: [
            _scheduleHeader(),
            ..._scheduleRows(results.scheduleData),
          ],
        ),
      ],
    );
  }
}
