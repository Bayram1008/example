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

  List<dynamic> documents;

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
    required this.documents,
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
      documents: json['documents'] ?? [],
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
  final int? count;
  final String? next;
  final String? previous;
  final List? results;
  List? documents;

  EmployeeList({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.documents,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results']),
      documents:(json['documents']),
    );
  }
}

class Documents {
  final List? results;

  Documents({required this.results});

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(results:json['results']==null ? [] : json['results'] as List);
  }
}

class Document {
  int? id;
  final String name;
  final String type;
  String? filePath;
  String? status;
  DateTime? expiredDate;
  final int? employee;

  Document({required this.employee, 
    required this.name,
    required this.type,
    this.filePath,
    this.expiredDate,
    this.id,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      employee: json['employee'],
      name: json['name'],
      type: json['type'],
      filePath: json['file_path'],
      expiredDate: json['expiry_date'] != null
              ? DateTime.parse(json['expiry_date'])
              : null,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'type': type,
      'expiry_date': DateFormat('yyyy-MM-dd').format(expiredDate!),
      'file_path':filePath,
      'employee': employee,
    };
  }
}

class UserProf{
  int? id;
  String? username;
  final String password;
  UserProf({this.id, this.username, required this.password});

  factory UserProf.fromJson(Map<String, dynamic> json){
    return UserProf(
      id: json['id'],
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'username': username,
      'password':password,
    };
  }
}
