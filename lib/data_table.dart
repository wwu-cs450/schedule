import 'package:flutter/material.dart';
import 'package:schedule/section.dart';

class TableData extends DataTableSource {
  TableData(this._data);
  final List<Section> _data;

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: [
        DataCell(Text(_data[index].course.subject!.code)),
        DataCell(Text(_data[index].course.number.toString())),
        DataCell(Text(_data[index].course.title)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}
