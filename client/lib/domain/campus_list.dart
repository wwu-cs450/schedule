import 'package:client/domain/campus.dart';

extension InitializeCampus on Campus {
  static Set<Campus> initialList() {
    final instances = <Campus>{};
    final lines = csv().split('\n');
    for (final line in lines) {
      final values = line.split(',');
      instances.add(Campus(values[0], values[1]));
    }
    return instances;
  }

  static String csv() {
    return '''
ACA,Adventist Colleges Abroad
ACDM,Acadeum
AHU,AdventHealth University
BI,Billings
CMC,Christian Music Center
CP,College Place
LAFS,LA Film Studies Center
MI,Missoula
ONLIN,Online
PD,Portland
RIZE,Rize
RO,Rosario''';
  }
}
