import 'package:client/domain/audit_class.dart';
import 'package:client/domain/transcript_class.dart';

class Student {
  Student({this.audit, this.transcript});
  final Audit? audit;
  final Transcript? transcript;
}
