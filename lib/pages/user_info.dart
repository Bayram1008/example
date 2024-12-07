import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';

class EmployeeInfo extends StatelessWidget {
  final Employee employeeInfo;
  EmployeeInfo({super.key, required this.employeeInfo});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey[300],
          title: const Text(
            'Employee Information',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Icon(Icons.info, color: Colors.blueAccent),
              Icon(Icons.message, color: Colors.blueAccent),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserInformation(employeeInformation: employeeInfo),
            UserDocumation(userId: employeeInfo.id,),
          ],
        ),
      ),
    );
  }
}

class UserInformation extends StatelessWidget {
  final Employee employeeInformation;
  UserInformation({super.key, required this.employeeInformation});

  late final DateTime? timeData = employeeInformation.resignDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        Container(
          height: 250.0,
          width: 250.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(employeeInformation.avatar!.toString()),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              '${employeeInformation.firstName} ${employeeInformation.lastName}',
            ),
            subtitle: Text(employeeInformation.position),
          ),
        ),
        const SizedBox(height: 20.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Email address'),
            subtitle: Text(employeeInformation.email!),
          ),
        ),
        const SizedBox(height: 16.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone number'),
            subtitle: Text(employeeInformation.phoneNumber),
          ),
        ),
        const SizedBox(height: 16.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Birth day'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(employeeInformation.birthDate),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Resign Date'),
            subtitle: Text(
              timeData == null
                  ? 'There is no resignDate'
                  : DateFormat('dd/MM/yyyy').format(timeData!),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Card(
          child: ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Hired date'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(employeeInformation.hireDate),
            ),
          ),
        ),
      ],
    );
  }
}

class UserDocumation extends StatelessWidget {
  final int? userId;
  const UserDocumation({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [

      ],
    );
  }
}
