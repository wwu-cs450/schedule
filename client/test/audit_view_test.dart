import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/domain/requirement_class.dart';
import 'package:client/views/audit_view.dart';
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

  testWidgets('Pare Overall Undergraduate Requirements', (
    WidgetTester tester,
  ) async {
    var extractedText = '''
OVERALL UNDERGRADUATE REQUIREMENTS (RG 639) Not Satisfied: OVERALL UNDERGRADUATE
REQUIREMENTS 192 units to Graduate (R9 L11) Not Satisfied: Complete a minimum of 192 total units.
· Units: 192.00 required, 94.00 used, 98.00 needed 60 Upper Division units (R9 L20) Not Satisfied:
Complete a minimum of 60 upper division units. · Units: 60.00 required, 8.00 used, 52.00 needed 96
unit minimum from 4 year institutions (R9 L30) Not Satisfied: Bachelor's degrees need a minimum of
96 units from 4 year institutions. · Units: 96.00 required, 94.00 used, 2.00 needed 9 allowable
units from DRMA 252 (R9 L40) Satisfied: A maximum of 9 units in DRMA 252 may apply to degree
requirements. · Units: 0.00 used In Progress Courses (R9 L50) Page 2 of 7 Not Satisfied: In
progress courses Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Fall 2024
BIOL 216 Intro to Biological Rsrch I-WD 3.00 IP Wtr 2025 BIOL 250 Biostatistics 4.00 IP Fall 2024
CHEM 141 General Chemistry 3.00 IP Wtr 2025 CHEM 142 General Chemistry 3.00 IP Fall 2024 CHEM 144
General Chemistry Lab 1.00 IP Wtr 2025 CHEM 145 General Chemistry Lab 1.00 IP Fall 2024 PEAC 186
Athletics: Basketball 1.00 IP Fall 2024 PHYS 211 Gen Physics 3.00 IP Wtr 2025 PHYS 212 Gen Physics
3.00 IP Fall 2024 PHYS 214 Gen Physics Lab 1.00 IP Wtr 2025 PHYS 215 Gen Physics Lab 1.00 IP
Degree Application (R9 L55) Not Satisfied: Follow the 12 Clicks to Graduation
(wallawalla.edu/degree-app) instructions to submit your degree application. (This section of your
degree audit will be marked "Satisfied" once your application has been approved by Academic
Records.) Residency Requirement At least 40 of the last 45 units must be taken at Walla Walla
University.
''';
    extractedText = cleanContent(extractedText);
    final section = SimpleSection(
      header: 'OVERALL UNDERGRADUATE REQUIREMENTS (RG 639)',
      content: extractedText,
    );
    final Requirement overallUnderGrad =
        AuditPage.parseOverallUndergraduateRequirements(section);

    expect(
      overallUnderGrad.title,
      equals('OVERALL UNDERGRADUATE REQUIREMENTS (RG 639)'),
    );
    expect(overallUnderGrad.details.length, equals(5));
    expect(
      overallUnderGrad.details[2].description,
      equals('60 Upper Division units (R9 L20)'),
    );
    expect(overallUnderGrad.details[4].status, equals(true));
  });

  testWidgets('Separate New GS Requirements', (WidgetTester tester) async {
    var extractedText = '''
GENERAL STUDIES (RG 582) Overall Requirement Not Satisfied: You must complete the following General Studies
requirements. · Units: 38.00 used · GPA: 0.700 required, 3.860 completed GS: Foundational Skills (R 456) Overall Requirement Not Satisfied:
GS: Foundational Skills Written Communication & Information Literacy (R456 L10) Satisfied: Complete the writing sequence. Either ENGL 121,
122, & 223 or HONR 141 & 243. · Units: 9.00 required, 9.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Fall
2023 ENGL 121 College Writing I TA 3.00 TR Fall 2023 ENGL 122 College Writing II TA 3.00 TR Fall 2023 ENGL 223 Research Writing TA 3.00 TR
Oral Communications (R456 L20) Not Satisfied: Complete one of the following: · Courses: 1.00 required, 0.00 used, 1.00 needed Courses
Available SPCH 101, SPCH 101P, SPCH 198, SPCH 207 Quantitative Reasoning (R456 L30) Satisfied: Complete one of the following: (MATH 112 &
113 apply only to Elementary Education majors.) · Courses: 1.00 required, 1.00 used Courses Used Term Subject Catalog Nbr Course Title
Grade Units Type Wtr 2024 MATH 121 Precalculus I B+ 4.00 EN Foundations of Faith (R456 L40) Not Satisfied: Choose one of the following: ·
Courses: 1.00 required, 0.00 used, 1.00 needed Courses Available RELB 104, RELB 111, RELB 231 Physical Health (R456 L50) Not Satisfied:
Choose two of the following: · Courses: 2.00 required, 1.00 used, 1.00 needed Courses Used Term Subject Catalog Nbr Course Title Grade
Units Type Fall 2024 PEAC 186 Athletics: Basketball 1.00 IP Courses Available PEAC 190, PEAC 198, PEAC 200, PEAC 200, PEAC 200, PEAC 200,
PEAC 200, PEAC 200, PEAC 200, PEAC 200, PEAC 10#, PEAC 12#, PEAC 13#, PEAC 14#, PEAC 15#, PEAC 16#, PEAC 17#, PEAC 18#, PEAC 11# GS: Ways
of Knowing (R457) Overall Requirement Not Satisfied: GS: Ways of Knowing · Courses: 4.00 used Humanities (R457 L10) Satisfied: Choose one
of the following: · Courses: 1.00 required, 1.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Spr 2024 PHIL 204
Essentials Critical Reasoning A 4.00 EN History (R457 L20) Not Satisfied: Choose one of the following: · Courses: 1.00 required, 0.00 used,
1.00 needed Courses Available HIST 121, HIST 121P, HIST 122, HIST 198, HIST 221, HIST 222, HIST 240, HIST 274, HIST 275, HIST 283 Natural
Science (R457 L30) Satisfied: Complete 4 units of the following: · Units: 4.00 required, 4.00 used Courses Used Term Subject Catalog Nbr
Course Title Grade Units Type Fall 2023 BIOL 121 Anatomy & Physiology TA 4.00 TR Social Science (R457 L40) Satisfied: Choose one of the
following: · Courses: 1.00 required, 1.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Fall 2023 PSYC 140 Intro
to Psyc:Social Foundatns A 4.00 EN Exploring Scripture (R457 L50) Not Satisfied: Choose one of the following: · Courses: 1.00 required,
0.00 used, 1.00 needed Courses Available RELB 198, RELB 302, RELB 302P, RELB 304, RELB 304P, RELB 312, RELB 312P, RELB 313, RELB 313P, RELB
337, RELB 337P, RELB 340, RELB 362, RELB 362P, RELB 398, RELB 408 Exploring SDA Life (R457 L60) Satisfied: Choose one of the following: ·
Courses: 1.00 required, 1.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Wtr 2024 RELT 202 Christian Beliefs A
4.00 EN GS Ways of Engaging Overall Requirement Not Satisfied: GS Ways of Engaging Engaging the Arts (R458 L10) Not Satisfied: Choose one
of the following: (ENGL 374 applies only to Elementary Education majors.) · Courses: 1.00 required, 0.00 used, 1.00 needed Courses
Available ART 324, ART 325, ART 326, ART 398, DRMA 101, DRMA 363, DRMA 398, ENGL 214, ENGL 214, ENGL 214, ENGL 214, ENGL 214P, ENGL 214P,
ENGL 214P, ENGL 214P, ENGL 318, ENGL 358, ENGL 359, ENGL 360, ENGL 363, ENGL 374, ENGL 398, ENGL 454, ENGL 474, ENGL 474, ENGL 474, ENGL
474, FILM 198, FILM 318, HMNT 398, LANG 408, MUHL 134, MUHL 398, RELB 354, SPAN 307, SPAN 398, WRIT 324, WRIT 334, WRIT 398 Engaging
History & Philosophy (R458 L20) Not Satisfied: Choose one of the following: (HIST 386 applies only to education majors.) · Courses: 1.00
required, 0.00 used, 1.00 needed Courses Available ECON 359, HIST 242, HIST 254, HIST 254P, HIST 257, HIST 305, HIST 306, HIST 307, HIST
315, HIST 354, HIST 355, HIST 359, HIST 386, HIST 434, HIST 437, HIST 448, HIST 450, HIST 463, HIST 474, PHIL 305, PHIL 315, PHIL 461
Engaging Faith (R458 L30) Not Satisfied: Complete 6-7 unites for a total of 18 units in religion. · Units: 6.00 required, 0.00 used, 6.00
needed · Courses: 2.00 required, 0.00 used, 2.00 needed Courses Available ENGL 454, PHIL 412, PSYC 425, RELB 274, RELB 303, RELB 306, RELB
307, RELB 333, RELB 333P, RELB 339, RELB 345, RELB 345P, RELB 354, RELB 382P, RELB 398, RELB 410, RELB 421, RELB 421P, RELB 474, RELB 474,
RELB 474, RELB 474, RELH 205, RELH 303, RELH 303P, RELH 398, RELH 425, RELH 455, RELM 198, RELM 233, RELT 326, RELT 340P, RELT 398, RELT
402, RELT 408, RELT 412, RELB 198, RELB 302, RELB 302P, RELB 304, RELB 304P, RELB 312, RELB 312P, RELB 313, RELB 313P, RELB 337, RELB 337P,
RELB 340, RELB 362, RELB 362P, RELB 408, RELH 457, RELT 110, RELT 202, RELT 417 Engaging Science & Data (R458 L40) Satisfied: Choose one of
the following: · Courses: 1.00 required, 1.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Fall 2023 BIOL 122
Anatomy & Physiology TA 4.00 TR Engaging Society (R458 L50) Satisfied: Choose one of the following: (EDUC 444 applies only to education
majors.) · Courses: 1.00 required, 1.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Fall 2023 FINA 101
Personal Finance A 4.00 EN Verify 18 Religion credits (R 30) Not Satisfied: Students with less than 45 transfer credits must complete 18
credits of GS religion. · Units: 0.00 used GS Religion or Theology (R30 L50) Not Satisfied: Religion or Theology · Units: 18.00 required,
4.00 used, 14.00 needed Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Wtr 2024 RELT 202 Christian Beliefs A 4.00 EN
Courses Available RELB 104, RELB 111, RELB 231, RELB 198, RELB 302, RELB 302P, RELB 304, RELB 304P, RELB 312, RELB 312P, RELB 313, RELB
313P, RELB 337, RELB 337P, RELB 340, RELB 362, RELB 362P, RELB 398, RELB 408, ENGL 454, PHIL 412, PSYC 425, RELB 274, RELB 303, RELB 306,
RELB 307, RELB 333, RELB 333P, RELB 339, RELB 345, RELB 345P, RELB 354, RELB 382P, RELB 410, RELB 421, RELB 421P, RELB 474, RELB 474, RELB
474, RELB 474, RELH 205, RELH 303, RELH 303P, RELH 398, RELH 425, RELH 455, RELM 198, RELM 233, RELT 326, RELT 340P, RELT 398, RELT 402,
RELT 408, RELT 412, RELH 457, RELT 110, RELT 202, RELT 417''';
    extractedText = cleanContent(extractedText);
    final List<SimpleSection> newGSSections = AuditPage.parseNewGSFormat(
      extractedText,
    );

    expect(newGSSections.length, equals(4));
    expect(newGSSections[0].header, equals('GS GENERAL STUDIES (RG 582)'));
    expect(newGSSections[1].header, equals('GS Foundational Skills (R 456)'));
    expect(newGSSections[2].header, equals('GS Ways of Knowing (R457)'));
    expect(newGSSections[3].header, equals('GS Ways of Engaging'));
    for (final section in newGSSections) {
      expect(section.content.isNotEmpty, equals(true));
    }
  });

  testWidgets('Separate Engineering GS Requirements', (
    WidgetTester tester,
  ) async {
    var extractedText = '''
ENGINEERING GENERAL STUDIES (RG 773) Overall Requirement Not Satisfied: Complete the following Engineering General
Studies requirements. · Units: 44.00 required, 44.00 used, 0.00 needed · GPA: 2.000 required, 4.000 completed
Communication Skills - Engineering General Studies (R224) Satisfied: Complete a minimum of 11 units. · Units: 11.00    
required, 13.00 used Writing (R224 L10) Satisfied: Complete 8-9 units from the following courses. · Units: 8.00        
required, 9.00 used · Courses: 3.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Fall 2021 
ENGL 121 College Writing I TA 3.00 TR Term Subject Catalog Nbr Course Title Grade Units Type Fall 2021 ENGL 122 College
Writing II TA 3.00 TR Fall 2021 ENGL 223 Research Writing TA 3.00 TR Speech (R224 L20) Satisfied: Complete 3-4 units   
from the following courses. · Units: 3.00 required, 4.00 used Courses Used Term Subject Catalog Nbr Course Title Grade 
Units Type Spr 2022 SPCH 101 Fundamentals of Speech Comm A 4.00 EN Physical Activity Experience - Engineering General  
Studies (R225) Satisfied: Complete a minimum of 2 units. · Units: 2.00 required, 2.00 used Physical Activity (R225 L10)
Satisfied: Complete 2 units from the following courses. · Units: 2.00 required, 2.00 used Courses Used Term Subject    
Catalog Nbr Course Title Grade Units Type Wtr 2025 PEAC 171 Basketball 1.00 IP Fall 2022 PEAC 173 Flag Ball A 1.00 EN  
Ethics & Belief Studies - Engineering General Studies (R 226) Satisfied: Complete 18 units. · Units: 18.00 required,   
18.00 used Religion (R226 L10) Satisfied: Complete 18 units from the following General Studies Religion courses. ·     
Units: 18.00 required, 18.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Spr 2022 RELB 104
Ministry of Jesus A 4.00 EN Wtr 2022 RELB 105 Sermon on the Mount A 2.00 EN Fall 2021 RELB 106 Parables of Jesus A 2.00
EN Spr 2022 RELB 307 Creation in the Bible A 2.00 EN Wtr 2024 RELB 313 Revelation A 4.00 EN Spr 2024 RELH 303 World    
Religions A 4.00 EN RELB Requirement (R226 L20) Satisfied: 6 units from the above GS Religion requirement must be RELB 
courses. · Units: 6.00 required, 14.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Spr    
2022 RELB 104 Ministry of Jesus A 4.00 EN Wtr 2022 RELB 105 Sermon on the Mount A 2.00 EN Fall 2021 RELB 106 Parables  
of Jesus A 2.00 EN Spr 2022 RELB 307 Creation in the Bible A 2.00 EN Wtr 2024 RELB 313 Revelation A 4.00 EN Upper      
Division Requirement (R226 L30) Satisfied: 6 units from the GS Religion requirement must be upper division. · Units:   
6.00 required, 10.00 used Courses Used Term Subject Catalog Nbr Course Title Grade Units Type Spr 2022 RELB 307        
Creation in the Bible A 2.00 EN Wtr 2024 RELB 313 Revelation A 4.00 EN Spr 2024 RELH 303 World Religions A 4.00 EN     
Historical & Contemporary Issues - Engineering General Studies (R 227) Overall Requirement Not Satisfied: Complete 10  
units. · Units: 10.00 required, 11.00 used, 0.00 needed Humanities (R227 L20) Not Satisfied: Complete 4 units from the 
following Humanities courses. · Units: 4.00 required, 3.00 used, 1.00 needed Courses Used Term Subject Catalog Nbr     
Course Title Grade Units Type Spr 2025 ART 326 Hist of World Art 3.00 IP Courses Available ART 198, ART 251, ART 251P, 
ART 312, ART 324, ART 325, ART 398, DRMA 363, ENGL 198, ENGL 198H, ENGL 204, ENGL 210, ENGL 211, ENGL 212, ENGL 214,   
ENGL 214, ENGL 214, ENGL 214, ENGL 214P, ENGL 214P, ENGL 214P, ENGL 214P, ENGL 358, ENGL 359, ENGL 363, ENGL 398, ENGL 
454, FILM 199, FILM 215, HMNT 198, LANG 408, MUHL 124, MUHL 134, MUHL 198, PHIL 198, PHIL 204, PHIL 205, PHIL 305, PHIL
398, PHIL 407, PHIL 412, RELB 354, RELT 412, SPAN 307, SPAN 398, HONR 131, HONR 132 Social Sciences (R227 L30)
Satisfied: Complete 4 units from the following Social Science courses. · Units: 4.00 required, 8.00 used Courses Used  
Term Subject Catalog Nbr Course Title Grade Units Type Fall 2019 HIST 221 Hist of the U.S. A 4.00 EN Spr 2020 HIST 222 
Hist of the U.S. A 4.00 EN Upper Division Requirement (R227 L40) Satisfied: One course (3-4 units) from General Studies
Humanities and Social Sciences must be upper division. · Units: 3.00 required, 3.00 used Courses Used Term Subject     
Catalog Nbr Course Title Grade Units Type Spr 2025 ART 326 Hist of World Art 3.00 IP Electives - Engineering General   
Studies (R 228) Satisfied: Electives- Engineering General Studies · Units: 0.00 used Approved Electives (R228 L10)     
Satisfied: Complete elective units from the following courses to bring the Engineering General Studies total to 44     
units. · Units: 0.00''';
    extractedText = cleanContent(extractedText);
    final List<SimpleSection> engGSSections = AuditPage.parseEngGSFormat(
      extractedText,
    );

    expect(engGSSections.length, equals(6));
    expect(
      engGSSections[0].header,
      equals('ENGINEERING GENERAL STUDIES (RG 773)'),
    );
    expect(
      engGSSections[1].header,
      equals('Communication Skills - Engineering General Studies (R224)'),
    );
    expect(
      engGSSections[2].header,
      equals(
        'Physical Activity Experience - Engineering General Studies (R225)',
      ),
    );
    expect(
      engGSSections[3].header,
      equals('Belief Studies - Engineering General Studies (R 226)'),
    );
    expect(
      engGSSections[4].header,
      equals('Contemporary Issues - Engineering General Studies (R 227)'),
    );
    expect(
      engGSSections[5].header,
      equals('Electives - Engineering General Studies (R 228)'),
    );
    for (final section in engGSSections) {
      expect(section.content.isNotEmpty, equals(true));
    }
  });
}
