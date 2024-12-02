import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';

class EmployeeInfo extends StatelessWidget {
  final Employee employeeInfo;
  EmployeeInfo({super.key, required this.employeeInfo});

  late final DateTime? timeData = employeeInfo.resignDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Hint'),
                  content: const Text('Do you really want to quit?'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Employee Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ListView(
            children: [
              Container(
                height: 250.0,
                width: 250.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(employeeInfo.avatar!.toString()),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    '${employeeInfo.firstName} ${employeeInfo.lastName}',
                  ),
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
              Card(
                child: ListTile(
                  leading: const Icon(Icons.date_range),
                  title: const Text('Hired date'),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy').format(employeeInfo.hireDate),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
