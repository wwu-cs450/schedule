import 'package:client/domain/course.dart';
import 'package:client/domain/handlers/class_storage.dart';
import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/domain/persister.dart';
import 'package:common/completed_course.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final storage = ClassStorage();

  setUp(() async {
    AbstractPersister.instance = MockPersister();
    await DataHandler.fetchData(test: true);
    await storage.clearTranscript();
  });

  test('haveTaken matches full course code, not only subject', () async {
    final cp141 = Course.instances.firstWhere(
      (course) => course.subject.code == 'CPTR' && course.number == '141',
    );

    await storage.addClasses([
      CompletedCourse(
        course: 'CPTR 141',
        courseTitle: 'Fundamentals of Programming I',
        grade: 'A',
        credits: 4,
        term: 'Fall, 2023',
      ),
    ]);

    expect(storage.haveTaken(cp141), isTrue);

    final cp142 = Course.instances.firstWhere(
      (course) => course.subject.code == 'CPTR' && course.number == '142',
    );
    expect(storage.haveTaken(cp142), isFalse);
  });

  test('haveTaken handles suffix course numbers', () async {
    final drma253sn = Course.instances.firstWhere(
      (course) => course.subject.code == 'DRMA' && course.number == '253SN',
    );

    await storage.addClasses([
      CompletedCourse(
        course: 'DRMA 253',
        courseTitle: 'Performance',
        grade: 'A',
        credits: 0,
        term: 'Fall, 2023',
      ),
    ]);

    expect(storage.haveTaken(drma253sn), isTrue);
  });
}
