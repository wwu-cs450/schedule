import 'package:flutter/material.dart';
import 'package:schedule/section.dart';

class TableData extends DataTableSource {
  List<Section> _data = <Section>[]; // Sorted Data?
  TableData(Set<Section> sectionSet) {
    // Unsorted Data
    _data = sectionSet.toList();
    _data.sort((a, b) {
      if (a.course.number < b.course.number) {
        return -1;
      }
      if (a.course.number == b.course.number) {
        return 0;
      }
      return 1;
    });
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index].course.subject!.code)),
      DataCell(Text(_data[index].course.number.toString())),
      DataCell(Text(_data[index].course.title)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
