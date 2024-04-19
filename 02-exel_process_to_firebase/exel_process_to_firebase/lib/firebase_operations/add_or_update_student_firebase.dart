import 'package:cloud_firestore/cloud_firestore.dart';
import '../preprocessor/student_preprocessor/student_preprocessor.dart';
import '../models/student.dart';

class AddOrUpdateStudentFirebase {
  final String batch_name;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  StudentDataPreProcessor processor = StudentDataPreProcessor();

  AddOrUpdateStudentFirebase({required this.batch_name});

  Future<void> addOrUpdateStudent(List<List<List<dynamic>>> allExcelData) async {
    List<Student> studentList = processor.convertToStudents(allExcelData[0]);

    for (Student student in studentList) {
      DocumentReference studentDocRef = firestore
          .collection('departments/CSE/batches/$batch_name/students/')
          .doc(student.rollNo);

      await studentDocRef.get().then((docSnapshot) async {
        if (docSnapshot.exists) {
          print('Updating existing document for rollNo: ${student.rollNo}');
          await studentDocRef.update({
            'rollNo': student.rollNo,
            'name': student.name,
            'email': student.email,
            'phoneNumber': student.phoneNumber,
            'section': student.section,
            'parentName': student.parentName,
            'parentEmail': student.parentEmail,
            'parentPhoneNumber': student.parentPhoneNumber,
          });
        } else {
          print('Creating new document for rollNo: ${student.rollNo}');
          await studentDocRef.set({
            'rollNo': student.rollNo,
            'name': student.name,
            'email': student.email,
            'phoneNumber': student.phoneNumber,
            'section': student.section,
            'parentName': student.parentName,
            'parentEmail': student.parentEmail,
            'parentPhoneNumber': student.parentPhoneNumber,
          });
        }
      });
    }
  }
}
