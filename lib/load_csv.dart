import 'package:csv/csv.dart';

import 'package:schedule/schedule.dart';

List<List<dynamic>> getListFromCsv() {
  final csvFile = getSchedule();
  return const CsvToListConverter(fieldDelimiter: ',', eol: '\n')
      .convert(csvFile)
      .toList();
}
