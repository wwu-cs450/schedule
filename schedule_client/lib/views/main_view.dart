import 'package:flutter/material.dart';
import 'package:schedule_client/domain/class.dart';
import 'package:schedule_client/views/search_criteria.dart';
import 'package:url_launcher/url_launcher.dart';

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
  );

  Widget savedBox(Class aClass, int index, {int? bkgndColor}) {
    return Semantics(
      label: 'Class saving checkbox.',
      hint: 'Click on this to save a class for later.',
      child: SizedBox(
        width: 30,
        child: Checkbox(
          key: Key('Class $index save box'),
          value: aClass.saved,
          onChanged: (bool? value) {
            results.saveClass(aClass, value!);
          },
        ),
      ),
    );
  }

  Widget invisibleBox() {
    return Container(
      decoration: BoxDecoration(
        color: Color(palette['blue']!),
      ),
      width: 30,
    );
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

  String mediumTerm(Class aClass) {
    return aClass.term.name;
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
      label: 'Below shows the: ',
      child: Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          color: Color(palette['blue']!),
        ),
        child: Text(
          key: Key('${input.trim()} Header Card'),
          input,
          style: const TextStyle(
            color: Color(0xFFffffff),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget cell(
    String keyString,
    String input,
    double width,
    int bkgndColor, [
    String? align,
  ]) {
    const Alignment right = Alignment.centerRight;
    const Alignment left = Alignment.centerLeft;
    const Alignment center = Alignment.center;
    return Semantics(
      label: '$keyString cell.',
      hint: 'The $keyString for this row is $input.',
      child: Container(
        key: keyString == 'Spring' ||
                keyString == 'Summer' ||
                keyString == 'Fall' ||
                keyString == 'Winter'
            ? const Key('Term Color Cell')
            : null,
        alignment: align == 'r'
            ? right
            : align == 'l'
                ? left
                : align == 'c'
                    ? center
                    : AlignmentDirectional.centerStart,
        width: width,
        decoration: BoxDecoration(
          color: Color(bkgndColor),
        ),
        child: Text(
          key: Key('$keyString Cell'),
          input,
          style: const TextStyle(
            color: Color(0xFF00003e),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

Widget tooltipCell(
  String keyString,
  String input,
  String tooltip,
  double width,
  int bkgndColor,
) {
  return Semantics(
    label: '$keyString cell.',
    hint: 'The $keyString for this row is $input.',
    child: Tooltip(
      key: const Key('Hover Cell'),
      message: tooltip,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        width: width,
        decoration: BoxDecoration(
          color: Color(bkgndColor),
        ),
        child: Text(
          key: Key('$keyString Cell'),
          input,
          style: const TextStyle(
            color: Color(0xFF00003e),
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

Widget videoCell(
  String keyString,
  String tooltip,
  double width,
  int bkgndColor,
  String video,
) {
  return Semantics(
    label: '$keyString cell.',
    hint: 'The $keyString for this row is Video.',
    child: video == ''
        ? Container(
            alignment: AlignmentDirectional.centerStart,
            key: Key('$keyString Cell'),
            width: width,
            decoration: BoxDecoration(
              color: Color(bkgndColor),
            ),
          )
        : Container(
            alignment: AlignmentDirectional.centerStart,
            key: Key('$keyString Cell'),
            width: width,
            decoration: BoxDecoration(
              color: Color(bkgndColor),
            ),
            child: InkWell(
              onTap: () async {
                await launchUrl(video as Uri);
              },
              child: const Text(
                'Video',
                style: TextStyle(
                  color: Color(0xFF00003e),
                  fontSize: 12,
                ),
              ),
            ),
          ),
  );
}
