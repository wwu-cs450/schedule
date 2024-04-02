import 'package:flutter_test/flutter_test.dart';
import 'package:schedule_client/domain/csv_handler.dart';
import 'package:schedule_client/domain/data_handler.dart';

//Write tests here
void main() {
  setUp(() {
    DataHandler.empty();
    CSVHandler.empty();
  });
}
