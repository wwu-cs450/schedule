import 'package:client/domain/class.dart';
import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AbstractView extends StatefulWidget {
  const AbstractView({super.key});

  @override
  AbstractViewState createState() => AbstractViewState();
}

class AbstractViewState extends State<AbstractView> {
  Map<String, int> palette = {
    'green': 0xFF656950,
    'brown': 0xFF796249,
    'orange': 0xFFC36D2A,
    'tan': 0xFFC7AE86,
    'blue': 0xFF667FA4,
    'grey-brown': 0xFF877465,
    'brick-red': 0xFF961400,
  };
  late List<String> qtrs;
  int startYear = 2025;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  Widget cell(
    String keyString,
    String cellText,
    double width,
    int bkgndColor, [
    String? align,
    String? videoLink = '',
  ]) {
    const Alignment right = Alignment.centerRight;
    const Alignment left = Alignment.centerLeft;
    const Alignment center = Alignment.center;
    final key =
        ['Spring', 'Summer1', 'Summer2', 'Fall', 'Winter'].contains(keyString)
            ? const Key('Term Color Cell')
            : null;
    final alignment =
        align == 'r'
            ? right
            : align == 'l'
            ? left
            : align == 'c'
            ? center
            : AlignmentDirectional.centerStart;
    final boxDecoration = BoxDecoration(
      color: Color(bkgndColor),
      border: Border.all(color: Colors.white, width: 0.5),
    );

    final text =
        videoLink!.isEmpty
            ? Text(
              key: Key('$keyString Cell'),
              cellText,
              style: const TextStyle(color: Color(0xFF00003e), fontSize: 12),
            )
            : InkWell(
              onTap: () async {
                final Uri url = Uri.parse(videoLink);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text(
                'Video',
                key: Key('Video Link Cell'), // Changed key to be unique
                style: TextStyle(
                  color:
                      Colors.blue, // Changed color to blue to indicate a link
                  decoration:
                      TextDecoration.underline, // Underline to indicate a link
                  decorationColor: Colors.blue, // Set underline color to blue
                  fontSize: 12,
                  height:
                      1.5, // Adjust height to create space between text and underline
                ),
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: true,
                ),
              ),
            );
    return Semantics(
      label: '$keyString cell.',
      hint: 'The $keyString for this row is $cellText.',
      child: Container(
        key: key,
        padding: const EdgeInsets.all(5),
        alignment: alignment,
        width: width,
        decoration: boxDecoration,
        child: text,
      ),
    );
  }

  List<int> getColor(int index) {
    if (index % 2 == 0) {
      return [0xFFc2c2c2, 0xFFf1f276, 0xFFf2b600, 0xFF8ca2bd, 0xFF53b573];
    } else {
      return [0xFFdbdbdb, 0xFFfeffa4, 0xFFffd34d, 0xFFb4c4d8, 0xFF8ad2a1];
    }
  }

  String getTerm(Class aClass, String key) {
    String term;
    if (key == 'Sum $startYear') {
      term = 'Summer $startYear';
    } else if (key == 'Fal $startYear') {
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

  Widget headerCell(String label, double width) {
    return Semantics(
      label: 'Below shows the: ',
      child: Container(
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          color: Color(palette['blue']!),
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        child: Text(
          key: Key('${label.trim()} Header Card'),
          label,
          style: const TextStyle(color: Color(0xFFffffff), fontSize: 12),
        ),
      ),
    );
  }

  void setTerm(Term term) {
    startYear = term.startYear();
    qtrs = [
      'Sum $startYear',
      'Fal $startYear',
      'Wtr ${startYear + 1}',
      'Spr ${startYear + 1}',
      'Sum ${startYear + 1}',
    ];
  }

  Widget invisibleBox() {
    return Container(
      decoration: BoxDecoration(
        color: Color(palette['blue']!),
        border: Border.all(color: Colors.white, width: 0.5),
      ),
      width: 30,
    );
  }

  Widget savedBox(Class aClass, int index, {int? bkgndColor}) {
    return Semantics(
      label: 'Class saving checkbox.',
      hint: 'Click on this to save a class for later.',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.5),
        ),
        width: 30,
        child: Checkbox(
          key: Key('Class $index save box'),
          value: aClass.saved,
          onChanged: (bool? value) {
            setState(() {
              aClass.saved = value!;
            });
          },
        ),
      ),
    );
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
            border: Border.all(color: Colors.white, width: 0.5),
          ),
          padding: const EdgeInsets.all(5),
          child: Text(
            key: Key('$keyString Cell'),
            input,
            style: const TextStyle(color: Color(0xFF00003e), fontSize: 12),
          ),
        ),
      ),
    );
  }
}
