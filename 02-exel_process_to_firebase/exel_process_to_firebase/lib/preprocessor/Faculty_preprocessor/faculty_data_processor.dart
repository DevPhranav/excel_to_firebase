

import 'package:exel_process_to_firebase/models/faculty.dart';


class FacultyDataProcessor {
  List<Faculty> convertToFaculty(List<List<dynamic>> facultyData) {
    return facultyData.map((facultyInfo) {
      return Faculty(
          id: "${facultyInfo[0]}",
          name: "${facultyInfo[1]}",
          ph_no: "${facultyInfo[2]}",
          email: "${facultyInfo[3]}",
          department: "${facultyInfo[4]}",
          role: "${facultyInfo[5]}"
      );
    }).toList();
  }
}