

class SubjectFaculty
{
  final String course_id;
 final  String teacher_sec1_id;
 final   String teacher_sec2_id;

  SubjectFaculty({required this.course_id, required this.teacher_sec1_id, required this.teacher_sec2_id});


  Map<String, dynamic> toJson() {
    return {
      'course_id': course_id,
      'teacher_sec1_id': teacher_sec1_id,
      'teacher_sec2_id': teacher_sec2_id,
    };
  }
}
