class GeneralRequirements {
  // --- Tracks --- //

  static const regular = [
    GeneralSection(
      name: 'Foundational Skills',
      requirements: [
        GeneralCategory(
          category: 'Written Comm & Information Literacy',
          credits: 9,
          options: [
            CourseOption(
              course: 'ENGL 121',
              title: 'Intro to Writing',
              credits: 3,
            ),
            CourseOption(
              course: 'ENGL 122',
              title: 'Intro to Research',
              credits: 3,
            ),
            CourseOption(
              course: 'ENGL 223',
              title: 'Research Writing',
              credits: 3,
            ),
          ],
        ),
        GeneralCategory(
          category: 'Oral Communication',
          credits: 4,
          options: [
            CourseOption(course: 'SPCH 101', title: 'Speech Comm', credits: 4),
            CourseOption(
              course: 'SPCH 207',
              title: 'Small Group Comm',
              credits: 4,
            ),
          ],
        ),
        GeneralCategory(
          category: 'Foundations of Faith',
          credits: 4,
          options: _foundationsOfFaith,
        ),
        GeneralCategory(
          category: 'Physical Education',
          credits: 2,
          options: [
            CourseOption(course: 'PEAC 113', credits: 1),
            CourseOption(course: 'PEAC 114', credits: 1),
            CourseOption(course: 'PEAC 115', credits: 1),
            CourseOption(course: 'PEAC 116', credits: 1),
            CourseOption(course: 'PEAC 117', credits: 1),
            CourseOption(course: 'PEAC 118', credits: 1),
            CourseOption(course: 'PEAC 119', credits: 1),
            CourseOption(course: 'PEAC 120', credits: 1),
            CourseOption(course: 'PEAC 121', credits: 1),
            CourseOption(course: 'PEAC 122', credits: 1),
            CourseOption(course: 'PEAC 123', credits: 1),
            CourseOption(course: 'PEAC 124', credits: 1),
            CourseOption(course: 'PEAC 125', credits: 1),
            CourseOption(course: 'PEAC 126', credits: 1),
            CourseOption(course: 'PEAC 127', credits: 1),
            CourseOption(course: 'PEAC 128', credits: 1),
            CourseOption(course: 'PEAC 129', credits: 1),
            CourseOption(course: 'PEAC 130', credits: 1),
            CourseOption(course: 'PEAC 131', credits: 1),
            CourseOption(course: 'PEAC 132', credits: 1),
            CourseOption(course: 'PEAC 133', credits: 1),
            CourseOption(course: 'PEAC 134', credits: 1),
            CourseOption(course: 'PEAC 135', credits: 1),
            CourseOption(course: 'PEAC 136', credits: 1),
            CourseOption(course: 'PEAC 137', credits: 1),
            CourseOption(course: 'PEAC 138', credits: 1),
            CourseOption(course: 'PEAC 139', credits: 1),
            CourseOption(course: 'PEAC 140', credits: 1),
            CourseOption(course: 'PEAC 141', credits: 1),
            CourseOption(course: 'PEAC 142', credits: 1),
            CourseOption(course: 'PEAC 143', credits: 1),
            CourseOption(course: 'PEAC 144', credits: 1),
            CourseOption(course: 'PEAC 145', credits: 1),
            CourseOption(course: 'PEAC 146', credits: 1),
            CourseOption(course: 'PEAC 147', credits: 1),
            CourseOption(course: 'PEAC 148', credits: 1),
            CourseOption(course: 'PEAC 149', credits: 1),
            CourseOption(course: 'PEAC 150', credits: 1),
            CourseOption(course: 'PEAC 151', credits: 1),
            CourseOption(course: 'PEAC 152', credits: 1),
            CourseOption(course: 'PEAC 153', credits: 1),
            CourseOption(course: 'PEAC 154', credits: 1),
            CourseOption(course: 'PEAC 155', credits: 1),
            CourseOption(course: 'PEAC 156', credits: 1),
            CourseOption(course: 'PEAC 157', credits: 1),
            CourseOption(course: 'PEAC 158', credits: 1),
            CourseOption(course: 'PEAC 159', credits: 1),
            CourseOption(course: 'PEAC 160', credits: 1),
            CourseOption(course: 'PEAC 161', credits: 1),
            CourseOption(course: 'PEAC 162', credits: 1),
            CourseOption(course: 'PEAC 163', credits: 1),
            CourseOption(course: 'PEAC 164', credits: 1),
            CourseOption(course: 'PEAC 165', credits: 1),
            CourseOption(course: 'PEAC 166', credits: 1),
            CourseOption(course: 'PEAC 167', credits: 1),
            CourseOption(course: 'PEAC 168', credits: 1),
            CourseOption(course: 'PEAC 169', credits: 1),
            CourseOption(course: 'PEAC 170', credits: 1),
            CourseOption(course: 'PEAC 171', credits: 1),
            CourseOption(course: 'PEAC 172', credits: 1),
            CourseOption(course: 'PEAC 173', credits: 1),
            CourseOption(course: 'PEAC 174', credits: 1),
            CourseOption(course: 'PEAC 175', credits: 1),
            CourseOption(course: 'PEAC 176', credits: 1),
            CourseOption(course: 'PEAC 177', credits: 1),
            CourseOption(course: 'PEAC 178', credits: 1),
            CourseOption(course: 'PEAC 179', credits: 1),
            CourseOption(course: 'PEAC 180', credits: 1),
            CourseOption(course: 'PEAC 181', credits: 1),
            CourseOption(course: 'PEAC 182', credits: 1),
            CourseOption(course: 'PEAC 183', credits: 1),
            CourseOption(course: 'PEAC 184', credits: 1),
            CourseOption(course: 'PEAC 185', credits: 1),
            CourseOption(course: 'PEAC 186', credits: 1),
            CourseOption(course: 'PEAC 187', credits: 1),
            CourseOption(course: 'PEAC 188', credits: 1),
            CourseOption(course: 'PEAC 189', credits: 1),
            CourseOption(course: 'PEAC 190', credits: 1),
            CourseOption(course: 'PEAC 191', credits: 1),
            CourseOption(course: 'PEAC 192', credits: 1),
            CourseOption(course: 'PEAC 193', credits: 1),
            CourseOption(course: 'PEAC 194', credits: 1),
            CourseOption(course: 'PEAC 195', credits: 1),
            CourseOption(course: 'PEAC 196', credits: 1),
            CourseOption(course: 'PEAC 197', credits: 1),
            CourseOption(course: 'PEAC 198', credits: 1),
          ],
        ),
        GeneralCategory(
          category: 'Quantitative Reasoning',
          credits: 4,
          options: [
            CourseOption(
              course: 'MATH 105',
              title: 'Math for Liberal Arts',
              credits: 4,
            ),
            CourseOption(
              course: 'MATH 106',
              title: 'Intro to Stats',
              credits: 4,
            ),
            CourseOption(
              course: 'MATH 214',
              title: 'Math for Elementary Teachers',
              credits: 4,
            ),
            CourseOption(course: 'MATH 121', title: 'Precalculus', credits: 4),
            CourseOption(course: 'MATH 171', title: 'Calculus I', credits: 4),
          ],
        ),
      ],
    ),
    GeneralSection(
      name: 'Ways of Knowing',
      requirements: [
        GeneralCategory(
          category: 'Humanities',
          credits: 1,
          options: _waysOfKnowingHumanities,
        ),
        GeneralCategory(
          category: 'History',
          credits: 1,
          options: _waysOfKnowingHistory,
        ),
        GeneralCategory(
          category: 'Social Science',
          credits: 1,
          options: _waysOfKnowingSocialScience,
        ),
        GeneralCategory(
          category: 'Natural Science',
          credits: 4,
          options: [
            CourseOption(
              course: 'BIOL 105',
              title: 'Contemporary Bio',
              credits: 4,
            ),
            CourseOption(
              course: 'BIOL 106',
              title: 'Contemporary Bio',
              credits: 4,
            ),
            CourseOption(
              course: 'BIOL 121',
              title: 'Anatomy & Physiology',
              credits: 4,
            ),
            CourseOption(
              course: 'BIOL 141',
              title: 'General Biology',
              credits: 4,
            ),
            CourseOption(
              course: 'CHEM 105',
              title: 'Survey of Chemistry',
              credits: 5,
            ),
            CourseOption(
              course: 'CHEM 141',
              title: 'General Chemistry',
              credits: 3,
            ),
            CourseOption(
              course: 'CHEM 144',
              title: 'General Chemistry Lab',
              credits: 1,
            ),
            CourseOption(
              course: 'PHYS 201',
              title: 'Conceptual Physics',
              credits: 3,
            ),
            CourseOption(
              course: 'PHYS 204',
              title: 'Conceptual Physics Lab',
              credits: 1,
            ),
            CourseOption(
              course: 'PHYS 211',
              title: 'General Physics',
              credits: 3,
            ),
            CourseOption(
              course: 'PHYS 214',
              title: 'General Physics Lab',
              credits: 1,
            ),
            CourseOption(
              course: 'PHYS 251',
              title: 'Principles of Physics',
              credits: 3,
            ),
            CourseOption(
              course: 'PHYS 254',
              title: 'Principles of Physics Lab',
              credits: 1,
            ),
          ],
        ),
        GeneralCategory(
          category: 'Exploring Scripture',
          credits: 1,
          options: _waysOfKnowingExploringScripture,
        ),
        GeneralCategory(
          category: 'Exploring SDA Life and Thought',
          credits: 1,
          options: _waysOfKnowingExploringSDA,
        ),
      ],
    ),
    GeneralSection(
      name: 'Ways of Engaging',
      requirements: [
        GeneralCategory(
          category: 'Engaging the Arts',
          credits: 1,
          options: _engagingTheArts,
        ),
        GeneralCategory(
          category: 'Engaging History & Philosophy',
          credits: 1,
          options: _engagingHistoryPhilosophy,
        ),
        GeneralCategory(
          category: 'Engaging Faith',
          credits: 6,
          options: _engagingFaith,
        ),
        GeneralCategory(
          category: 'Engaging Science & Data',
          credits: 4,
          options: [
            CourseOption(
              course: 'BIOL 105',
              title: 'Contemporary Biology',
              credits: 4,
            ),
            CourseOption(
              course: 'BIOL 106',
              title: 'Contemporary Biology',
              credits: 4,
            ),
            CourseOption(
              course: 'BIOL 122',
              title: 'Anatomy & Physiology',
              credits: 4,
            ),
            CourseOption(course: 'BIOL 142', title: 'Gen Biology', credits: 4),
            CourseOption(
              course: 'CHEM 142',
              title: 'General Chemistry',
              credits: 3,
            ),
            CourseOption(
              course: 'CHEM 145',
              title: 'General Chemistry Lab',
              credits: 1,
            ),
            CourseOption(
              course: 'CPTR 230',
              title: 'Computing for Insight',
              credits: 4,
            ),
            CourseOption(
              course: 'ENVI 385',
              title: 'Environmental Stewardship',
              credits: 4,
            ),
            CourseOption(
              course: 'MATH 215',
              title: 'Data Analysis',
              credits: 4,
            ),
            CourseOption(
              course: 'PHIL 407',
              title: 'Philosophy of Science',
              credits: 4,
            ),
            CourseOption(
              course: 'PHYS 201',
              title: 'Conceptual Physics',
              credits: 3,
            ),
            CourseOption(
              course: 'PHYS 202',
              title: 'Conceptual Physics',
              credits: 3,
            ),
            CourseOption(
              course: 'PHYS 204',
              title: 'Conceptual Physics Lab',
              credits: 1,
            ),
            CourseOption(
              course: 'PHYS 205',
              title: 'Conceptual Physics Lab',
              credits: 1,
            ),
            CourseOption(course: 'PHYS 212', title: 'Gen Physics', credits: 3),
            CourseOption(
              course: 'PHYS 215',
              title: 'Gen Physics Lab',
              credits: 1,
            ),
            CourseOption(
              course: 'PHYS 252',
              title: 'Prin of Physics',
              credits: 3,
            ),
            CourseOption(
              course: 'PHYS 255',
              title: 'Prin of Physics Lab',
              credits: 1,
            ),
          ],
        ),
        GeneralCategory(
          category: 'Engaging Society',
          credits: 1,
          options: _engagingSociety,
        ),
      ],
    ),
  ];

  static const engineering = [
    GeneralSection(
      name: 'Foundational Skills',
      requirements: [
        GeneralCategory(
          category: 'Written Comm & Information Literacy',
          credits: 9,
          options: [
            CourseOption(
              course: 'ENGL 121',
              title: 'Intro to Writing',
              credits: 3,
            ),
            CourseOption(
              course: 'ENGL 122',
              title: 'Intro to Research',
              credits: 3,
            ),
            CourseOption(
              course: 'ENGL 223',
              title: 'Research Writing',
              credits: 3,
            ),
          ],
        ),
        GeneralCategory(
          category: 'Oral Communication',
          credits: 4,
          options: [
            CourseOption(course: 'SPCH 101', title: 'Speech Comm', credits: 4),
            CourseOption(
              course: 'SPCH 207',
              title: 'Small Group Comm',
              credits: 4,
            ),
          ],
        ),
        GeneralCategory(
          category: 'Physical Education',
          credits: 2,
          options: [
            CourseOption(course: 'PEAC 113', credits: 1),
            CourseOption(course: 'PEAC 114', credits: 1),
            CourseOption(course: 'PEAC 115', credits: 1),
            CourseOption(course: 'PEAC 116', credits: 1),
            CourseOption(course: 'PEAC 117', credits: 1),
            CourseOption(course: 'PEAC 118', credits: 1),
            CourseOption(course: 'PEAC 119', credits: 1),
            CourseOption(course: 'PEAC 120', credits: 1),
            CourseOption(course: 'PEAC 121', credits: 1),
            CourseOption(course: 'PEAC 122', credits: 1),
            CourseOption(course: 'PEAC 123', credits: 1),
            CourseOption(course: 'PEAC 124', credits: 1),
            CourseOption(course: 'PEAC 125', credits: 1),
            CourseOption(course: 'PEAC 126', credits: 1),
            CourseOption(course: 'PEAC 127', credits: 1),
            CourseOption(course: 'PEAC 128', credits: 1),
            CourseOption(course: 'PEAC 129', credits: 1),
            CourseOption(course: 'PEAC 130', credits: 1),
            CourseOption(course: 'PEAC 131', credits: 1),
            CourseOption(course: 'PEAC 132', credits: 1),
            CourseOption(course: 'PEAC 133', credits: 1),
            CourseOption(course: 'PEAC 134', credits: 1),
            CourseOption(course: 'PEAC 135', credits: 1),
            CourseOption(course: 'PEAC 136', credits: 1),
            CourseOption(course: 'PEAC 137', credits: 1),
            CourseOption(course: 'PEAC 138', credits: 1),
            CourseOption(course: 'PEAC 139', credits: 1),
            CourseOption(course: 'PEAC 140', credits: 1),
            CourseOption(course: 'PEAC 141', credits: 1),
            CourseOption(course: 'PEAC 142', credits: 1),
            CourseOption(course: 'PEAC 143', credits: 1),
            CourseOption(course: 'PEAC 144', credits: 1),
            CourseOption(course: 'PEAC 145', credits: 1),
            CourseOption(course: 'PEAC 146', credits: 1),
            CourseOption(course: 'PEAC 147', credits: 1),
            CourseOption(course: 'PEAC 148', credits: 1),
            CourseOption(course: 'PEAC 149', credits: 1),
            CourseOption(course: 'PEAC 150', credits: 1),
            CourseOption(course: 'PEAC 151', credits: 1),
            CourseOption(course: 'PEAC 152', credits: 1),
            CourseOption(course: 'PEAC 153', credits: 1),
            CourseOption(course: 'PEAC 154', credits: 1),
            CourseOption(course: 'PEAC 155', credits: 1),
            CourseOption(course: 'PEAC 156', credits: 1),
            CourseOption(course: 'PEAC 157', credits: 1),
            CourseOption(course: 'PEAC 158', credits: 1),
            CourseOption(course: 'PEAC 159', credits: 1),
            CourseOption(course: 'PEAC 160', credits: 1),
            CourseOption(course: 'PEAC 161', credits: 1),
            CourseOption(course: 'PEAC 162', credits: 1),
            CourseOption(course: 'PEAC 163', credits: 1),
            CourseOption(course: 'PEAC 164', credits: 1),
            CourseOption(course: 'PEAC 165', credits: 1),
            CourseOption(course: 'PEAC 166', credits: 1),
            CourseOption(course: 'PEAC 167', credits: 1),
            CourseOption(course: 'PEAC 168', credits: 1),
            CourseOption(course: 'PEAC 169', credits: 1),
            CourseOption(course: 'PEAC 170', credits: 1),
            CourseOption(course: 'PEAC 171', credits: 1),
            CourseOption(course: 'PEAC 172', credits: 1),
            CourseOption(course: 'PEAC 173', credits: 1),
            CourseOption(course: 'PEAC 174', credits: 1),
            CourseOption(course: 'PEAC 175', credits: 1),
            CourseOption(course: 'PEAC 176', credits: 1),
            CourseOption(course: 'PEAC 177', credits: 1),
            CourseOption(course: 'PEAC 178', credits: 1),
            CourseOption(course: 'PEAC 179', credits: 1),
            CourseOption(course: 'PEAC 180', credits: 1),
            CourseOption(course: 'PEAC 181', credits: 1),
            CourseOption(course: 'PEAC 182', credits: 1),
            CourseOption(course: 'PEAC 183', credits: 1),
            CourseOption(course: 'PEAC 184', credits: 1),
            CourseOption(course: 'PEAC 185', credits: 1),
            CourseOption(course: 'PEAC 186', credits: 1),
            CourseOption(course: 'PEAC 187', credits: 1),
            CourseOption(course: 'PEAC 188', credits: 1),
            CourseOption(course: 'PEAC 189', credits: 1),
            CourseOption(course: 'PEAC 190', credits: 1),
            CourseOption(course: 'PEAC 191', credits: 1),
            CourseOption(course: 'PEAC 192', credits: 1),
            CourseOption(course: 'PEAC 193', credits: 1),
            CourseOption(course: 'PEAC 194', credits: 1),
            CourseOption(course: 'PEAC 195', credits: 1),
            CourseOption(course: 'PEAC 196', credits: 1),
            CourseOption(course: 'PEAC 197', credits: 1),
            CourseOption(course: 'PEAC 198', credits: 1),
          ],
        ),
      ],
    ),
    GeneralSection(
      name: 'Ethics and Belief Studies',
      requirements: [
        GeneralCategory(
          category: 'Foundations of Faith',
          credits: 4,
          options: [
            ..._foundationsOfFaith,
            CourseOption(
              course: 'RELB 105',
              credits: 2,
              title: 'Sermon on the Mount',
            ),
            CourseOption(
              course: 'RELB 106',
              credits: 2,
              title: 'Parables of Jesus',
            ),
          ],
        ),

        GeneralCategory(
          category: 'Religion (6 must be upper-division)',
          credits: 16,
          options: [
            ..._waysOfKnowingExploringScripture,
            ..._waysOfKnowingExploringSDA,
            ..._engagingFaith,
          ],
        ),
      ],
    ),
    GeneralSection(
      name: 'Ways of Knowing and Engaging',
      requirements: [
        GeneralCategory(
          category: 'Engaging the Arts',
          credits: 1,
          options: [..._waysOfKnowingHumanities, ..._engagingTheArts],
        ),
        GeneralCategory(
          category: 'Engaging History & Philosophy',
          credits: 1,
          options: [..._waysOfKnowingHistory, ..._engagingHistoryPhilosophy],
        ),
        GeneralCategory(
          category: 'Engaging Society',
          credits: 1,
          options: [
            ..._waysOfKnowingSocialScience,
            ..._engagingSociety,
            CourseOption(
              course: 'ENVI 385',
              title: 'Environmental Stewardship',
              credits: 4,
            ),
            CourseOption(
              course: 'MGMT 371',
              title: 'Principles of Management',
              credits: 4,
            ),
          ],
        ),
      ],
    ),
  ];

  // --- Track lookup --- //

  static const tracks = <String, List<GeneralSection>>{
    'Regular': regular,
    'Engineering': engineering,
  };

  static List<GeneralSection> getTrack(String name) {
    return tracks[name] ?? regular;
  }

  // --- Shared categories --- //

  static const _foundationsOfFaith = [
    CourseOption(course: 'RELB 104', title: 'Ministry of Jesus', credits: 4),
    CourseOption(course: 'RELB 111', title: 'Messages of the OT', credits: 4),
    CourseOption(course: 'RELB 231', title: 'Exploring the NT', credits: 4),
  ];

  static const _waysOfKnowingHumanities = [
    CourseOption(course: 'ART 251', title: 'Intro to Art', credits: 4),
    CourseOption(course: 'ENGL 204', title: 'Intro to Lit', credits: 4),
    CourseOption(course: 'ENGL 210', title: 'Lit Survey', credits: 4),
    CourseOption(course: 'ENGL 211', title: 'Lit Survey', credits: 4),
    CourseOption(course: 'ENGL 212', title: 'Lit Survey', credits: 4),
    CourseOption(course: 'ENGL 274', title: 'England Study Tour', credits: 4),
    CourseOption(course: 'FILM 215', title: 'Intro to Film Lit', credits: 4),
    CourseOption(course: 'MUHL 124', title: 'Intro to Music', credits: 4),
    CourseOption(course: 'PHIL 204', title: 'Critical Reasoning', credits: 4),
  ];

  static const _waysOfKnowingHistory = [
    CourseOption(course: 'HIST 121', title: 'West & the World', credits: 4),
    CourseOption(course: 'HIST 122', title: 'West & the World', credits: 4),
    CourseOption(course: 'HIST 221', title: 'History of the US', credits: 4),
    CourseOption(course: 'HIST 222', title: 'History of the US', credits: 4),
    CourseOption(
      course: 'HIST 240',
      title: 'Middle Eastern History',
      credits: 4,
    ),
    CourseOption(course: 'HIST 274', title: 'England Study Tour', credits: 4),
    CourseOption(course: 'HIST 275', title: 'History of England', credits: 4),
    CourseOption(course: 'HIST 283', title: 'Latin America', credits: 4),
  ];

  static const _waysOfKnowingSocialScience = [
    CourseOption(
      course: 'ANTH 225',
      title: 'Cultural Anthropology',
      credits: 4,
    ),
    CourseOption(course: 'PSYC 130', title: 'General Psychology', credits: 4),
    CourseOption(course: 'PSYC 140', title: 'Social Foundations', credits: 4),
    CourseOption(
      course: 'PSYC 141',
      title: 'Biological Foundations',
      credits: 4,
    ),
    CourseOption(course: 'PSYC 217', title: 'Psych of Learning', credits: 4),
    CourseOption(course: 'SOCI 204', title: 'General Sociology', credits: 4),
  ];

  static const _waysOfKnowingExploringScripture = [
    CourseOption(course: 'RELB 302', title: 'Pentateuch', credits: 4),
    CourseOption(course: 'RELB 303', title: 'OT Psalms, Stories…', credits: 4),
    CourseOption(course: 'RELB 304', title: 'Hebrew Prophets', credits: 4),
    CourseOption(course: 'RELB 312', title: 'Daniel & Jeremiah', credits: 4),
    CourseOption(course: 'RELB 313', title: 'Revelation', credits: 4),
    CourseOption(course: 'RELB 337', title: 'Jesus & the Gospels', credits: 4),
    CourseOption(course: 'RELB 340', title: 'Acts and NT Letters', credits: 4),
    CourseOption(course: 'RELB 362', title: 'Paul and the Gospel', credits: 4),
    CourseOption(
      course: 'RELB 408',
      title: 'The Bible and the Human Condition',
      credits: 4,
    ),
  ];

  static const _waysOfKnowingExploringSDA = [
    CourseOption(course: 'RELT 110', title: 'Intro to SDA Belief', credits: 4),
    CourseOption(course: 'RELT 202', title: 'Christian Beliefs', credits: 4),
    CourseOption(
      course: 'RELT 417',
      title: 'Prophetic Inspiration',
      credits: 3,
    ),
    CourseOption(course: 'RELH 457', title: 'History of Adventism', credits: 3),
  ];

  static const _engagingTheArts = [
    CourseOption(course: 'ART 324', title: 'Hist of Art', credits: 3),
    CourseOption(course: 'ART 325', title: 'Hist of Art', credits: 3),
    CourseOption(course: 'ART 326', title: 'Hist of Art', credits: 3),
    CourseOption(course: 'DRMA 101', title: 'Intro to Theatre', credits: 3),
    CourseOption(course: 'DRMA 363', title: 'Hist of Theatre', credits: 4),
    CourseOption(course: 'ENGL 363', title: 'Hist of Theatre', credits: 4),
    CourseOption(course: 'ENGL 214', title: 'Themes in Lit', credits: 4),
    CourseOption(course: 'ENGL 358', title: 'Classical Lit', credits: 4),
    CourseOption(course: 'ENGL 359', title: 'World Lit', credits: 4),
    CourseOption(course: 'ENGL 360', title: 'Shakespeare Festival', credits: 2),
    CourseOption(course: 'ENGL 374', title: 'Elementary Ed Only', credits: 4),
    CourseOption(course: 'ENGL 474', title: 'England Study Tour', credits: 4),
    CourseOption(course: 'MUHL 310', title: 'Great Composers', credits: 3),
    CourseOption(course: 'WRIT 324', title: 'Creative Non-Fiction', credits: 4),
    CourseOption(course: 'WRIT 334', title: 'Poetry Writing', credits: 4),
    CourseOption(
      course: 'WRIT 344',
      title: 'Short Fiction Writing',
      credits: 4,
    ),
  ];

  static const _engagingHistoryPhilosophy = [
    CourseOption(course: 'HIST 242', title: 'Modern East Asia', credits: 4),
    CourseOption(
      course: 'HIST 254',
      title: 'History of Christianity',
      credits: 4,
    ),
    CourseOption(
      course: 'HIST 257',
      title: 'Voices in African History',
      credits: 4,
    ),
    CourseOption(course: 'HIST 267', title: 'The Black Experience', credits: 4),
    CourseOption(
      course: 'HIST 305',
      title: 'Ancient Near East Emps',
      credits: 4,
    ),
    CourseOption(
      course: 'HIST 306',
      title: 'Classical Greece & Rome',
      credits: 4,
    ),
    CourseOption(course: 'HIST 307', title: 'Reform & Revolt', credits: 4),
    CourseOption(course: 'HIST 320', title: 'Archaeology & Empire', credits: 4),
    CourseOption(
      course: 'HIST 354',
      title: 'Am. Hist & Visual Culture',
      credits: 4,
    ),
    CourseOption(course: 'HIST 355', title: 'The Atlantic World', credits: 4),
    CourseOption(course: 'HIST 359', title: 'The American Economy', credits: 4),
    CourseOption(
      course: 'HIST 386',
      title: 'Education Majors Only',
      credits: 4,
    ),
    CourseOption(course: 'HIST 434', title: 'Women/Ancient World', credits: 4),
    CourseOption(
      course: 'HIST 437',
      title: 'Medieval & Ren Europe',
      credits: 4,
    ),
    CourseOption(course: 'HIST 448', title: 'Becoming America', credits: 4),
    CourseOption(course: 'HIST 450', title: 'U.S. Foreign Policy', credits: 4),
    CourseOption(course: 'HIST 463', title: 'Women & Society', credits: 4),
    CourseOption(course: 'HIST 474', title: 'England Study Tour', credits: 4),
    CourseOption(course: 'PHIL 305', title: 'Moral Philosophy', credits: 4),
  ];

  static const _engagingFaith = [
    CourseOption(course: 'RELB 105', title: 'Sermon on the Mount', credits: 2),
    CourseOption(course: 'RELB 106', title: 'Parables of Jesus', credits: 2),
    CourseOption(
      course: 'RELB 274',
      title: 'Holy Lands Study Tour',
      credits: 4,
    ),
    CourseOption(
      course: 'RELB 474',
      title: 'Holy Lands Study Tour',
      credits: 4,
    ),
    CourseOption(course: 'RELB 306', title: 'Bible & its Transl.', credits: 2),
    CourseOption(course: 'RELB 307', title: 'Creation & the Bible', credits: 2),
    CourseOption(
      course: 'RELB 333',
      title: 'Biblical Per./Healing',
      credits: 4,
    ),
    CourseOption(course: 'RELB 339', title: 'Luke-Acts', credits: 4),
    CourseOption(course: 'RELB 345', title: 'Biblical Narratives', credits: 4),
    CourseOption(course: 'RELB 382P', title: 'NT Biographies', credits: 3),
    CourseOption(course: 'RELB 410', title: 'Women in the Bible', credits: 2),
    CourseOption(
      course: 'RELB 421P',
      title: 'Interpreting the Bible',
      credits: 4,
    ),
    CourseOption(
      course: 'RELB 464',
      title: 'Living Faith: Gen. Epistles',
      credits: 2,
    ),
    CourseOption(
      course: 'RELB 465',
      title: 'Living Faith: Prison Epistles',
      credits: 2,
    ),
    CourseOption(course: 'RELH 205', title: 'Biblical Archaeology', credits: 4),
    CourseOption(course: 'RELH 303', title: 'World Religions', credits: 4),
    CourseOption(
      course: 'RELH 425',
      title: 'Psychology of Religion',
      credits: 3,
    ),
    CourseOption(
      course: 'RELM 233',
      title: 'Cross-Cultural Ministry',
      credits: 3,
    ),
    CourseOption(
      course: 'RELT 326',
      title: 'Spirituality & Discipleship',
      credits: 4,
    ),
    CourseOption(course: 'RELT 340', title: 'Portland Campus Only', credits: 3),
    CourseOption(
      course: 'RELT 342',
      title: 'Issues of God and Faith',
      credits: 2,
    ),
    CourseOption(course: 'RELT 348', title: 'Christian Ethics', credits: 4),
    CourseOption(course: 'RELT 402', title: 'Human Forgiveness', credits: 2),
    CourseOption(
      course: 'RELT 412',
      title: 'Philosophy of Religion',
      credits: 4,
    ),
  ];

  static const _engagingSociety = [
    CourseOption(course: 'COMM 145', title: 'Media & Culture', credits: 4),
    CourseOption(
      course: 'CPTR 308',
      title: 'Ethical Issues for Comp.',
      credits: 4,
    ),
    CourseOption(
      course: 'ECON 210',
      title: 'Prin of Microeconomics',
      credits: 4,
    ),
    CourseOption(
      course: 'ECON 211',
      title: 'Prin of Macroeconomics',
      credits: 4,
    ),
    CourseOption(course: 'ECON 220', title: 'Prin of Global Dev', credits: 4),
    CourseOption(course: 'ECON 359', title: 'The American Economy', credits: 4),
    CourseOption(
      course: 'EDUC 444',
      title: 'Education Majors Only',
      credits: 4,
    ),
    CourseOption(course: 'FINA 101', title: 'Personal Finance', credits: 4),
    CourseOption(course: 'FINA 325', title: 'Investments', credits: 4),
    CourseOption(
      course: 'GBUS 270',
      title: 'Business Communication',
      credits: 4,
    ),
    CourseOption(course: 'GBUS 361', title: 'Business Law I', credits: 4),
    CourseOption(course: 'HLTH 110', title: 'Wellness for Living', credits: 3),
    CourseOption(course: 'HLTH 220', title: 'Human Nutrition', credits: 4),
    CourseOption(course: 'LANG 406', title: 'Language and Culture', credits: 3),
    CourseOption(course: 'MGMT 463', title: 'Business Ethics', credits: 4),
    CourseOption(
      course: 'PHIL 440',
      title: 'Social/Political Philosophy',
      credits: 4,
    ),
    CourseOption(course: 'PLSC 224', title: 'American Government', credits: 4),
    CourseOption(course: 'PSYC 344', title: 'Social Psychology', credits: 4),
    CourseOption(
      course: 'SOCI 225',
      title: 'Marriage & Family Life',
      credits: 2,
    ),
    CourseOption(
      course: 'SOCI 234',
      title: 'Current Social Problems',
      credits: 4,
    ),
    CourseOption(
      course: 'SOCI 236',
      title: 'Privilege & Oppression',
      credits: 4,
    ),
    CourseOption(
      course: 'SOCI 420',
      title: 'Immigration & Identity',
      credits: 4,
    ),
    CourseOption(course: 'SOWK 260', title: 'Human Behavior', credits: 4),
    CourseOption(course: 'SOWK 261', title: 'Human Behavior', credits: 4),
    CourseOption(course: 'SPCH 341', title: 'Argumentation', credits: 4),
    CourseOption(course: 'SPCH 443', title: 'Persuasion', credits: 4),
    CourseOption(course: 'TECH 321', title: 'Technology & Society', credits: 4),
    CourseOption(course: 'SPAN 101', title: 'Elementary Spanish', credits: 4),
    CourseOption(course: 'FREN 101', title: 'Elementary French', credits: 4),
  ];
}

class GeneralSection {
  const GeneralSection({required this.name, required this.requirements});

  final String name;
  final List<GeneralCategory> requirements;
}

class GeneralCategory {
  const GeneralCategory({
    required this.category,
    required this.credits,
    required this.options,
  });

  final String category;
  final int credits;
  final List<CourseOption> options;
}

class CourseOption {
  const CourseOption({required this.course, required this.credits, this.title});

  final String course;
  final int credits;
  final String? title;
}
