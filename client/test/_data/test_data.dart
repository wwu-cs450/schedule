final extractedTranscriptText = '''
Date Printed:  Jan 21, 2026
Page 1 of 1    
Walla Walla University204 S College Avenue, College Place, WA 99324  •  509-527-2811  •  ETS Code
4940  Office of the Registrar  •  Unofficial TranscriptStudent Name: Stefaniv, Anna SSN:
xxx-xx-xxxx ID: 2200057 Birthdate:  05/30Attend As Name:
 InaccordancewiththeFamilyRightsandPrivacyActof1974,thistranscriptmustnotbereleasedtoathirdpartyw
 ithoutwrittenauthorizationfromthestudent.Studentisingoodstandingandiseligibletoreturnunlessother
 wisestated.ThistranscriptisnotofficialunlessitbearsthesignatureoftheRegistrarandthesealoftheUniv
 ersity.
CourseCourse TitleGradeHoursAttempt.HoursEarnedGradePointsGPAAdmitted to: Walla Walla
UniversityMatriculated:   Sep 25, 2023
Fall, 2023        Sep 25, 2023     -    Dec 13, 2023CHEM 141General ChemistryA3.03.012.0CHEM
144General Chemistry LabA1.01.04.0CPTR 141Fundamentals of Programming IA4.04.016.0ENGR 121Intro
to Profession of EngrA2.02.08.0GNRL 101University ExperienceS1.01.00.0MATH 171Calculus
IA4.04.016.0RELB 105Sermon on the MountA2.02.08.0TERM TOTALS16.017.064.04.000CUMULATIVE
TOTALS16.017.064.04.000
Winter, 2024        Jan 8, 2024     -    Mar 20, 2024CPTR 142Fundamentals of Programming
IIA4.04.016.0ENGL 121College Writing IA3.03.012.0ENGR 122Intro to CADA2.02.08.0MATH 172Calculus
IIA4.04.016.0MATH 250Discrete MathematicsA4.04.016.0TERM TOTALS17.017.068.04.000CUMULATIVE
TOTALS33.034.0132.04.000
Spring, 2024        Apr 1, 2024     -    Jun 12, 2024CPTR 242Seq & Parllel Dat Struct &
AlgA4.04.016.0ENGL 122College Writing IIA3.03.012.0ENGR 123Intro to Engineering
DesignA-2.02.07.4GBUS 270Business CommunicationA4.04.016.0MATH 273Calculus IIIA-4.04.014.8TERM
TOTALS17.017.066.23.894CUMULATIVE TOTALS50.051.0198.23.964
Fall, 2024        Sep 30, 2024     -    Dec 18, 2024CPTR 280Cptr Org & Assembly
LanguageA-3.03.011.1CPTR 396Internship & Career ReadinessA1.01.04.0ENGL 223Research Writing
(WD)A3.03.012.0MATH 239Introduction to Linear AlgebraA4.04.016.0PHYS 251Prin of
PhysicsA-3.03.011.1PHYS 254Prin of Physics LabA1.01.04.0TERM TOTALS15.015.058.23.880CUMULATIVE
TOTALS65.066.0256.43.944
CourseCourse TitleGradeHoursAttempt.HoursEarnedGradePointsGPA
Winter, 2025        Jan 6, 2025     -    Mar 19, 2025CPTR 245Software DevelopmentA4.04.016.0MATH
215Data AnalysisA4.04.016.0PHYS 252Prin of PhysicsB+3.03.09.9PHYS 255Prin of Physics
LabA1.01.04.0SPCH 101Fundamentals of Speech CommA4.04.016.0TERM TOTALS16.016.061.93.868CUMULATIVE
TOTALS81.082.0318.33.929
Spring, 2025        Mar 31, 2025     -    Jun 11, 2025CPTR 320Web Services & Cloud
ComputingA4.04.016.0CPTR 479Dir Rsrch: Client/Server Web AA-1.01.03.7MATH 274Calculus
IVA4.04.016.0PEAC 157BackpackingA1.01.04.0RELB 104Ministry of JesusA4.04.016.0RELB 106Parables of
JesusA2.02.08.0TERM TOTALS16.016.063.73.981CUMULATIVE TOTALS97.098.0382.03.938
Fall, 2025        Sep 29, 2025     -    Dec 17, 2025CPTR 354Compilers and
LanguagesA-4.04.014.8CPTR 420Intro to Database SystemsA-4.04.014.8ENGR 354Digital
LogicA3.03.012.0GBUS 190Free Enterprise PracticumS0.00.00.0PSYC 140Intro to Psyc:Social
FoundatnsA4.04.016.0TERM TOTALS15.015.057.63.840CUMULATIVE TOTALS112.0113.0439.63.925
Winter, 2026        Jan 5, 2026     -    Mar 18, 2026CPTR 308Ethical Issues for
ComputingNR4.0InProcessCPTR 430Artificial IntelligenceNR4.0InProcessCPTR 454Design & Analy of
AlgorithmsNR4.0InProcessDRMA 101Introduction to TheatreNR3.0InProcessDRMA
252PerformanceNR0.0InProcessPEAC 164Downhill Skiing/SnowboardingNR1.0InProcess
Spring, 2026        Mar 30, 2026     -    Jun 10, 2026CPTR 352Operating SystemsNR4.0InProcessMATH
315Probability & StatisticsNR4.0InProcessRELT 202Christian BeliefsNR4.0InProcess
************************   END  OF  TRANSCRIPT  TO  DATE  ************************''';

final sampleTermText = '''
Sep 25, 2023     -    Dec 13, 2023CHEM 141General ChemistryA3.03.012.0CHEM
144General Chemistry LabA1.01.04.0CPTR 141Fundamentals of Programming IA4.04.016.0ENGR 121Intro
to Profession of EngrA2.02.08.0GNRL 101University ExperienceS1.01.00.0MATH 171Calculus
IA4.04.016.0RELB 105Sermon on the MountA2.02.08.0TERM TOTALS16.017.064.04.000CUMULATIVE
TOTALS16.017.064.04.000''';

final samplePlannedTermText = '''
Jan 5, 2026     -    Mar 18, 2026CPTR 308Ethical Issues for
ComputingNR4.0InProcessCPTR 430Artificial IntelligenceNR4.0InProcessCPTR 454Design & Analy of
AlgorithmsNR4.0InProcessDRMA 101Introduction to TheatreNR3.0InProcessDRMA
252PerformanceNR0.0InProcessPEAC 164Downhill Skiing/SnowboardingNR1.0InProcess''';

final sampleLLMResponseText = '''
<think>
Okay, let me process the user's question and the tool response. The user asked, "What classes am I taking this quarter?" The tool called was getUserRegisteredClasses, which returned a list of classes with terms like "Winter, 2026" and "Spring, 2026". 

First, I need to determine which classes are for the current quarter. The user mentioned "this quarter," which typically refers to the current term. However, the exact current term isn't specified in the user's query. The tool response includes classes for both Winter 2026 and Spring 2026. 

Assuming the current quarter is Winter 2026, the relevant classes would be those with the term "Winter, 2026". The Spring 2026 classes might be for a future quarter. But since the user asked about "this quarter," I should focus on the Winter term. However, if the current term is actually Spring 2026, then those classes would be the ones. 

But since the user didn't specify the exact term, maybe I should list all registered classes and mention the terms. Alternatively, check if there's a way to determine the current term. Since the tool response includes both terms, perhaps the user is enrolled in multiple terms. 

Wait, the user's question is about "this quarter," which is present tense. If the current date is, say, March 2023, then Winter 2026 would be in the future. But maybe the system's data is hypothetical. The user might be asking in a context where the current term is Winter 2026. 

Alternatively, the user might be confused about the terms. To be safe, I should list all the classes the user is registered for, noting the terms. That way, the user can see which are for the current quarter and which are for future ones. 

So, the response should include all the classes from the tool response, grouped by term. That way, the user can easily see which classes are for the current quarter (assuming Winter 2026 is the current term) and which are for future quarters. If the current term is different, the user can adjust accordingly. 

I need to present the information clearly, perhaps listing each class with course, title, credits, and term. Also, mention that the terms are Winter and Spring 2026, so the user can check which applies to their current quarter.
</think>

Here are the classes you're registered for, along with their terms:

**Winter 2026:**
- **CPTR 308** - Ethical Issues for Computing (4 credits)
- **CPTR 430** - Artificial Intelligence (4 credits)
- **CPTR 454** - Design & Analy of Algorithms (4 credits)
- **DRMA 101** - Introduction to Theatre (3 credits)
- **DRMA 252** - Performance (0 credits)
- **PEAC 164** - Downhill Skiing/Snowboarding (1 credit)

**Spring 2026:**
- **CPTR 352** - Operating Systems (4 credits)
- **MATH 315** - Probability & Statistics (4 credits)
- **RELT 202** - Christian Beliefs (4 credits)

Let me know if you'd like help interpreting these!
''';
