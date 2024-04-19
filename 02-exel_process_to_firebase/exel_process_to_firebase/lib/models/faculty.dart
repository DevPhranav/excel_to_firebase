
class Faculty{
  final String id;
  final String name;
  final String ph_no;
  final String email;
  final String department;
  final String role;

  Faculty({required this.id, required this.name, required this.ph_no, required this.email, required this.department, required this.role});

  @override
  String toString() {
    return 'Tutor{id: $id, name:$name, ph_no:$ph_no,email:$email,department:$department,role:$role}';
  }
}