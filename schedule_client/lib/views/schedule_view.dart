import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/domain/csv_builder.dart';
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
          menuHeight: 500,
          textStyle: const TextStyle(fontSize: 12),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
            filled: true,
            fillColor: Color.fromARGB(255, 247, 246, 246),
          ),
          key: const Key('Schedule View Term Dropdown'),
          label: const Text(
            'Term',
            style: TextStyle(fontSize: 12),
          ),
          dropdownMenuEntries: _terms,
          initialSelection: results.scheduleTerm,
          onSelected: (value) {
            results.updateSchedule(value);
          },
        ),
      ),
    );
  }

  Widget _saveData() {
    return Semantics(
      label: 'Save data button.',
      hint: 'Click on this button to save your data.',
      child: ElevatedButton(
        key: const Key('Download Button'),
        onPressed: () {
          results.saveTextFile(createCSV(), 'Schedule.csv');
        },
        child: results.scheduleDownloaded
            ? const Text('Downloaded')
            : const Text('Download Schedule'),
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
        tableCell('Sun', 16.0, alignOpt),
        tableCell('Mon', 16.0, alignOpt),
        tableCell('Tue', 16.0, alignOpt),
        tableCell('Wed', 16.0, alignOpt),
        tableCell('Thu', 16.0, alignOpt),
        tableCell('Fri', 16.0, alignOpt),
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
        final num = aClass.course.number;
        final dept = '${aClass.getCode()} ';
        for (final i in [1, 2, 3, 4, 5, 7]) {
          // Occurs on the day AND the time
          if (aClass.schedule.isAt(day: i, time: time)) {
            cNames[i] += '${dept + num}\n';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _termDropdown(),
            _saveData(),
          ],
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
