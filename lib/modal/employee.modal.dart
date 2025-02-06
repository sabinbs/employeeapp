class Employee {
  int? id;
  String name;
  String role;
  String startDate;
  String? endDate; // Nullable

  Employee({
    this.id,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });

  // Convert Employee object to Map for SQFlite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'start_date': startDate,
      'end_date': endDate,
    };
  }

  // Create Employee object from Map
  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'],
      name: map['name'],
      role: map['role'],
      startDate: map['start_date'],
      endDate: map['end_date'],
    );
  }
}
