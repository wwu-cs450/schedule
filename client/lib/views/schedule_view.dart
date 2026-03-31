import 'dart:async';
import 'dart:convert';

import 'package:client/domain/class.dart';
import 'package:client/domain/csv_builder.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:universal_html/html.dart' as html;

class ScheduleView {
  void saveTextFile() {
    final text = createCSV();
    final filename = 'Schedule.csv';
    html.AnchorElement()
      // ignore: unsafe_html
      ..href =
          '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: utf8)}'
      ..download = filename
      ..style.display = 'none'
      ..click();
  }

  Widget build() {
    final classes = Filters().savedClassesForScheduleTerm();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TermSelector(),
            Expanded(child: _creditAmount()),
            _clearAllButton(),
            _downloadButton(),
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
          children: [_scheduleHeader(), ..._scheduleRows(classes)],
        ),
      ],
    );
  }

  DecoratedBox _cellBox(String string, double fontSize) {
    final count = string.split('\n').length;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: count > 1
            ? const Color.fromARGB(255, 255, 130, 121)
            : Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(string, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }

  TableCell tableCell(String string, double fontSz, TextAlign alignOpt) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
      child: _cellBox(string, fontSz),
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

    for (
      HourMinute time = HourMinute(hour: 7, minute: 0);
      time <= HourMinute(hour: 20, minute: 0);
      time = time.add(const Duration(hours: 1))
    ) {
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

  Widget _creditAmount() {
    final classes = Filters().savedClassesForScheduleTerm();
    final credits = classes.isEmpty
        ? 0
        : classes.map((aClass) => aClass.getCredits()).reduce((a, b) => a + b);
    return Semantics(
      label: 'Credit amount.',
      hint: 'Displays the total number of credits.',
      child: Text(
        'Total Credits: $credits',
        key: const Key('totalCreditsText'),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _clearAllButton() {
    return Semantics(
      label: 'Clear all saved classes.',
      hint: 'Click to clear all saved classes.',
      child: ShadButton.outline(
        key: const Key('Deselect All Button'),
        size: .sm,
        backgroundColor: Colors.white,
        hoverBackgroundColor: Color(0xFFF5F5F5),
        pressedBackgroundColor: Colors.white,
        onPressed: () {
          unawaited(Filters().unsaveAll());
        },
        child: const Text('Clear All', style: TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _downloadButton() {
    return Semantics(
      label: 'Download button',
      hint: 'Click on this button to download your class schedule data.',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          key: const Key('Download Button'),
          onPressed: () {
            saveTextFile();
          },
          icon: const Icon(Icons.download),
        ),
      ),
    );
  }
}

class TermSelector extends StatefulWidget {
  const TermSelector({super.key});

  @override
  State<TermSelector> createState() => _TermSelectorState();
}

class _TermSelectorState extends State<TermSelector> {
  @override
  void initState() {
    super.initState();
    // Ensure scheduleTerm is set to a valid non-Year term
    // Use addPostFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentTerm = Filters().scheduleTerm;
      if (currentTerm is Year || !_terms.any((t) => t.value == currentTerm)) {
        // Set to Fall 2026 or the last available term
        final defaultTerm = _terms
            .firstWhere(
              (option) => option.value.code == 2269,
              orElse: () => _terms.last,
            )
            .value;
        Filters().scheduleTerm = defaultTerm;
      }
    });
  }

  List<ShadOption<Term>> get _terms {
    return Term.instances
        .where((term) => term is! Year)
        .map(
          (term) => ShadOption<Term>(
            value: term,
            child: Text(term.name, style: const TextStyle(fontSize: 13)),
          ),
        )
        .toList();
  }

  void _goToPreviousTerm() {
    final currentTerm = Filters().scheduleTerm;
    final currentIndex = _terms.indexWhere(
      (option) => option.value == currentTerm,
    );
    if (currentIndex > 0) {
      setState(() {
        Filters().scheduleTerm = _terms[currentIndex - 1].value;
      });
    }
  }

  void _goToNextTerm() {
    final currentTerm = Filters().scheduleTerm;
    final currentIndex = _terms.indexWhere(
      (option) => option.value == currentTerm,
    );
    if (currentIndex >= 0 && currentIndex < _terms.length - 1) {
      setState(() {
        Filters().scheduleTerm = _terms[currentIndex + 1].value;
      });
    }
  }

  bool get hasPreviousTerm {
    final currentTerm = Filters().scheduleTerm;
    final currentIndex = _terms.indexWhere(
      (option) => option.value == currentTerm,
    );
    return currentIndex > 0;
  }

  bool get hasNextTerm {
    final currentTerm = Filters().scheduleTerm;
    final currentIndex = _terms.indexWhere(
      (option) => option.value == currentTerm,
    );
    return currentIndex >= 0 && currentIndex < _terms.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [backButton(), termDropdown(), forwardButton()]),
    );
  }

  Widget termDropdown() {
    return Semantics(
      label: 'Schedule View Term Dropdown Menu',
      hint: 'Select a term from the dropdown menu.',
      child: ShadSelect<Term>(
        key: const Key('Schedule View Term Dropdown'),
        initialValue: Filters().scheduleTerm,
        placeholder: const Text(
          'Select a term',
          style: TextStyle(fontSize: 13),
        ),
        options: _terms,
        selectedOptionBuilder: (context, value) =>
            Text(value.name, style: const TextStyle(fontSize: 13)),
        onChanged: (value) {
          if (value != null) {
            Filters().scheduleTerm = value;
          }
        },
        decoration: ShadDecoration(
          color: Colors.white,
          border: ShadBorder(),
          secondaryBorder: ShadBorder(),
          errorBorder: ShadBorder(),
          focusedBorder: ShadBorder(),
          secondaryFocusedBorder: ShadBorder(
            offset: 1,
            top: ShadBorderSide(width: 1, color: Colors.grey.shade300),
            bottom: ShadBorderSide(width: 1, color: Colors.grey.shade300),
            left: ShadBorderSide(width: 1, color: Colors.grey.shade300),
            right: ShadBorderSide(width: 1, color: Colors.grey.shade300),
            radius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
  }

  Widget backButton() {
    return Semantics(
      label: 'Previous term button',
      hint: 'Click to navigate to the previous term.',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ShadButton.outline(
          key: const Key('Previous Term Button'),
          size: .sm,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          backgroundColor: Colors.white,
          hoverBackgroundColor: Color(0xFFF5F5F5),
          pressedBackgroundColor: Colors.white,
          onPressed: hasPreviousTerm ? _goToPreviousTerm : null,
          child: const Icon(Icons.chevron_left, size: 16),
        ),
      ),
    );
  }

  Widget forwardButton() {
    return Semantics(
      label: 'Next term button',
      hint: 'Click to navigate to the next term.',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ShadButton.outline(
          key: const Key('Next Term Button'),
          size: .sm,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          backgroundColor: Colors.white,
          hoverBackgroundColor: Color(0xFFF5F5F5),
          pressedBackgroundColor: Colors.white,
          onPressed: hasNextTerm ? _goToNextTerm : null,
          child: const Icon(Icons.chevron_right, size: 16),
        ),
      ),
    );
  }
}
