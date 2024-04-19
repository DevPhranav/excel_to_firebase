

import 'package:cloud_firestore/cloud_firestore.dart';
import '../preprocessor/Faculty_preprocessor/faculty_data_processor.dart';
import '../models/faculty.dart';

class AddOrUpdateFacultyFirebase {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FacultyDataProcessor processor = new FacultyDataProcessor();


    Future<void> addOrUpdateFaculty(List<List<List<dynamic>>> allExcelData) async {
      List<Faculty> facultyList = processor.convertToFaculty(allExcelData[0]);

      for (Faculty faculty in facultyList) {
        DocumentReference facultyDocRef = firestore.collection('faculty').doc(
            faculty.id);

        await facultyDocRef.get().then((docSnapshot) async {
          if (docSnapshot.exists) {
            // Document with the given ID exists, update the values
            await facultyDocRef.update({
              'name': faculty.name,
              'ph_no': faculty.ph_no,
              'email': faculty.email,
              'department': faculty.department,
              'role': faculty.role,
            });
          } else {
            // Document with the given ID does not exist, create a new one
            await facultyDocRef.set({
              'id':faculty.id,
              'name': faculty.name,
              'ph_no': faculty.ph_no,
              'email': faculty.email,
              'department': faculty.department,
              'role': faculty.role,
            });
          }
        });
      }
    }
}