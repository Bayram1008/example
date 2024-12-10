import 'package:intl/intl.dart';

class Employee {
  int? id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String phoneNumber;
  final String position;
  String? avatar;
  String? email;
  final DateTime hireDate;
  DateTime? resignDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? userId;

  List<Document?>? documents;

  Employee({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.phoneNumber,
    required this.position,
    this.avatar,
    this.email,
    required this.hireDate,
    this.resignDate,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.documents,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthDate: DateTime.parse(json['birth_date']),
      phoneNumber: json['phone_number'].toString(),
      position: json['position'],
      avatar: json['avatar'],
      email: json['email'],
      hireDate: DateTime.parse(json['hire_date']),
      resignDate:
          json['resign_date'] != null
              ? DateTime.parse(json['resign_date'])
              : null,
      createdAt:
          json['resign_date'] != null
              ? DateTime.parse(json['resign_date'])
              : null,
      updatedAt:
          json['resign_date'] != null
              ? DateTime.parse(json['resign_date'])
              : null,
      userId: json['user_id'], 
      documents: json['documents'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': DateFormat('yyyy-MM-dd').format(birthDate),
      'phone_number': '+993$phoneNumber',
      'position': position,
      'avatar': avatar,
      'email': email,
      'hire_date': DateFormat('yyyy-MM-dd').format(hireDate),
      'resign_date': DateFormat('yyyy-MM-dd').format(resignDate!),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
    };
  }
}

class EmployeeList {
  final int count;
  final String? next;
  final String? previous;
  final List results;

  EmployeeList({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List),
    );
  }
}

class Documents {
  final List document;

  Documents({required this.document});

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(document: json['documents'] as List);
  }
}

class Document {
  int? id;
  final String name;
  final String type;
  final String filePath;
  String? status;
  final DateTime expiredDate;

  Document({
    required this.name,
    required this.type,
    required this.filePath,
    required this.expiredDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'],
      type: json['type'],
      filePath: json['file_path'],
      expiredDate: DateTime.parse(json['expiry_date']),
    );
  }
}
