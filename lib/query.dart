// This is a stub for a future commit for !8.
import 'package:schedule/course.dart';
import 'package:schedule/department.dart';
import 'package:schedule/section.dart';

class Query {
  final Department? department;
  Query(this.department);

  Set<Section> get results {
    var result = <Section>{};
    if (department == null || department?.code == 'CPTR') {
      for (var i = 0; i < 5; i++) {
        var cs141 = Course('CPTR', 'CPTR', 'Fundamentals of Programming I',
            '${200 - i}', 'lower', 4);
        var cs141a =
            Section(cs141, 2239, 30, 'MWRF', 'KRH 348', 'James Foster', 'CP');
        result.add(cs141a);
      }
    }
    if (department == null || department?.code == 'MATH') {
      for (var i = 0; i < 5; i++) {
        var math181 =
            Course('MATH', 'MATH', 'Calculus I', '${200 - i}', 'lower', 4);
        var math181a =
            Section(math181, 2239, 30, 'MWRF', 'KRH 328', 'John Foster', 'CP');
        result.add(math181a);
      }
    }
    return result;
  }
}
