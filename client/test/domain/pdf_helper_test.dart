import 'package:client/domain/pdf_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PdfHelper.parseTranscriptPdfText', () {
    test('parses complete transcript and returns all courses', () {
      final courses = PdfHelper.parseTranscriptPdfText(extractedTranscriptText);

      // Should parse courses from all completed terms (Fall 2023 - Spring 2026)
      expect(courses.length, 48);
    });

    test('groups courses by correct term', () {
      final courses = PdfHelper.parseTranscriptPdfText(extractedTranscriptText);

      final fall2023Courses = courses
          .where((c) => c.term == 'Fall, 2023')
          .toList();
      expect(fall2023Courses.length, 7);

      final winter2024Courses = courses
          .where((c) => c.term == 'Winter, 2024')
          .toList();
      expect(winter2024Courses.length, 5);

      final spring2024Courses = courses
          .where((c) => c.term == 'Spring, 2024')
          .toList();
      expect(spring2024Courses.length, 5);

      final fall2024Courses = courses
          .where((c) => c.term == 'Fall, 2024')
          .toList();
      expect(fall2024Courses.length, 6);

      final winter2025Courses = courses
          .where((c) => c.term == 'Winter, 2025')
          .toList();
      expect(winter2025Courses.length, 5);

      final spring2025Courses = courses
          .where((c) => c.term == 'Spring, 2025')
          .toList();
      expect(spring2025Courses.length, 6);

      final fall2025Courses = courses
          .where((c) => c.term == 'Fall, 2025')
          .toList();
      expect(fall2025Courses.length, 5);

      final winter2026Courses = courses
          .where((c) => c.term == 'Winter, 2026')
          .toList();
      expect(winter2026Courses.length, 6);

      final spring2026Courses = courses
          .where((c) => c.term == 'Spring, 2026')
          .toList();
      expect(spring2026Courses.length, 3);
    });

    test('handles empty string input', () {
      final courses = PdfHelper.parseTranscriptPdfText('');

      expect(courses.isEmpty, true);
    });

    test('handles text with no valid course patterns', () {
      final text = '''
This is just random text
No courses here
Just some words and numbers 123 456''';

      final courses = PdfHelper.parseTranscriptPdfText(text);

      expect(courses.isEmpty, true);
    });

    test('handles text with no term headers', () {
      final text =
          '''CHEM 141General ChemistryA3.03.012.0MATH 171Calculus IA4.04.016.0''';

      final courses = PdfHelper.parseTranscriptPdfText(text);

      expect(courses.isEmpty, true);
    });
  });

  group('PdfHelper.splitTextIntoTerms', () {
    test('splits transcript text into correct number of term sections', () {
      final termSections = PdfHelper.splitTextIntoTerms(
        extractedTranscriptText,
      );

      expect(termSections.length, 9);
    });

    test('extracts correct term keys', () {
      final termSections = PdfHelper.splitTextIntoTerms(
        extractedTranscriptText,
      );

      expect(termSections.keys.contains('Fall, 2023'), true);
      expect(termSections.keys.contains('Winter, 2024'), true);
      expect(termSections.keys.contains('Spring, 2024'), true);
      expect(termSections.keys.contains('Fall, 2024'), true);
      expect(termSections.keys.contains('Winter, 2025'), true);
      expect(termSections.keys.contains('Spring, 2025'), true);
      expect(termSections.keys.contains('Fall, 2025'), true);
      expect(termSections.keys.contains('Winter, 2026'), true);
      expect(termSections.keys.contains('Spring, 2026'), true);
    });

    test('term sections do not include term header in content', () {
      final termSections = PdfHelper.splitTextIntoTerms(
        extractedTranscriptText,
      );

      final fall2023Section = termSections['Fall, 2023']!;
      expect(fall2023Section.contains('Fall, 2023'), false);
      expect(fall2023Section.contains('CHEM 141'), true);
    });

    test('handles single term text correctly', () {
      final singleTermText = '''
Some header text
Fall, 2023        Sep 25, 2023     -    Dec 13, 2023CHEM 141General ChemistryA3.03.012.0
More content here''';

      final termSections = PdfHelper.splitTextIntoTerms(singleTermText);

      expect(termSections.length, 1);
      expect(termSections.keys.first, 'Fall, 2023');
    });

    test('returns empty map when no terms found', () {
      final noTermsText = '''
This is some text without any term headers
Just random content
No Fall, Winter, or Spring followed by year''';

      final termSections = PdfHelper.splitTextIntoTerms(noTermsText);

      expect(termSections.isEmpty, true);
    });

    test('handles multiple terms of same season', () {
      final multiSeasonText = '''
Fall, 2023     Some content here
CHEM 141General ChemistryA3.03.012.0
Fall, 2024     More content here
CPTR 280Cptr Org & AssemblyA-3.03.011.1
Fall, 2025     Even more content
CPTR 354Compilers and LanguagesA-4.04.014.8''';

      final termSections = PdfHelper.splitTextIntoTerms(multiSeasonText);

      expect(termSections.length, 3);
      expect(termSections.keys.contains('Fall, 2023'), true);
      expect(termSections.keys.contains('Fall, 2024'), true);
      expect(termSections.keys.contains('Fall, 2025'), true);
    });

    test('preserves section content integrity', () {
      final termSections = PdfHelper.splitTextIntoTerms(
        extractedTranscriptText,
      );

      final fall2023Section = termSections['Fall, 2023']!;
      expect(fall2023Section.contains('CHEM 141'), true);
      expect(fall2023Section.contains('MATH 171'), true);
      expect(fall2023Section.contains('RELB 105'), true);

      // Should not contain content from other terms
      expect(fall2023Section.contains('CPTR 142'), false);
      expect(fall2023Section.contains('Winter'), false);
    });

    test('handles terms at different positions in text', () {
      final text = '''
Header content
Fall, 2020     First term
Content A
Winter, 2021     Second term
Content B
Spring, 2021     Third term
Content C''';

      final termSections = PdfHelper.splitTextIntoTerms(text);

      expect(termSections.length, 3);
      expect(termSections['Fall, 2020']!.contains('Content A'), true);
      expect(termSections['Winter, 2021']!.contains('Content B'), true);
      expect(termSections['Spring, 2021']!.contains('Content C'), true);
    });
  });

  group('PdfHelper.extractCoursesFromTerm', () {
    test('extracts courses from single term section', () {
      final courses = PdfHelper.extractCoursesFromTerm(
        sampleTermText,
        'Fall, 2023',
      );

      expect(courses.length, 7);

      expect(courses[0].course, 'CHEM 141');
      expect(courses[1].course, 'CHEM 144');
      expect(courses[2].course, 'CPTR 141');
    });

    test('handles courses with newlines in text', () {
      final termText = '''
CPTR 242Seq & Parllel Dat Struct &
AlgA4.04.016.0ENGL 122College Writing IIA3.03.012.0''';

      final courses = PdfHelper.extractCoursesFromTerm(
        termText,
        'Spring, 2024',
      );

      expect(courses.length, 2);
      expect(courses[0].course, 'CPTR 242');
      expect(courses[0].courseTitle, 'Seq & Parllel Dat Struct & Alg');
      expect(courses[1].course, 'ENGL 122');
    });

    test('returns empty list when no valid courses found', () {
      final termText =
          'TERM TOTALS16.017.064.04.000CUMULATIVE TOTALS16.017.064.04.000';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Fall, 2023');

      expect(courses.length, 0);
    });

    test('correctly assigns term to all courses', () {
      final termText = '''
CPTR 280Cptr Org & Assembly
LanguageA-3.03.011.1CPTR 396Internship & Career ReadinessA1.01.04.0''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Fall, 2024');

      expect(courses.every((c) => c.term == 'Fall, 2024'), true);
    });

    test('extracts all grade types correctly', () {
      final termText = '''
MATH 239Introduction to Linear AlgebraA4.04.016.0PHYS 251Prin of
PhysicsA-3.03.011.1ENGR 123Intro to Engineering DesignA-2.02.07.4PHYS 252Prin of PhysicsB+3.03.09.9''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Test Term');

      expect(courses[0].grade, 'A');
      expect(courses[1].grade, 'A-');
      expect(courses[2].grade, 'A-');
      expect(courses[3].grade, 'B+');
    });

    test('extracts various credit amounts correctly', () {
      final termText = '''
CHEM 144General Chemistry LabA1.01.04.0ENGR 121Intro
to Profession of EngrA2.02.08.0CHEM 141General ChemistryA3.03.012.0CPTR 141Fundamentals of Programming IA4.04.016.0''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Fall, 2023');

      expect(courses[0].credits, 1.0);
      expect(courses[1].credits, 2.0);
      expect(courses[2].credits, 3.0);
      expect(courses[3].credits, 4.0);
    });

    test('extracts planned courses with NR grade', () {
      final courses = PdfHelper.extractCoursesFromTerm(
        samplePlannedTermText,
        'Winter, 2026',
      );

      expect(courses.length, 6);
      expect(courses.every((c) => c.grade == 'NR'), true);
      expect(courses.every((c) => c.term == 'Winter, 2026'), true);
    });

    test('correctly parses planned course details', () {
      final courses = PdfHelper.extractCoursesFromTerm(
        samplePlannedTermText,
        'Winter, 2026',
      );

      expect(courses[0].course, 'CPTR 308');
      expect(courses[0].courseTitle, 'Ethical Issues for Computing');
      expect(courses[0].grade, 'NR');
      expect(courses[0].credits, 4.0);

      expect(courses[1].course, 'CPTR 430');
      expect(courses[1].courseTitle, 'Artificial Intelligence');
      expect(courses[1].grade, 'NR');
      expect(courses[1].credits, 4.0);
    });

    test('handles 0-credit planned courses', () {
      final courses = PdfHelper.extractCoursesFromTerm(
        samplePlannedTermText,
        'Winter, 2026',
      );

      final dramaCourse = courses.firstWhere((c) => c.course == 'DRMA 252');
      expect(dramaCourse.courseTitle, 'Performance');
      expect(dramaCourse.grade, 'NR');
      expect(dramaCourse.credits, 0.0);
    });

    test('handles various NR grade course titles with line breaks', () {
      final termText = '''
CPTR 454Design & Analy of
AlgorithmsNR4.0InProcessPEAC 164Downhill Skiing/SnowboardingNR1.0InProcess''';

      final courses = PdfHelper.extractCoursesFromTerm(
        termText,
        'Winter, 2026',
      );

      expect(courses.length, 2);
      expect(courses[0].course, 'CPTR 454');
      expect(courses[0].courseTitle, 'Design & Analy of Algorithms');
      expect(courses[1].course, 'PEAC 164');
      expect(courses[1].courseTitle, 'Downhill Skiing/Snowboarding');
    });

    test('does not extract TERM TOTALS or CUMULATIVE TOTALS as courses', () {
      final termText =
          '''CHEM 141General ChemistryA3.03.012.0TERM TOTALS16.017.064.04.000CUMULATIVE TOTALS16.017.064.04.000''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Fall, 2023');

      expect(courses.length, 1);
      expect(courses[0].course, 'CHEM 141');
    });

    test('handles course titles with special characters', () {
      final termText =
          '''CPTR 242Seq & Parllel Dat Struct & AlgA4.04.016.0MATH 273Calc III (Multivariable)A-4.04.014.8''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Test Term');

      expect(courses[0].courseTitle, 'Seq & Parllel Dat Struct & Alg');
      expect(courses[1].courseTitle, 'Calc III (Multivariable)');
    });

    test('handles course codes with 3 and 4 letter prefixes', () {
      final termText =
          '''BIO 101Introduction to BiologyA4.04.016.0ENGR 123Engineering DesignA3.03.012.0''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Test Term');

      expect(courses[0].course, 'BIO 101');
      expect(courses[1].course, 'ENGR 123');
    });

    test('handles consecutive newlines in course title', () {
      final termText =
          '''CPTR 454Design & Analy of\n\nAlgorithmsNR4.0InProcess''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Test Term');

      expect(courses[0].courseTitle, 'Design & Analy of  Algorithms');
    });

    test('handles all edge case grades', () {
      final termText =
          '''GNRL 101University ExperienceS1.01.00.0CHEM 999Failed CourseF3.03.00.0MATH 100Incomplete CourseI2.0ENGR 200Incomplete GradedI*3.0PHYS 100In ProgressIP1.0CHEM 200In Progress GradedIP*2.0HIST 101WithdrawnW4.0RELB 102AuditAU3.0''';

      final courses = PdfHelper.extractCoursesFromTerm(termText, 'Test Term');

      expect(courses[0].grade, 'S');
      expect(courses[1].grade, 'F');
      expect(courses[2].grade, 'I');
      expect(courses[3].grade, 'I*');
      expect(courses[4].grade, 'IP');
      expect(courses[5].grade, 'IP*');
      expect(courses[6].grade, 'W');
      expect(courses[7].grade, 'AU');
    });
  });
}

final extractedTranscriptText = '''
Date Printed:  Jan 21, 2026
Page 1 of 1    
Walla Walla University204 S College Avenue, College Place, WA 99324  •  509-527-2811  •  ETS Code
4940  Office of the Registrar  •  Unofficial TranscriptStudent Name: Stefaniv, Anna SSN:
xxx-xx-xxxx ID: 2200057 Birthdate:  05/30Attend As Name:
 InaccordancewiththeFamilyRightsandPrivacyActof1974,thistranscriptmustnotbereleasedtoathirdpartyw
 ithoutwrittenauthorizationfromthestudent.Studentisingoodstandingandiseligibletoreturnunlessother
 wisestated.ThistranscriptisnotofficialunlessitbearsthesignatureoftheRegistrarandthesealoftheUniv
 ersity.
CourseCourse TitleGradeHoursAttempt.HoursEarnedGradePointsGPAAdmitted to: Walla Walla
UniversityMatriculated:   Sep 25, 2023
Fall, 2023        Sep 25, 2023     -    Dec 13, 2023CHEM 141General ChemistryA3.03.012.0CHEM
144General Chemistry LabA1.01.04.0CPTR 141Fundamentals of Programming IA4.04.016.0ENGR 121Intro
to Profession of EngrA2.02.08.0GNRL 101University ExperienceS1.01.00.0MATH 171Calculus
IA4.04.016.0RELB 105Sermon on the MountA2.02.08.0TERM TOTALS16.017.064.04.000CUMULATIVE
TOTALS16.017.064.04.000
Winter, 2024        Jan 8, 2024     -    Mar 20, 2024CPTR 142Fundamentals of Programming
IIA4.04.016.0ENGL 121College Writing IA3.03.012.0ENGR 122Intro to CADA2.02.08.0MATH 172Calculus
IIA4.04.016.0MATH 250Discrete MathematicsA4.04.016.0TERM TOTALS17.017.068.04.000CUMULATIVE
TOTALS33.034.0132.04.000
Spring, 2024        Apr 1, 2024     -    Jun 12, 2024CPTR 242Seq & Parllel Dat Struct &
AlgA4.04.016.0ENGL 122College Writing IIA3.03.012.0ENGR 123Intro to Engineering
DesignA-2.02.07.4GBUS 270Business CommunicationA4.04.016.0MATH 273Calculus IIIA-4.04.014.8TERM
TOTALS17.017.066.23.894CUMULATIVE TOTALS50.051.0198.23.964
Fall, 2024        Sep 30, 2024     -    Dec 18, 2024CPTR 280Cptr Org & Assembly
LanguageA-3.03.011.1CPTR 396Internship & Career ReadinessA1.01.04.0ENGL 223Research Writing
(WD)A3.03.012.0MATH 239Introduction to Linear AlgebraA4.04.016.0PHYS 251Prin of
PhysicsA-3.03.011.1PHYS 254Prin of Physics LabA1.01.04.0TERM TOTALS15.015.058.23.880CUMULATIVE
TOTALS65.066.0256.43.944
CourseCourse TitleGradeHoursAttempt.HoursEarnedGradePointsGPA
Winter, 2025        Jan 6, 2025     -    Mar 19, 2025CPTR 245Software DevelopmentA4.04.016.0MATH
215Data AnalysisA4.04.016.0PHYS 252Prin of PhysicsB+3.03.09.9PHYS 255Prin of Physics
LabA1.01.04.0SPCH 101Fundamentals of Speech CommA4.04.016.0TERM TOTALS16.016.061.93.868CUMULATIVE
TOTALS81.082.0318.33.929
Spring, 2025        Mar 31, 2025     -    Jun 11, 2025CPTR 320Web Services & Cloud
ComputingA4.04.016.0CPTR 479Dir Rsrch: Client/Server Web AA-1.01.03.7MATH 274Calculus
IVA4.04.016.0PEAC 157BackpackingA1.01.04.0RELB 104Ministry of JesusA4.04.016.0RELB 106Parables of
JesusA2.02.08.0TERM TOTALS16.016.063.73.981CUMULATIVE TOTALS97.098.0382.03.938
Fall, 2025        Sep 29, 2025     -    Dec 17, 2025CPTR 354Compilers and
LanguagesA-4.04.014.8CPTR 420Intro to Database SystemsA-4.04.014.8ENGR 354Digital
LogicA3.03.012.0GBUS 190Free Enterprise PracticumS0.00.00.0PSYC 140Intro to Psyc:Social
FoundatnsA4.04.016.0TERM TOTALS15.015.057.63.840CUMULATIVE TOTALS112.0113.0439.63.925
Winter, 2026        Jan 5, 2026     -    Mar 18, 2026CPTR 308Ethical Issues for
ComputingNR4.0InProcessCPTR 430Artificial IntelligenceNR4.0InProcessCPTR 454Design & Analy of
AlgorithmsNR4.0InProcessDRMA 101Introduction to TheatreNR3.0InProcessDRMA
252PerformanceNR0.0InProcessPEAC 164Downhill Skiing/SnowboardingNR1.0InProcess
Spring, 2026        Mar 30, 2026     -    Jun 10, 2026CPTR 352Operating SystemsNR4.0InProcessMATH
315Probability & StatisticsNR4.0InProcessRELT 202Christian BeliefsNR4.0InProcess
************************   END  OF  TRANSCRIPT  TO  DATE  ************************''';

final sampleTermText = '''
Sep 25, 2023     -    Dec 13, 2023CHEM 141General ChemistryA3.03.012.0CHEM
144General Chemistry LabA1.01.04.0CPTR 141Fundamentals of Programming IA4.04.016.0ENGR 121Intro
to Profession of EngrA2.02.08.0GNRL 101University ExperienceS1.01.00.0MATH 171Calculus
IA4.04.016.0RELB 105Sermon on the MountA2.02.08.0TERM TOTALS16.017.064.04.000CUMULATIVE
TOTALS16.017.064.04.000''';

final samplePlannedTermText = '''
Jan 5, 2026     -    Mar 18, 2026CPTR 308Ethical Issues for
ComputingNR4.0InProcessCPTR 430Artificial IntelligenceNR4.0InProcessCPTR 454Design & Analy of
AlgorithmsNR4.0InProcessDRMA 101Introduction to TheatreNR3.0InProcessDRMA
252PerformanceNR0.0InProcessPEAC 164Downhill Skiing/SnowboardingNR1.0InProcess''';
