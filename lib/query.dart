// This is a stub for a future commit for !8.
import 'package:schedule/course.dart';
import 'package:schedule/section.dart';

class Query {
  Set<Section> get results {
    var result = <Section>{};
    for (var i = 0; i < 20; i++) {
      var cs141 = Course('CPTR', 'CPTR', 'Fundamentals of Programming I',
          '${200 - i}', 'lower', 4);
      var cs141a =
          Section(cs141, 2239, 30, 'MWRF', 'KRH 348', 'James Foster', 'CP');
      result.add(cs141a);
    }
    return result;
  }
}
