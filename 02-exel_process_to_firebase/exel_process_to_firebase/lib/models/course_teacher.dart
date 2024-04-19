class CourseTeacher {
  final String id;
  final String course_id;
  final String section;

  CourseTeacher({required this.id, required this.course_id, required this.section});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': course_id,
      'section': section,
    };
  }

  @override
  String toString() {
    return 'CourseTeacher{id: $id, course_id: $course_id, section: $section}';
  }
}
