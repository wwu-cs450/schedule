import 'package:schedule/department.dart';

extension InitializeDepartment on Department {
  static Set<Department> initialList() {
    var instances = <Department>{};
    _departments.forEach((key, value) {
      instances.add(Department(key, value));
    });
    return instances;
  }
}

Map<String, String> _departments = {
  "WWU": "Walla Walla University",
  "TECH": "Technology",
  "SOWK": "Social Work & Sociology",
  "RELB": "Theology",
  "PREP": "Pre-Professional",
  "PHYS": "Physics",
  "NRSG": "Nursing",
  "NDEP": "Non-Departmental",
  "MUCT": "Music",
  "MDLG": "Modern Language",
  "MATH": "Mathematics",
  "LIBR": "Library",
  "INTR": "Interdisciplinary Programs",
  "HONR": "Honors",
  "HMEC": "Home Economics",
  "HLTH": "Health and Physical Education",
  "HIST": "History and Philosophy",
  "ESLP": "English as Second Language",
  "ENGL": "English & Modern Languages",
  "ENGI": "Engineering",
  "EDUC": "Education & Psychology",
  "CPTR": "Computer Science",
  "COMM": "Communication",
  "CHEM": "Chemistry",
  "BUSI": "Business",
  "BIOL": "Biology",
  "ART": "Art",
  "ACDM": "Acadeum"
};
