import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart';
import 'package:universal_html/parsing.dart';

class HTMLHandler {
  factory HTMLHandler() {
    return _instance;
  }
  // Singleton pattern
  HTMLHandler._privateConstructor();
  static final HTMLHandler _instance = HTMLHandler._privateConstructor();
  late String year;

  Future<String> fetchHtml() async {
    final currentTime = DateTime.now();
    if (currentTime.month > 0 && currentTime.month < 7) {
      year = currentTime.year.toString();
    } else {
      year = (currentTime.year + 1).toString();
    }
    final response = await http.get(
      Uri.https(
        'classopen.wallawalla.edu',
        '/classopenps.php',
        {
          'strm': 'f$year',
          'submit': 'Search',
        },
      ),
    );
    return response.body;
  }

  Future<List<List<String>>> listFromHtml() async {
    final data = <List<String>>[];
    final document = await fetchHtml();
    final htmlDoc = parseHtmlDocument(
      document.replaceAll(RegExp(r'(<br \/>|<br>)+'), '/'),
    );
    final classTable = htmlDoc.getElementById('resulttable');

    if (classTable == null) {
      throw Exception('Class Table is empty.');
    }
    final rows = classTable.getElementsByClassName('evenrow') +
        classTable.getElementsByClassName('oddrow');
    for (final each in rows) {
      final nodes = each.childNodes;
      final row = List<String>.filled(30, '');
      // CRSE_OFFER_NBR, default=1; unused?
      row[0] = '1';
      // CAMPUS, =CP   CP
      row[1] = nodes[38].text?.trim() ?? '';
      // ACAD_YEAR, =2024    2024
      row[2] = year;
      // ACAD_ORG,     BIOL
      try {
        row[3] = _subjDept[nodes[2].text!]?.trim();
      } catch (e) {
        throw Exception('Subject "${nodes[2].text!}" not found!');
      }
      // WWU_ACAD_ORG_DESCR,   Biology
      row[4] = _deptFullname[row[3]] ?? row[3];
      // CLASS_NBR,    1536
      row[5] = nodes[0].text?.trim() ?? '';
      // WWU_GS,   GS or space
      row[6] = nodes[16].text == 'GS' ? 'GS' : '';
      // SUBJECT
      row[7] = nodes[2].text?.trim() ?? '';
      // WWU_SUM1
      row[8] = nodes[4].text?.trim() ?? '';
      // WWU_FAL
      row[9] = nodes[6].text?.trim() ?? '';
      // WWU_WTR
      row[10] = nodes[8].text?.trim() ?? '';
      // WWU_SPR
      row[11] = nodes[10].text?.trim() ?? '';
      // WWU_SUM2
      row[12] = nodes[12].text?.trim() ?? '';
      // CLASS_SECTION
      row[13] = nodes[14].text?.trim() ?? '';
      // DESCR
      row[14] = nodes[20].text?.trim() ?? '';
      // WWU_UNITS
      row[15] = nodes[18].text?.trim() ?? '';
      // ENRL_STAT
      row[16] = nodes[22].text?.trim() ?? '';
      // ENRL_TOT
      row[17] = nodes[24].text?.trim() ?? '';
      // ENRL_CAP
      row[18] = nodes[26].text?.trim() ?? '';
      // WAIT_TOT
      row[19] = nodes[28].text?.trim().replaceAll(' in wait list', '') ?? '';
      // FEE_AMT
      row[20] = nodes[30].text?.trim().replaceAll('\$', '') ?? '';
      // WWU_MTG_PAT_COMB
      row[21] = nodes[32].text?.trim() ?? '';
      // WWU_ROOM -- sometimes is only a line break
      row[22] = nodes[34].text?.trim().replaceFirst(RegExp(r'^/$'), '') ?? '';
      // WWU_INSTR_NAME
      row[23] = nodes[36].text?.trim() ?? '';
      // DESCRLONG
      row[24] = nodes[44].text?.trim() ?? '';
      // INSTRUCTION_MODE, O=Online, P=In Person
      row[25] = row[22] == 'ONLINE' ? 'O' : 'P';
      //SCHEDULE_PRINT we don't use it, so for yeah I will leave it blank.
      row[26] = '';
      //VIDEO_LINK
      if (nodes[40].hasChildNodes()) {
        row[27] =
            (nodes[40] as TableCellElement).children[0].attributes['href'] ??
                '';
      } else {
        row[27] = '';
      }
      //CONSENT,  I=Instructor consent required, D=Department consent required, N=No consent needed
      if (nodes[42].text == null || nodes[42].text == '') {
        row[28] = 'N';
      } else {
        if (nodes[42].text!.contains('Instructor')) {
          row[28] = 'I';
        } else {
          row[28] = 'D';
        }
      }
      //CONSENT_DESCR
      row[29] = nodes[42].text?.trim() ?? '';
      data.add(row);
    }
    return data;
  }

  // Hard-coded maps for subject and department
  // TODO: Dynamically generate these?

  final Map _subjDept = {
    'ACCT': 'BUSI',
    'ACDM': 'ACDM',
    'ANTH': 'SOWK',
    'ART': 'ART',
    'AUTO': 'TECH',
    'AVIA': 'TECH',
    'BIOL': 'BIOL',
    'CDEV': 'NDEP',
    'CHPL': 'RELB',
    'CHEM': 'CHEM',
    'CIS': 'BUSI',
    'CMC': 'MUCT',
    'COMM': 'COMM',
    'CORR': 'SOWK',
    'CPTR': 'CPTR',
    'CYBS': 'CPTR',
    'DRMA': 'COMM',
    'DSGN': 'TECH',
    'ECON': 'BUSI',
    'EDAD': 'EDUC',
    'EDCI': 'EDUC',
    'EDFB': 'EDUC',
    'EDUC': 'EDUC',
    'ENGL': 'ENGL',
    'ENGR': 'ENGI',
    'ENVI': 'ENGI',
    'FILM': 'VISA',
    'FINA': 'BUSI',
    'FLTV': 'COMM',
    'FREN': 'ENGL',
    'GBUS': 'BUSI',
    'GDEV': 'CPTR',
    'GEOG': 'HIST',
    'GEOL': 'ACDM',
    'GNRL': 'NDEP',
    'GREK': 'RELB',
    'GRPH': 'TECH',
    'HEBR': 'RELB',
    'HIST': 'HIST',
    'HLTH': 'HLTH',
    'HMNT': 'HIST',
    'HONR': 'HONR',
    'ITLN': 'MDLG',
    'JOUR': 'COMM',
    'LANG': 'ENGL',
    'LAW': 'HIST',
    'MATH': 'MATH',
    'MDEV': 'MATH',
    'MDLG': 'MDLG',
    'MEDU': 'MATH',
    'MGMT': 'BUSI',
    'MKTG': 'BUSI',
    'MUCT': 'MUCT',
    'MUED': 'MUCT',
    'MUHL': 'MUCT',
    'MUPF': 'MUCT',
    'NRSG': 'NRSG',
    'PEAC': 'HLTH',
    'PETH': 'HLTH',
    'PHIL': 'HIST',
    'PHTO': 'TECH',
    'PHYS': 'PHYS',
    'PLSC': 'HIST',
    'PRDN': 'TECH',
    'PREL': 'COMM',
    'PSYC': 'EDUC',
    'RELB': 'RELB',
    'RELH': 'RELB',
    'RELM': 'RELB',
    'RELP': 'RELB',
    'RELT': 'RELB',
    'SCDI': 'BIOL',
    'SERV': 'NDEP',
    'SMTF': 'NDEP',
    'SOCI': 'SOWK',
    'SOWK': 'SOWK',
    'SPAN': 'MDLG',
    'SPCH': 'COMM',
    'SPED': 'EDUC',
    'SPPA': 'COMM',
    'TECH': 'TECH',
    'VIS': 'VISA',
    'VISA': 'VISA',
    'VISD': 'VISA',
    'VISF': 'VISA',
    'WRIT': 'ENGL',
  };

  final Map _deptFullname = {
    'ACCT': 'Business',
    'ACDM': 'Acadeum',
    'ANTH': 'Social Work & Sociology',
    'ART': 'Art',
    'AUTO': 'Technology',
    'AVIA': 'Technology',
    'BIOL': 'Biology',
    'CDEV': 'Non-Departmental',
    'CHPL': 'Chaplaincy',
    'CHEM': 'Chemistry',
    'CIS': 'Business',
    'COMM': 'Communication',
    'CPTR': 'Computer Science',
    'CYBS': 'Computer Science',
    'DRMA': 'Communication',
    'DSGN': 'Technology',
    'ECON': 'Business',
    'EDAD': 'Education & Psychology',
    'EDCI': 'Education & Psychology',
    'EDFB': 'Education & Psychology',
    'EDUC': 'Education & Psychology',
    'ENGL': 'English & Modern Languages',
    'ENGR': 'Engineering',
    'ENVI': 'Engineering',
    'FINA': 'Business',
    'FLTV': 'Communication',
    'FREN': 'English & Modern Languages',
    'GBUS': 'Business',
    'GDEV': 'Computer Science',
    'GEOG': 'History and Philosophy',
    'GNRL': 'Non-Departmental',
    'GREK': 'Theology',
    'GRPH': 'Technology',
    'HIST': 'History and Philosophy',
    'HLTH': 'Health and Physical Education',
    'HMNT': 'History and Philosophy',
    'HONR': 'Honors',
    'ITLN': 'Modern Language',
    'JOUR': 'Communication',
    'LANG': 'English & Modern Languages',
    'LAW': 'History and Philosophy',
    'MATH': 'Mathematics',
    'MDEV': 'Mathematics',
    'MDLG': 'Modern Language',
    'MEDU': 'Mathematics',
    'MGMT': 'Business',
    'MKTG': 'Business',
    'MUCT': 'Music',
    'MUED': 'Music',
    'MUHL': 'Music',
    'MUPF': 'Music',
    'NRSG': 'Nursing',
    'PEAC': 'Health and Physical Education',
    'PETH': 'Health and Physical Education',
    'PHIL': 'History and Philosophy',
    'PHTO': 'Technology',
    'PHYS': 'Physics',
    'PLSC': 'History and Philosophy',
    'PRDN': 'Technology',
    'PREL': 'Communication',
    'PSYC': 'Education & Psychology',
    'RELB': 'Theology',
    'RELH': 'Theology',
    'RELM': 'Theology',
    'RELP': 'Theology',
    'RELT': 'Theology',
    'SCDI': 'Biology',
    'SERV': 'Non-Departmental',
    'SMTF': 'Non-Departmental',
    'SOCI': 'Social Work & Sociology',
    'SOWK': 'Social Work & Sociology',
    'SPAN': 'Modern Language',
    'SPCH': 'Communication',
    'SPED': 'Education & Psychology',
    'SPPA': 'Communication',
    'TECH': 'Technology',
    'VISA': 'Visual Arts',
    'WRIT': 'English & Modern Languages',
  };
}
