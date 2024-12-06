import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/search_page.dart';

class EmployeeInfo extends StatelessWidget {
  final Employee employeeInfo;
  EmployeeInfo({super.key, required this.employeeInfo});

  late final DateTime? timeData = employeeInfo.resignDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: const Text(
          'Employee Information',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Container(
            height: 250.0,
            width: 250.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(employeeInfo.avatar!.toString()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text('${employeeInfo.firstName} ${employeeInfo.lastName}'),
              subtitle: Text(employeeInfo.position),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.mail),
              title: const Text('Email address'),
              subtitle: Text(employeeInfo.email!),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone number'),
              subtitle: Text(employeeInfo.phoneNumber),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Birth day'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy').format(employeeInfo.birthDate),
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
                DateFormat('dd/MM/yyyy').format(employeeInfo.hireDate),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            child: Text('Search bar'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSearchPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
