import 'package:client/domain/filters.dart';
import 'package:client/views/class_list/filtering/filter_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Filters>(
      builder: (context, filters, child) {
        final activeFilterCount = filters.activeFilterCount;
        final hasFilters = activeFilterCount > 0;

        return InkWell(
          key: const Key('Filter Button'),
          onTap: () async {
            await showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: 'Filter',
              barrierColor: Colors.black54,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: FilterMenu(filters: filters),
                  ),
                );
              },
              transitionBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          ),
                      child: child,
                    );
                  },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: hasFilters
                ? BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 16,
                  color: hasFilters ? Colors.blue.shade800 : null,
                ),
                const SizedBox(width: 4),
                Text(
                  hasFilters ? 'Filters: $activeFilterCount' : 'Filter',
                  style: TextStyle(
                    fontSize: 14,
                    color: hasFilters ? Colors.blue.shade800 : null,
                  ),
                ),
                if (hasFilters) ...[
                  const SizedBox(width: 4),
                  InkWell(
                    key: const Key('Clear Filters Icon'),
                    onTap: () async {
                      await Filters().reset();
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
