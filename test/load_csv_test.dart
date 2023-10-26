import 'package:flutter_test/flutter_test.dart';

import 'package:schedule/load_csv.dart';

void main() {
  test('constructor and accessors', () {
    var wholeList = getListFromCsv();
    // Assert the list headers are accurate
    assert(wholeList[0].toString() ==
        '[CRSE_OFFER_NBR, CAMPUS, ACAD_YEAR, ACAD_ORG, '
            'WWU_ACAD_ORG_DESCR, CLASS_NBR, WWU_GS, SUBJECT, WWU_SUM1, WWU_AUT, '
            'WWU_WTR, WWU_SPR, WWU_SUM2, CLASS_SECTION, DESCR, WWU_UNITS, ENRL_STAT, ENRL_TOT, '
            'ENRL_CAP, WAIT_TOT, FEE_AMT, WWU_MTG_PAT_COMB, WWU_ROOM, WWU_INSTR_NAME, DESCRLONG, '
            'INSTRUCTION_MODE, SCHEDULE_PRINT, VIDEO_LINK, CONSENT, CONSENT_DESCR]');
  });
}
