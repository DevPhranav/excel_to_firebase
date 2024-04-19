

import '../../models/student.dart';

class StudentDataPreProcessor
{

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
}