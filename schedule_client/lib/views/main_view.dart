import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/views/search_criteria.dart';

abstract class MainView {
  MainView(this.startYear, this.results) {
    qtrs = [
      'Sum $startYear',
      'Aut $startYear',
      'Wtr ${startYear + 1}',
      'Spr ${startYear + 1}',
      'Sum ${startYear + 1}',
    ];
  }
  SearchCriteria results;
  int startYear;
  late final List<String> qtrs;

  Map<String, int> palette = {
    'green': 0xFF656950,
    'brown': 0xFF796249,
    'orange': 0xFFC36D2A,
    'tan': 0xFFC7AE86,
    'blue': 0xFF667FA4,
    'grey-brown': 0xFF877465,
    'brick-red': 0xFF961400,
  };

  Widget view(
    int index,
    BuildContext context,
    Function searchCriteriaWidget,
  );

  Widget savedBox(Class aClass) {
    return Semantics(
      label: 'Class saving checkbox.',
      hint: 'Click on this to save a class for later.',
      child: SizedBox(
        height: 10,
        width: 30,
        child: Checkbox(
          value: aClass.saved,
          onChanged: (bool? value) {
            results.saveClass(aClass, value!);
          },
        ),
      ),
    );
  }

  SizedBox invisibleBox() {
    return const SizedBox(
      height: 20,
      width: 30,
    );
  }

  String addLinesTo(String aString, int lineHeight) {
    final initialCount = aString.split('\n').length;
    var result = aString;
    for (var i = initialCount; i < lineHeight; i++) {
      result += '\n';
    }
    return result.isNotEmpty ? result : ' ';
  }

  String getTerm(Class aClass, String key) {
    String term;
    if (key == 'Sum $startYear') {
      term = 'Summer $startYear';
    } else if (key == 'Aut $startYear') {
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

  List<int> getColor(int index) {
    if (index % 2 == 0) {
      return [0xFFc2c2c2, 0xFFf1f276, 0xFFf2b600, 0xFF8ca2bd, 0xFF53b573];
    } else {
      return [0xFFdbdbdb, 0xFFfeffa4, 0xFFffd34d, 0xFFb4c4d8, 0xFF8ad2a1];
    }
  }

  Widget headerCell(String input, double width) {
    return Semantics(
      // As with the Semantics,
      // the word on the cell will come after the semantic label.
      label: 'Below shows the: ',
      child: Container(
        width: width,
        key: Key('${input.trim()} Header Card'),
        decoration: BoxDecoration(
          color: Color(palette['blue']!),
          border: Border.all(color: Colors.black),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            input,
            style: const TextStyle(
              color: Color(0xFFffffff),
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget cell(
    String keyString,
    String input,
    double width,
    int bkgndColor,
    int lineHeight,
  ) {
    return Semantics(
      label: '$keyString cell.',
      hint: 'The $keyString for this row is $input.',
      child: Container(
        key: Key('$keyString Cell'),
        width: width,
        decoration: BoxDecoration(
          color: Color(bkgndColor),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          addLinesTo(input, lineHeight),
          style: const TextStyle(
            color: Color(0xFF00003e),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
