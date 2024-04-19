class Tutor {
  final String id;
  final String section;

  Tutor({required this.id, required this.section});
  @override
  String toString() {
    return 'Tutor{id: $id, section:$section}';
  }
}
