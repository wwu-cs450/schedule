import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: controller,
      placeholder: const Text('Search'),
      leading: const Padding(
        padding: EdgeInsets.only(left: 4),
        child: Icon(Icons.search, size: 16),
      ),
      onChanged: onChanged,
      decoration: ShadDecoration(
        border: ShadBorder.all(radius: BorderRadius.all(Radius.circular(999))),
        secondaryFocusedBorder: ShadBorder.all(width: 0),
      ),
    );
  }
}
