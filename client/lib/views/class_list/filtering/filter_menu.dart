import 'package:client/domain/campus.dart';
import 'package:client/domain/department.dart';
import 'package:client/domain/filters.dart';
import 'package:client/domain/hourminute.dart';
import 'package:client/domain/subject.dart';
import 'package:client/domain/term.dart';
import 'package:client/views/class_list/filtering/search_input.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({required this.filters, super.key});

  final Filters filters;

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final _campusSearchController = TextEditingController();
  final _departmentSearchController = TextEditingController();
  final _subjectSearchController = TextEditingController();
  final _classNumberController = TextEditingController();
  final _instructorController = TextEditingController();

  bool _campusExpanded = false;
  bool _departmentExpanded = false;
  bool _subjectExpanded = false;
  bool _levelExpanded = false;
  bool _creditsExpanded = false;
  bool _scheduleExpanded = false;
  bool _timeExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.filters.classNumber != 0) {
      _classNumberController.text = widget.filters.classNumber.toString();
    }
    if (widget.filters.instructor.isNotEmpty) {
      _instructorController.text = widget.filters.instructor;
    }
  }

  @override
  void dispose() {
    _campusSearchController.dispose();
    _departmentSearchController.dispose();
    _subjectSearchController.dispose();
    _classNumberController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 400,
        height: screenHeight - 16,
        child: Column(
          children: [
            header(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle switches for miscellaneous filters
                    filterToggles(),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildClassNumberField()),
                        const SizedBox(width: 8),
                        _buildTermField(),
                      ],
                    ),
                    _buildInstructorField(),

                    const SizedBox(height: 8),

                    // Department filter section
                    _buildFilterSection(
                      title: 'Department',
                      isExpanded: _departmentExpanded,
                      onToggle: () => setState(
                        () => _departmentExpanded = !_departmentExpanded,
                      ),
                      onReset: () async {
                        await widget.filters.setDepartments([]);
                      },
                      child: _buildDepartmentOptions(widget.filters),
                    ),

                    // Subject filter section
                    _buildFilterSection(
                      title: 'Subject',
                      isExpanded: _subjectExpanded,
                      onToggle: () =>
                          setState(() => _subjectExpanded = !_subjectExpanded),
                      onReset: () async {
                        await widget.filters.setSubjects([]);
                      },
                      child: _buildSubjectOptions(widget.filters),
                    ),

                    // Campus filter section
                    _buildFilterSection(
                      title: 'Campus',
                      isExpanded: _campusExpanded,
                      onToggle: () =>
                          setState(() => _campusExpanded = !_campusExpanded),
                      onReset: () async {
                        await widget.filters.setCampuses([]);
                      },
                      child: _buildCampusOptions(widget.filters),
                    ),

                    // Level filter section
                    _buildFilterSection(
                      title: 'Level',
                      isExpanded: _levelExpanded,
                      onToggle: () =>
                          setState(() => _levelExpanded = !_levelExpanded),
                      onReset: () async {
                        await widget.filters.setLevels([
                          'Lower',
                          'Upper',
                          'Grad',
                        ]);
                      },
                      child: _buildLevelOptions(widget.filters),
                    ),

                    // Credits filter section
                    _buildFilterSection(
                      title: 'Credits',
                      isExpanded: _creditsExpanded,
                      onToggle: () =>
                          setState(() => _creditsExpanded = !_creditsExpanded),
                      onReset: () async {
                        await widget.filters.setCredits([
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '>4',
                        ]);
                      },
                      child: _buildCreditsOptions(widget.filters),
                    ),

                    // Schedule filter section
                    _buildFilterSection(
                      title: 'Schedule',
                      isExpanded: _scheduleExpanded,
                      onToggle: () => setState(
                        () => _scheduleExpanded = !_scheduleExpanded,
                      ),
                      onReset: () async {
                        await widget.filters.setSchedule([
                          'Sunday',
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                        ]);
                        await widget.filters.setScheduleLogic('Any');
                        setState(() {});
                        setState(() {});
                      },
                      child: _buildScheduleOptions(widget.filters),
                    ),

                    // Time filter section
                    _buildFilterSection(
                      title: 'Time',
                      isExpanded: _timeExpanded,
                      onToggle: () =>
                          setState(() => _timeExpanded = !_timeExpanded),
                      onReset: () async {
                        await widget.filters.setStartTime(null);
                        await widget.filters.setEndTime(null);
                      },
                      child: _buildTimeOptions(widget.filters),
                    ),
                  ],
                ),
              ),
            ),

            actionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Select filters below',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.close, size: 20),
          ),
        ],
      ),
    );
  }

  Widget actionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 8,
        children: [
          Flexible(
            child: TextButton(
              onPressed: () async {
                await widget.filters.reset();
                setState(() {});
              },
              child: const Text('Reset all'),
            ),
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Show results'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Class Number',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          ShadInput(
            key: const Key('Class Number Input'),
            controller: _classNumberController,
            placeholder: const Text('Enter 4-digit class number'),
            keyboardType: TextInputType.number,
            onChanged: (value) async {
              var classNumber = 0;
              if (value.length == 4) {
                try {
                  classNumber = int.parse(value);
                } on FormatException {
                  // not a number
                }
              }
              await widget.filters.setClassNumber(classNumber);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructor',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          ShadInput(
            key: const Key('Instructor Input'),
            controller: _instructorController,
            placeholder: const Text('Search by instructor name'),
            onChanged: (value) async {
              await widget.filters.setInstructor(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTermField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Term',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          SizedBox(
            key: const Key('Term Select'),
            child: ShadSelect<Term>(
              key: ValueKey(widget.filters.term),
              initialValue: widget.filters.term,
              placeholder: const Text(
                'Select a term',
                style: TextStyle(fontSize: 13),
              ),
              options: Term.instances
                  .map(
                    (term) => ShadOption(
                      value: term,
                      child: Text(
                        term.name,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              selectedOptionBuilder: (context, value) =>
                  Text(value.name, style: const TextStyle(fontSize: 13)),
              onChanged: (value) async {
                if (value != null) {
                  await widget.filters.setTerm(value);
                  setState(() {});
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required VoidCallback onReset,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onReset,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: child,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCampusOptions(Filters filters) {
    final campuses = Campus.instances.where((c) {
      // Filter out the "All Campuses" option
      if (c == Campus.allCampuses()) {
        return false;
      }

      final searchQuery = _campusSearchController.text.toLowerCase();
      if (searchQuery.isEmpty) {
        return true;
      }
      return c.name.toLowerCase().contains(searchQuery) ||
          c.code.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      children: [
        SearchInput(
          controller: _campusSearchController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text(
            'Select all',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          value: () {
            final allCampuses = Campus.instances
                .where((c) => c != Campus.allCampuses())
                .toList();
            final selectedCampuses = filters.campuses
                .where((c) => c != Campus.allCampuses())
                .toList();
            if (selectedCampuses.length == allCampuses.length) {
              return true;
            }
            if (selectedCampuses.isEmpty) {
              return false;
            }
            return null;
          }(),
          tristate: true,
          onChanged: (value) async {
            if (value == true) {
              // Was false, now selecting all
              final allCampuses = Campus.instances
                  .where((c) => c != Campus.allCampuses())
                  .toList();
              await filters.setCampuses(allCampuses);
            } else {
              // Was true or null, now deselecting all
              await filters.setCampuses([]);
            }
            setState(() {});
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const Divider(height: 8),
        ...campuses.map((campus) {
          final isSelected = filters.campuses.contains(campus);
          return CheckboxListTile(
            title: Text(
              '${campus.code} - ${campus.name}',
              style: const TextStyle(fontSize: 13),
            ),
            value: isSelected,
            onChanged: (value) async {
              final newCampuses = List<Campus>.from(filters.campuses);
              if (value == true) {
                if (!newCampuses.contains(campus)) {
                  newCampuses.add(campus);
                }
              } else {
                newCampuses.remove(campus);
              }
              await filters.setCampuses(newCampuses);
              setState(() {});
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  Widget _buildDepartmentOptions(Filters filters) {
    final departments = Department.instances.where((d) {
      // Filter out the "All Departments" option
      if (d == Department.allDepartments()) {
        return false;
      }

      final searchQuery = _departmentSearchController.text.toLowerCase();
      if (searchQuery.isEmpty) {
        return true;
      }
      return d.name.toLowerCase().contains(searchQuery) ||
          d.code.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      children: [
        SearchInput(
          controller: _departmentSearchController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text(
            'Select all',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          value: () {
            final allDepartments = Department.instances
                .where((d) => d != Department.allDepartments())
                .toList();
            final selectedDepartments = filters.departments
                .where((d) => d != Department.allDepartments())
                .toList();
            if (selectedDepartments.length == allDepartments.length) {
              return true;
            }
            if (selectedDepartments.isEmpty) {
              return false;
            }
            return null;
          }(),
          tristate: true,
          onChanged: (value) async {
            if (value == true) {
              // Was false, now selecting all
              final allDepartments = Department.instances
                  .where((d) => d != Department.allDepartments())
                  .toList();
              await filters.setDepartments(allDepartments);
            } else {
              // Was true or null, now deselecting all
              await filters.setDepartments([]);
            }
            setState(() {});
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const Divider(height: 8),
        ...departments.map((dept) {
          final isSelected = filters.departments.contains(dept);
          return CheckboxListTile(
            title: Text(
              '${dept.code} - ${dept.name}',
              style: const TextStyle(fontSize: 13),
            ),
            value: isSelected,
            onChanged: (value) async {
              final newDepartments = List<Department>.from(filters.departments);
              if (value == true) {
                if (!newDepartments.contains(dept)) {
                  newDepartments.add(dept);
                }
              } else {
                newDepartments.remove(dept);
              }
              await filters.setDepartments(newDepartments);
              setState(() {});
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  Widget _buildLevelOptions(Filters filters) {
    final levels = {
      'Lower': 'Lower (100-299)',
      'Upper': 'Upper (300-499)',
      'Grad': 'Grad (500+)',
    };

    final selectedLevels = filters.levels;
    final allSelected =
        selectedLevels.length == levels.length &&
        levels.keys.every((k) => selectedLevels.contains(k));
    final someSelected = selectedLevels.isNotEmpty && !allSelected;

    return Column(
      children: [
        CheckboxListTile(
          title: const Text(
            'Select all',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          value: allSelected ? true : (someSelected ? null : false),
          tristate: true,
          onChanged: (value) async {
            if (value == true) {
              // Was false, now selecting all
              await filters.setLevels(levels.keys.toList());
            } else {
              // Was true or null, now deselecting all
              await filters.setLevels([]);
            }
            setState(() {});
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const Divider(height: 8),
        ...levels.entries.map((entry) {
          return CheckboxListTile(
            title: Text(entry.value, style: const TextStyle(fontSize: 13)),
            value: selectedLevels.contains(entry.key),
            onChanged: (value) async {
              final newLevels = List<String>.from(selectedLevels);
              if (value == true) {
                if (!newLevels.contains(entry.key)) {
                  newLevels.add(entry.key);
                }
              } else {
                newLevels.remove(entry.key);
              }
              await filters.setLevels(newLevels);
              setState(() {});
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  Widget _buildCreditsOptions(Filters filters) {
    final credits = {
      '0': '0 Cr',
      '1': '1 Cr',
      '2': '2 Cr',
      '3': '3 Cr',
      '4': '4 Cr',
      '>4': '>4 Cr',
    };

    final selectedCredits = filters.credits;
    final allSelected =
        selectedCredits.length == credits.length &&
        credits.keys.every((k) => selectedCredits.contains(k));
    final someSelected = selectedCredits.isNotEmpty && !allSelected;

    return Column(
      children: [
        CheckboxListTile(
          title: const Text(
            'Select all',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          value: allSelected ? true : (someSelected ? null : false),
          tristate: true,
          onChanged: (value) async {
            if (value == true) {
              // Was false, now selecting all
              await filters.setCredits(credits.keys.toList());
            } else {
              // Was true or null, now deselecting all
              await filters.setCredits([]);
            }
            setState(() {});
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const Divider(height: 8),
        ...credits.entries.map((entry) {
          return CheckboxListTile(
            title: Text(entry.value, style: const TextStyle(fontSize: 13)),
            value: selectedCredits.contains(entry.key),
            onChanged: (value) async {
              final newCredits = List<String>.from(selectedCredits);
              if (value == true) {
                if (!newCredits.contains(entry.key)) {
                  newCredits.add(entry.key);
                }
              } else {
                newCredits.remove(entry.key);
              }
              await filters.setCredits(newCredits);
              setState(() {});
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  Widget _buildSubjectOptions(Filters filters) {
    final subjects = Subject.instances.where((s) {
      // Filter out the "All Subjects" option
      if (s == Subject.allSubjects()) {
        return false;
      }

      final searchQuery = _subjectSearchController.text.toLowerCase();
      if (searchQuery.isEmpty) {
        return true;
      }
      return s.name.toLowerCase().contains(searchQuery) ||
          s.code.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      children: [
        SearchInput(
          controller: _subjectSearchController,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          title: const Text(
            'Select all',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          value: () {
            final allSubjects = Subject.instances
                .where((s) => s != Subject.allSubjects())
                .toList();
            final selectedSubjects = filters.subjects
                .where((s) => s != Subject.allSubjects())
                .toList();
            if (selectedSubjects.length == allSubjects.length) {
              return true;
            }
            if (selectedSubjects.isEmpty) {
              return false;
            }
            return null;
          }(),
          tristate: true,
          onChanged: (value) async {
            if (value == true) {
              // Was false, now selecting all
              final allSubjects = Subject.instances
                  .where((s) => s != Subject.allSubjects())
                  .toList();
              await filters.setSubjects(allSubjects);
            } else {
              // Was true or null, now deselecting all
              await filters.setSubjects([]);
            }
            setState(() {});
          },
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const Divider(height: 8),
        ...subjects.map((subject) {
          final isSelected = filters.subjects.contains(subject);
          return CheckboxListTile(
            title: Text(
              '${subject.code} - ${subject.name}',
              style: const TextStyle(fontSize: 13),
            ),
            value: isSelected,
            onChanged: (value) async {
              final newSubjects = List<Subject>.from(filters.subjects);
              if (value == true) {
                if (!newSubjects.contains(subject)) {
                  newSubjects.add(subject);
                }
              } else {
                newSubjects.remove(subject);
              }
              await filters.setSubjects(newSubjects);
              setState(() {});
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  Widget _buildScheduleOptions(Filters filters) {
    final weekdays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ScheduleLogicToggle(
          filters: filters,
          onChanged: () => setState(() {}),
        ),

        const SizedBox(height: 12),

        // Day checkboxes
        ...weekdays.map((day) {
          final isSelected = filters.schedule.contains(day);
          return CheckboxListTile(
            title: Text(day, style: const TextStyle(fontSize: 13)),
            value: isSelected,
            onChanged: (value) async {
              final newSchedule = List<String>.from(filters.schedule);
              if (value == true) {
                newSchedule.add(day);
              } else {
                newSchedule.remove(day);
              }
              await filters.setSchedule(newSchedule);
              setState(() {});
            },
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            controlAffinity: ListTileControlAffinity.leading,
          );
        }),
      ],
    );
  }

  Widget _buildTimeOptions(Filters filters) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Start',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              SizedBox(
                key: const Key('Start Time Select'),
                child: ShadSelect<HourMinute>(
                  key: ValueKey(filters.startTime),
                  initialValue: filters.startTime,
                  placeholder: const Text(
                    'Any',
                    style: TextStyle(fontSize: 13),
                  ),
                  allowDeselection: true,
                  options: List.generate(14, (index) {
                    final time = HourMinute(hour: 7 + index, minute: 0);
                    return ShadOption(
                      value: time,
                      child: Text(
                        time.toString(is24hr: false),
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }),
                  selectedOptionBuilder: (context, value) => Text(
                    value.toString(is24hr: false),
                    style: const TextStyle(fontSize: 13),
                  ),
                  onChanged: (value) async {
                    await filters.setStartTime(value);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'End',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              SizedBox(
                key: const Key('End Time Select'),
                child: ShadSelect<HourMinute>(
                  key: ValueKey(filters.endTime),
                  initialValue: filters.endTime,
                  placeholder: const Text(
                    'Any',
                    style: TextStyle(fontSize: 13),
                  ),
                  allowDeselection: true,
                  options: List.generate(14, (index) {
                    final time = HourMinute(hour: 7 + index, minute: 50);
                    return ShadOption(
                      value: time,
                      child: Text(
                        time.toString(is24hr: false),
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }),
                  selectedOptionBuilder: (context, value) => Text(
                    value.toString(is24hr: false),
                    style: const TextStyle(fontSize: 13),
                  ),
                  onChanged: (value) async {
                    await filters.setEndTime(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget filterToggles() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildToggleChip(
          'General Studies',
          widget.filters.isGS,
          widget.filters.setIsGS,
        ),
        _buildToggleChip(
          'Is Open',
          widget.filters.isOpen,
          widget.filters.setIsOpen,
        ),
        _buildToggleChip(
          'Not Taken',
          widget.filters.isNotTaken,
          widget.filters.setIsNotTaken,
        ),
        _buildToggleChip(
          'Free Classrooms',
          widget.filters.isFreeClassrooms,
          widget.filters.setIsFreeClassrooms,
        ),
      ],
    );
  }

  Widget _buildToggleChip(
    String label,
    bool selected,
    Future<void> Function(bool) onChanged,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await onChanged(!selected);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? Colors.black87 : Colors.grey.shade300,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              if (selected)
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 11, color: Colors.white),
                ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleLogicToggle extends StatelessWidget {
  const _ScheduleLogicToggle({required this.filters, required this.onChanged});

  final Filters filters;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          _buildOption(
            value: 'Any',
            tooltip: 'Show classes that meet on ANY of the selected days',
          ),
          _buildOption(
            value: 'All',
            tooltip: 'Show classes that meet on ALL selected days',
          ),
          _buildOption(
            value: 'Exclude',
            tooltip: 'Hide classes that meet on any of the selected days',
          ),
        ],
      ),
    );
  }

  Widget _buildOption({required String value, required String tooltip}) {
    final isSelected = filters.scheduleLogic == value;

    return Expanded(
      child: Tooltip(
        message: tooltip,
        waitDuration: const Duration(milliseconds: 500),
        child: InkWell(
          onTap: () async {
            await filters.setScheduleLogic(value);
            onChanged();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
