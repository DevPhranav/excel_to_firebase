

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_teacher.dart';
import '../models/student.dart';
import '../models/tutor.dart';




import '../preprocessor/Batch_preprocessor/batch_data_processor.dart';
import '../models/subject_faculty.dart';

class PushBatch {
  final String batch_name;
  final String senior_tutor_id;

  PushBatch(this.batch_name, this.senior_tutor_id);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  BatchDataProcessor processor = BatchDataProcessor();


  Future<void> pushBatchData(List<List<List<dynamic>>> allExcelData) async {
    List<Student> students = processor.convertToStudents(allExcelData[0]);
    List<CourseTeacher> courseTeachers = processor.convertToCourseTeachers(allExcelData[1]);
    List<Tutor> tutors = processor.convertToTutors(allExcelData[2]);

    Map<String, dynamic> batchData = createBatchData(students, courseTeachers, tutors);

    String documentId = batchData["batch_id"];
    await firestore
        .collection('departments')
        .doc('CSE')
        .collection('batches')
        .doc(documentId)
        .set(batchData);

    // Save students as a subcollection
    CollectionReference studentsCollection = firestore
        .collection('departments')
        .doc('CSE')
        .collection('batches')
        .doc(documentId)
        .collection('students');

    CollectionReference semCoursesCollection = firestore
        .collection('departments')
        .doc('CSE')
        .collection('batches')
        .doc(documentId)
        .collection('semester')
        .doc('subject_faculty')
        .collection('01');


    for(var subjectFaculty in createSemesterCourses(courseTeachers))
      {
        await semCoursesCollection.doc(subjectFaculty.course_id).set(subjectFaculty.toJson());
      }

    for (var student in students) {
      await studentsCollection.doc(student.rollNo).set(student.toJson());
    }

    print('Batch data with student and tutor information added to Firestore.');
  }

  Map<String, dynamic> createBatchData(List<Student> students, List<CourseTeacher> courseTeachers, List<Tutor> tutors) {
    List<Tutor> section1Tutors = filterTutorsBySection(tutors, "1");
    List<Tutor> section2Tutors = filterTutorsBySection(tutors, "2");
    // Create the JSON structure for one batch with empty semesters (2 to 8)
    return {
      "batch_id": batch_name,
      "senior_tutor_id": senior_tutor_id,
      "tutors_sec1": section1Tutors.map((tutor) => tutor.id).toList(),
      "tutors_sec2": section2Tutors.map((tutor) => tutor.id).toList(),
      "semesters": [
        {
          "semester": 1,
        },
      ],
    };
  }

  List<Tutor> filterTutorsBySection(List<Tutor> tutors, String section) {
    return tutors.where((tutor) => tutor.section == section).toList();
  }

  List<SubjectFaculty> createSemesterCourses(List<CourseTeacher> courseTeachers) {
    Map<String, dynamic> semesterCourses = {};
    List<SubjectFaculty> subjectFaculties = [];

    courseTeachers.forEach((courseTeacher) {
      String teacherSec1Id =
      getTeacherIdForSection(courseTeacher.section, "1", courseTeachers);
      String teacherSec2Id =
      getTeacherIdForSection(courseTeacher.section, "2", courseTeachers);

      semesterCourses[courseTeacher.course_id] = {
        "teacher_sec1_id": teacherSec1Id,
        "teacher_sec2_id": teacherSec2Id,
      };

      subjectFaculties.add(SubjectFaculty(
        course_id: courseTeacher.course_id,
        teacher_sec1_id: teacherSec1Id,
        teacher_sec2_id: teacherSec2Id,
      ));
    });

    return subjectFaculties;
  }



  String getTeacherIdForSection(String currentSection, String targetSection, List<CourseTeacher> courseTeachers) {
    // Find the first teacher ID for the target section
    for (var teacher in courseTeachers) {
      if (teacher.section == targetSection) {
        return teacher.id;
      }
    }
    return ""; // Return an empty string if no teacher found for the target section
  }
}
