import 'package:client/domain/data_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import 'feature_test_functions.dart';

void main() {
  setUp(() async {
    await DataHandler.fetchData(test: true);
  });

  testWidgets('Audit View Headers', (WidgetTester tester) async {
    final String extractedText = '''
Page 1 of 6 WALLA WALLA UNIVERSITY  Academic Advisement Report  1111111   Samuel Hoffmann  Prepared on
12/04/2023 Program   Requirement Term   Requirement Status Undergraduate Career   Fall, 2021   Not
Satisfied Undergraduate Program   Fall, 2021   Satisfied Something Science (BS) Major   Fall, 2021   Not
Satisfied IMPORTANT DEGREE AUDIT INFORMATION (RG 584)  You are encouraged to use this degree audit report
as a guide when planning your progress toward completion of the above requirements. Your academic advisor
or the Registrar's Office may be contacted for assistance in interpreting this report. This audit is not
your academic transcript and it is not official notification of completion of degree or certificate
requirements. Please contact the Registrar's Office regarding this degree audit report, your official
degree/certificate completion status, or to obtain a copy of your academic transcript. The term "Unit"
used in this degree audit is synonymous with the terms "Quarter Hour" or "Credit" used in the WWU
Bulletin. R, RG, and L codes are used for the purposes of exceptions.  FALL THROUGH AND INSUFFICIENT (RG 633)
The following courses are available to be used to satisfy other Majors or Minors. This area includes
cognate courses that can be used anywhere in the audit. Fall Through Courses  Courses Used Term   Subject
Catalog Nbr   Course Title   Grade   Units   Type  Wtr 2025   CPTR   308   Ethical Issues for Computing
4.00   IP Wtr 2024   CYBS   326   Network and System Security   A   4.50   EN Wtr 2024   DSGN   110
Design Principles I   A   4.00   EN Wtr 2024   DSGN   121   Fundamentals of CAD   A   2.00   EN Fall 2023
ENGR   354   Digital Logic   A   3.00   EN Fall 2024   GDEV   122   Introduction to Games   4.50   IP Fall
2024   GDEV   324   Unity I, Working with Unity   4.50   IP Wtr 2025   GDEV   325   C# Programming   4.50
IP Fall 2021   GNRL   101   University Experience   S   1.00   EN Wtr 2023   MATH   215   Data Analysis
A   4.00   EN Wtr 2024   MATH   250   Discrete Mathematics   A   4.00   EN Wtr 2022   MATH   281
Calculus II   A   4.00   EN Spr 2022   MATH   282   Calculus III   A-   4.00   EN Fall 2022   MATH   289
Intro to Linear Algebra   A   3.00   EN Wtr 2024   TECH   138   Shielded Metal Arc Welding   A   2.00   EN
Spr 2025   TECH   321   Technology & Society   4.00   IP  OVERALL UNDERGRADUATE REQUIREMENTS (RG 639)  Not
Satisfied:   OVERALL UNDERGRADUATE REQUIREMENTS 192 units to Graduate (R9 L11)  Satisfied:   Complete a
minimum of 192 total units.  ·   Units:   192.00 required,
''';
    await auditViewParse(tester, extractedText);
  });
}
