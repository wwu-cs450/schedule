import 'package:flutter/material.dart';

class SegmentedToggle extends StatefulWidget {
  const SegmentedToggle({
    required this.options,
    required this.onSelected,
    this.initialIndex = 0,
    super.key,
  });

  final List<SegmentedToggleOption> options;
  final void Function(String value) onSelected;
  final int initialIndex;

  @override
  State<SegmentedToggle> createState() => _SegmentedToggleState();
}

class _SegmentedToggleState extends State<SegmentedToggle> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: widget.options
            .map(
              (option) =>
                  _buildOption(value: option.value, tooltip: option.tooltip),
            )
            .toList(),
      ),
    );
  }

  Widget _buildOption({required String value, required String tooltip}) {
    return Expanded(
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 500),
        child: InkWell(
          onTap: () async {
            setState(() {
              selectedIndex = widget.options.indexWhere(
                (o) => o.value == value,
              );
            });
            widget.onSelected(value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color:
                  selectedIndex ==
                      widget.options.indexWhere((o) => o.value == value)
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    selectedIndex ==
                        widget.options.indexWhere((o) => o.value == value)
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SegmentedToggleOption {
  SegmentedToggleOption({required this.value, required this.tooltip});

  final String value;
  final String tooltip;
}
