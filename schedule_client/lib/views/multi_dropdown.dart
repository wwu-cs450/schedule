import 'package:flutter/material.dart';

class MultiSelectDropdown {
  const MultiSelectDropdown({
    required this.context,
    required this.allItems,
    required this.selectedItems,
    this.label,
    this.onChanged,
    this.key,
  });

  final BuildContext context;
  final List<String> allItems;
  final List<String> selectedItems;

  // Function is called when selectedItems changes.
  // - In order to allow the client to update the state
  final void Function()? onChanged;
  final Key? key;
  final String? label;

  Widget build() {
    final entries = <DropdownMenuEntry>[];

    for (final item in allItems) {
      entries.add(
        DropdownMenuEntry(
          enabled: false,
          value: item,
          label: item,
          labelWidget: Row(
            children: [
              Checkbox(
                value: selectedItems.contains(item),
                onChanged: (bool? value) {
                  if (!value!) {
                    selectedItems.remove(item);
                  } else {
                    selectedItems.add(item);
                  }
                  onChanged?.call();
                },
              ),
              GestureDetector(
                onTap: () {
                  if (selectedItems.contains(item)) {
                    selectedItems.remove(item);
                  } else {
                    selectedItems.add(item);
                  }
                  onChanged?.call();
                },
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final sortedItems = allItems.toList();
    selectedItems.sort(
      (a, b) => sortedItems.indexOf(a).compareTo(sortedItems.indexOf(b)),
    );

    return DropdownMenu(
      key: key,
      label: Text(
        selectedItems.isEmpty
            ? label ?? 'Select items...'
            : selectedItems.join(', '),
      ),
      dropdownMenuEntries: entries,
      onSelected: null,
    );
  }
}
