import 'package:common/course.dart';
import 'package:common/requirement_items.dart';

/// Defines a student's graduation requirements, which includes any majors and minors.
class GraduationRequirements {
  GraduationRequirements({
    required this.majorRequirements,
    this.minorRequirements,
  });

  List<Major> majorRequirements;
  List<Minor>? minorRequirements;

  List<Course> get allRequiredCourses {
    final courses = <Course>{};
    for (final major in majorRequirements) {
      courses.addAll(major.requiredCourses);
    }
    if (minorRequirements != null) {
      for (final minor in minorRequirements!) {
        courses.addAll(minor.requiredCourses);
      }
    }
    return courses.toList();
  }
}

/// Represents a major and its associated graduation requirements
class Major {
  Major({
    required this.name,
    required this.bulletinYear,
    required this.requiredCourses,
  });

  String name;
  String bulletinYear;
  List<Course> requiredCourses;
}

/// Represents a minor and its associated graduation requirements
class Minor {
  Minor({
    required this.name,
    required this.bulletinYear,
    required this.requiredCourses,
  });

  String name;
  String bulletinYear;
  List<Course> requiredCourses;
}

/// Represents a general studies track and its associated graduation requirements
class GeneralStudiesTrack {
  GeneralStudiesTrack({
    required this.name,
    required this.bulletinYear,
    required this.requiredCourses,
  });

  String name;
  String bulletinYear;
  List<RequirementItem> requiredCourses;
}

final computerScienceBS_2023_2024 = Major(
  name: 'Computer Science Major (Bachelor of Science)',
  bulletinYear: '2023-2024',
  requiredCourses: [
    Course(
      course: 'CPTR 108',
      courseTitle: 'The Art and Practice of Computer Science',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      course: 'CPTR 141',
      courseTitle: 'Fundamentals of Programming I',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 142',
      courseTitle: 'Fundamentals of Programming II',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 242',
      courseTitle: 'Sequential and Parallel Data Structures and Algorithms',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 245',
      courseTitle: 'Software Development',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 280',
      courseTitle: 'Computer Organization and Assembly Language',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      course: 'CPTR 308',
      courseTitle: 'Social, Legal, and Ethical Issues for Computing Technology',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 352',
      courseTitle: 'Operating Systems',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 354',
      courseTitle: 'Compilers and Languages',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 396',
      courseTitle: 'Internship and Career Readiness Seminar',
      creditsMin: 1.0,
      creditsMax: 1.0,
    ),
    Course(
      course: 'CPTR 450',
      courseTitle: 'Software Engineering',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      course: 'CPTR 454',
      courseTitle: 'Design and Analysis of Algorithms',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'CPTR 496',
      courseTitle: 'Senior Project I',
      creditsMin: 1.0,
      creditsMax: 1.0,
    ),
    Course(
      course: 'CPTR 497',
      courseTitle: 'Senior Project II',
      creditsMin: 2.0,
      creditsMax: 2.0,
    ),
    Course(
      course: 'CPTR 498',
      courseTitle: 'Senior Project III',
      creditsMin: 2.0,
      creditsMax: 2.0,
    ),
    Course(
      course: 'ENGR 354',
      courseTitle: 'Digital Logic',
      creditsMin: 3.0,
      creditsMax: 3.0,
    ),
    Course(
      course: 'MATH 171',
      courseTitle: 'Calculus I',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'MATH 172',
      courseTitle: 'Calculus II',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'MATH 273',
      courseTitle: 'Calculus III',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'MATH 215',
      courseTitle: 'Data Analysis',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'MATH 250',
      courseTitle: 'Discrete Mathematics',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
    Course(
      course: 'MATH 239',
      courseTitle: 'Introduction to Linear Algebra',
      creditsMin: 4.0,
      creditsMax: 4.0,
    ),
  ],
);

final regularGeneralStudies_2023_2024 = GeneralStudiesTrack(
  name: 'General Studies',
  bulletinYear: '2023-2024',
  requiredCourses: [
    // Written Communication and Information Literacy (9 credits)
    CourseRequirement(
      Course(
        course: 'ENGL 121',
        courseTitle: 'College Writing I',
        creditsMin: 3.0,
        creditsMax: 3.0,
      ),
    ),
    CourseRequirement(
      Course(
        course: 'ENGL 122',
        courseTitle: 'College Writing II',
        creditsMin: 3.0,
        creditsMax: 3.0,
      ),
    ),
    CourseRequirement(
      Course(
        course: 'ENGL 223',
        courseTitle: 'Research Writing',
        creditsMin: 3.0,
        creditsMax: 3.0,
      ),
    ),

    // Oral Communications (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'SPCH 101',
          courseTitle: 'Fundamentals of Speech Communication',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SPCH 207',
          courseTitle: 'Small Group Communication',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Quantitative Reasoning (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'MATH 105',
          courseTitle: 'Math for the Liberal Arts',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'MATH 106',
          courseTitle: 'Introduction to Statistics',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'MATH 121',
          courseTitle: 'Precalculus I',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'MATH 171',
          courseTitle: 'Calculus I',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Foundations of Faith (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'RELB 104',
          courseTitle: 'The Ministry of Jesus',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 111',
          courseTitle: 'Messages of the Old Testament',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 231',
          courseTitle: 'Exploring the New Testament',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Physical Health (2 credits) - choose two
    CourseBucket(
      creditRequirement: 2,
      courseOptions: [
        Course(
          course: 'PEAC 113-190',
          courseTitle: 'Physical Activity Courses',
          creditsMin: 1.0,
          creditsMax: 1.0,
        ),
      ],
    ),

    // Humanities (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'ART 251',
          courseTitle: 'Introduction to Art',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 204',
          courseTitle: 'Introduction to Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 210',
          courseTitle: 'Survey of British and American Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 211',
          courseTitle: 'Survey of British and American Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 212',
          courseTitle: 'Survey of British and American Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 274',
          courseTitle: 'Study Tour: British Literature in Context',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'FILM 215',
          courseTitle: 'Introduction to Film Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'MUHL 124',
          courseTitle: 'Introduction to Music',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 204',
          courseTitle: 'Essentials of Critical Reasoning',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 205',
          courseTitle: 'Introduction to Philosophy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // History (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'HIST 121',
          courseTitle: 'The West and the World',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 122',
          courseTitle: 'The West and the World',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 221',
          courseTitle: 'History of the United States',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 222',
          courseTitle: 'History of the United States',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 240',
          courseTitle: 'Cities and Cultures in Middle Eastern History',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 274',
          courseTitle: 'Study Tour: English History in Context',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 275',
          courseTitle: 'History of England',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 283',
          courseTitle: 'Latin America',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Social Science (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'ANTH 225',
          courseTitle: 'Cultural Anthropology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PSYC 130',
          courseTitle: 'General Psychology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PSYC 217',
          courseTitle: 'Psychology of Learning and Development',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PSYC 140',
          courseTitle: 'Introduction to Psychology: Social Foundations',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PSYC 141',
          courseTitle: 'Introduction to Psychology: Biological Foundations',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SOCI 204',
          courseTitle: 'General Sociology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Natural Science (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'BIOL 105',
          courseTitle: 'Contemporary Biology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'BIOL 106',
          courseTitle: 'Contemporary Biology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'BIOL 121',
          courseTitle: 'Anatomy and Physiology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'BIOL 141',
          courseTitle: 'General Biology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'CHEM 105',
          courseTitle: 'Survey of Chemistry',
          creditsMin: 5.0,
          creditsMax: 5.0,
        ),
        Course(
          course: 'CHEM 141 & CHEM 144',
          courseTitle: 'General Chemistry and General Chemistry Laboratory',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHYS 201 & PHYS 204',
          courseTitle: 'Conceptual Physics and Conceptual Physics Laboratory',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHYS 211 & PHYS 214',
          courseTitle: 'General Physics and General Physics Laboratory',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHYS 251 & PHYS 254',
          courseTitle: 'Principles of Physics and Principles of Physics Laboratory',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Religion and Theology - Exploring Scripture (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'RELB 302',
          courseTitle: 'Pentateuch',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 304',
          courseTitle: 'Hebrew Prophets',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 312',
          courseTitle: 'Daniel and Jeremiah',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 313',
          courseTitle: 'Revelation',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 337',
          courseTitle: 'Jesus and The Gospels',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 340',
          courseTitle: 'Acts & New Testament Letters',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 362',
          courseTitle: 'Paul and The Gospel',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Religion and Theology - Exploring SDA Life and Thought (3-4 credits) - choose one
    CourseBucket(
      creditRequirement: 3,
      courseOptions: [
        Course(
          course: 'RELH 457',
          courseTitle: 'History of Adventism',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'RELT 110',
          courseTitle: 'Introduction to Seventh-day Adventist Belief and Practice',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELT 202',
          courseTitle: 'Christian Beliefs',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELT 417',
          courseTitle: 'Prophetic Inspiration',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
      ],
    ),

    // Engaging the Arts (2-4 credits) - choose one
    CourseBucket(
      creditRequirement: 2,
      courseOptions: [
        Course(
          course: 'ART 324',
          courseTitle: 'History of World Art',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'ART 325',
          courseTitle: 'History of World Art',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'ART 326',
          courseTitle: 'History of World Art',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'DRMA 101',
          courseTitle: 'Introduction to Theatre',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'DRMA 363/ENGL 363',
          courseTitle: 'History of Theatre',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 214',
          courseTitle: 'Themes in Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 358',
          courseTitle: 'Classical Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 359',
          courseTitle: 'World Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 360',
          courseTitle: 'Shakespeare Festival',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'ENGL 454/RELB 354',
          courseTitle: 'Literature of the Bible',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENGL 474',
          courseTitle: 'Study Tour: Topics in British Literature',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'MUHL 134',
          courseTitle: 'World Music',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'WRIT 324',
          courseTitle: 'Creative Nonfiction Writing',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'WRIT 334',
          courseTitle: 'Poetry Writing',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Engaging History and Philosophy (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'HIST 242',
          courseTitle: 'Modern East Asian History',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 254',
          courseTitle: 'History of Christianity',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 257',
          courseTitle: 'Voices in African History',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 305',
          courseTitle: 'Ancient Near Eastern Empires',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 306',
          courseTitle: 'Classical Greece and Rome',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 307',
          courseTitle: 'Reform and Revolt',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 320',
          courseTitle: 'Archaeology and Empire',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 354',
          courseTitle: 'American History and Visual Culture',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 355',
          courseTitle: 'The Atlantic World: Liberty, Bondage, and Revolution',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 359/ECON 359',
          courseTitle: 'The American Economy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 434',
          courseTitle: 'Women in the Ancient World',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 437',
          courseTitle: 'Medieval and Renaissance Europe',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 448',
          courseTitle: 'Becoming America: Citizenship and Exceptionalism from 1877-1941',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 450',
          courseTitle: 'America Overseas',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 466',
          courseTitle: 'Women and Society in Early Modern Europe',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HIST 474',
          courseTitle: 'Study Tour: English Reformation',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 305',
          courseTitle: 'Moral Philosophy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 315',
          courseTitle: 'Topics in the History of Philosophy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 461',
          courseTitle: 'African-American Philosophy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Engaging Faith (6-7 credits) - select 6-7 hours for a total of 18 religion credits
    CourseBucket(
      creditRequirement: 6,
      courseOptions: [
        Course(
          course: 'RELB 105',
          courseTitle: 'The Sermon on the Mount',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'RELB 106',
          courseTitle: 'The Parables of Jesus',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'RELB 274',
          courseTitle: 'Study Tour: The Holy Lands and its People',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 303',
          courseTitle: 'Old Testament Psalms, Stories, and Wisdom',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'RELB 306',
          courseTitle: 'The Bible and Its Translations',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'RELB 307',
          courseTitle: 'Creation in the Bible',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'RELB 333',
          courseTitle: 'Biblical Perspectives on Healing',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 339',
          courseTitle: 'Luke-Acts',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 345',
          courseTitle: 'Biblical Narratives',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 354/ENGL 454',
          courseTitle: 'Literature of the Bible',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 382P',
          courseTitle: 'New Testament Biographies',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'RELT 408',
          courseTitle: 'Compassion',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 410',
          courseTitle: 'Women in the Bible',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'RELB 421P',
          courseTitle: 'Interpreting the Bible',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELB 474',
          courseTitle: 'Study Tour: The Holy Lands and Its Peoples',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELH 205',
          courseTitle: 'Biblical Archaeology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELH 303',
          courseTitle: 'World Religions',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELH 425/PSYC 425',
          courseTitle: 'Psychology of Religion',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'RELH 455',
          courseTitle: 'Heresy, Orthodoxy & the Early Church',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'RELM 233',
          courseTitle: 'Introduction to Cross-Cultural Ministry',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'RELT 326',
          courseTitle: 'Spirituality and Discipleship',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELT 340',
          courseTitle: 'Spiritual Care and Nursing',
          creditsMin: 3.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELT 348',
          courseTitle: 'Christian Ethics',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELT 402',
          courseTitle: 'Human Forgiveness',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'RELT 408',
          courseTitle: 'Compassion',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'RELT 412/PHIL 412',
          courseTitle: 'Philosophy of Religion',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Engaging Science and Data (4 credits) - choose one
    CourseBucket(
      creditRequirement: 4,
      courseOptions: [
        Course(
          course: 'MATH 215',
          courseTitle: 'Data Analysis',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'CPTR 230',
          courseTitle: 'Computing for Insight',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ENVI 385',
          courseTitle: 'Environmental Stewardship',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 407',
          courseTitle: 'Philosophy of Science',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),

    // Engaging Society (2-4 credits) - choose one
    CourseBucket(
      creditRequirement: 2,
      courseOptions: [
        Course(
          course: 'COMM 145',
          courseTitle: 'Media and Culture',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'CPTR 130',
          courseTitle: 'Introduction to Data Science',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'CPTR 308',
          courseTitle: 'Social, Legal, and Ethical Issues for Computing Technology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ECON 210',
          courseTitle: 'Principles of Microeconomics',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ECON 220',
          courseTitle: 'Principles of Global Development',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'ECON 359/HIST 359',
          courseTitle: 'The American Economy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'FINA 101',
          courseTitle: 'Personal Finance',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'FINA 325',
          courseTitle: 'Investments',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'GBUS 270',
          courseTitle: 'Business Communication',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'GBUS 361',
          courseTitle: 'Business Law I',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'HLTH 110',
          courseTitle: 'Wellness for Living',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'HLTH 220',
          courseTitle: 'Human Nutrition',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'LANG 406',
          courseTitle: 'Language and Culture',
          creditsMin: 3.0,
          creditsMax: 3.0,
        ),
        Course(
          course: 'MGMT 463',
          courseTitle: 'Business Ethics',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 411',
          courseTitle: 'Philosophy of Law',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PHIL 440/HIST 440',
          courseTitle: 'History of Social and Political Philosophy',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PLSC 224',
          courseTitle: 'American Government',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'PSYC 344',
          courseTitle: 'Social Psychology',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SOCI 225/PSYC 225',
          courseTitle: 'Marriage and Family Life',
          creditsMin: 2.0,
          creditsMax: 2.0,
        ),
        Course(
          course: 'SOCI 234',
          courseTitle: 'Current Social Problems',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SOCI 236',
          courseTitle: 'Privilege and Oppression',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SOCI 420',
          courseTitle: 'Immigration and Identity',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SOWK 260',
          courseTitle: 'Human Behavior and The Social Environment I',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SOWK 261',
          courseTitle: 'Human Behavior and The Social Environment II',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SPCH 341',
          courseTitle: 'Argumentation',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'SPCH 443',
          courseTitle: 'Persuasive Speaking',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
        Course(
          course: 'TECH 321',
          courseTitle: 'Technology and Society',
          creditsMin: 4.0,
          creditsMax: 4.0,
        ),
      ],
    ),
  ],
);
