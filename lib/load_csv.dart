import 'package:csv/csv.dart';

import './schedule.dart';

List<List<dynamic>> getListFromCsv() {
  final csvFile = getSchedule();
  return const CsvToListConverter(fieldDelimiter: ',', eol: '\n')
      .convert(csvFile)
      .toList();
}
