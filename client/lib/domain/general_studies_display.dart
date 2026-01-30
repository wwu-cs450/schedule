import 'package:client/domain/class.dart';
import 'package:client/domain/general_studies.dart';
import 'package:flutter/material.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({required this.classInstance, super.key});
  final Class classInstance;

  @override
  Widget build(BuildContext context) {
    final gsCategory = GeneralStudies.findCategory(classInstance.course.title);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: gsCategory != null
            ? 'GS Category: $gsCategory'
            : 'No GS Category',
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            classInstance.course.title,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
