import 'package:client/domain/term.dart';
import 'package:flutter/material.dart';

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
}
