

import '../../models/course_teacher.dart';
import '../../models/student.dart';
import '../../models/tutor.dart';

class BatchDataProcessor {
  List<Student> convertToStudents(List<List<dynamic>> studentsData) {
    return studentsData.map((studentInfo) {
      return Student(
        rollNo: "${studentInfo[0]}",
        name:  "${studentInfo[1]}",
        email:  "${studentInfo[2]}",
        phoneNumber:  "${studentInfo[3]}",
        section:  "${studentInfo[4]}",
        parentName:  "${studentInfo[5]}",
        parentEmail:  "${studentInfo[6]}",
        parentPhoneNumber:  "${studentInfo[7]}",
      );
    }).toList();
  }

  List<CourseTeacher> convertToCourseTeachers(List<List<dynamic>> facultyData) {
    return facultyData.map((facultyInfo) {
      return CourseTeacher(
        id: "${facultyInfo[0]}",
        course_id: "${facultyInfo[1]}",
        section:"${facultyInfo[2]}"
      );
    }).toList();
  }

  List<Tutor> convertToTutors(List<List<dynamic>> tutorsData) {
    return tutorsData.map((tutorInfo) {
      return Tutor(
        id: "${tutorInfo[0]}",
        section: "${tutorInfo[1]}",
      );
    }).toList();
  }
}
