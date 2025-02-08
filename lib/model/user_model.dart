
class Employee {
  int? id;
  final String firstName;
  final String lastName;
  final String birthDate;
  final String phoneNumber;
  final String position;
  String? avatar;
  String? email;
  final String hireDate;
  String? resignDate;
  String? createdAt;
  String? updatedAt;
  int? userId;
  List<dynamic>? documents;

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
      birthDate: json['birth_date'],
      phoneNumber: json['phone_number'],
      position: json['position'],
      avatar: json['avatar'],
      email: json['email'],
      hireDate: json['hire_date'],
      resignDate: json['resign_date'] ?? '', 
      createdAt:
          json['resign_date'] ?? '',
      updatedAt:
          json['resign_date'] ?? '',
      userId: json['user_id'], 
      documents: json['documents'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'birth_date': birthDate,
      'phone_number': '+993$phoneNumber',
      'position': position,
      'avatar': avatar,
      'email': email,
      'hire_date': hireDate,
      'resign_date': resignDate,
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
  final List? data;
  List? documents;

  EmployeeList({
    required this.count,
    this.next,
    this.previous,
    required this.data,
    this.documents,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      data: (json['data']),
      documents:(json['documents']),
    );
  }
}

class Documents {
  final List? data;

  Documents({required this.data});

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(data:json['data']);
  }
}

class Document {
  int? id;
  final String name;
  final String type;
  String? filePath;
  String? status;
  String? expiredDate;
  final int? employee;

  Document({required this.employee, 
    required this.name,
    required this.type,
    this.filePath,
    required this.expiredDate,
    this.id,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      employee: json['employee_id'],
      name: json['name'],
      type: json['type'],
      filePath: json['file_path'],
      expiredDate: json['expiry_date'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'type': type,
      'expiry_date': expiredDate,
      'file_path':filePath,
      'employee_id': employee,
    };
  }
}

class UserProf{
  int? id;
  String? firstName;
  String? lastName;
  String? login;
  final String password;
  UserProf({this.id, this.firstName,this.lastName, this.login, required this.password});

  factory UserProf.fromJson(Map<String, dynamic> json){
    return UserProf(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      login: json['login'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'first_name': firstName,
      'last_name' : lastName,
      'login' : login,
      'password':password,
    };
  }
}

class Login{
  final dynamic data;

  Login({required this.data});
  factory Login.fromJson(Map<String, dynamic> json){
    return Login(data: json['data'],);
  }
}

class Token{
  final String accessToken;
  final String refreshToken;

  Token({required this.accessToken, required this.refreshToken});
  factory Token.fromJson(Map<String, String> json){
    return Token(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken']?? '',
    );
  }

}
