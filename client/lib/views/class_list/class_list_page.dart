import 'package:client/domain/filters.dart';
import 'package:client/domain/handlers/data_handler.dart';
import 'package:client/views/class_list/class_list.dart';
import 'package:client/views/class_list/filtering/filter_button.dart';
import 'package:flutter/material.dart';

class ClassListPage extends StatelessWidget {
  const ClassListPage({
    required this.size,
    required this.quarters,
    this.header,
    super.key,
  });

  final Widget? header;
  final ClassListSize size;
  final List<String> quarters;

  @override
  Widget build(BuildContext context) {
    final classes = Filters().classes;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                child: Text(
                  key: const Key('Class Count'),
                  '${classes.length} classes (from ${DataHandler.dateTime})',
                ),
              ),
              const FilterButton(),
            ],
          ),
        ),
        ?header,
        Expanded(
          child: ClassList(classes, size: size, quarters: quarters),
        ),
      ],
    );
  }
}
