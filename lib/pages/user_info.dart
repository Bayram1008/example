import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';
import 'package:open_filex/open_filex.dart';

class EmployeeInfo extends StatelessWidget {
  final Employee employeeInfo;
  List<Document?>? employeeDocuments;
  EmployeeInfo({super.key, required this.employeeInfo, this.employeeDocuments});

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
            UserDocumation(employeeDocs: employeeDocuments),
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
  final List<Document?>? employeeDocs;
  UserDocumation({super.key, required this.employeeDocs});

  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();

  void showOpenWithBottomSheet(BuildContext context, String? filePath) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.file_open),
                title: Text('Open with default app'),
                onTap: () async {
                  final result = await OpenFilex.open(filePath!);
                  Navigator.pop(context);
                  if (result.type != ResultType.done) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to open file')),
                    );
                  }
                },
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return employeeDocs!.isEmpty
        ? Center(
          child: Text(
            'There is no any Documents',
            style: TextStyle(
              color: Colors.deepOrangeAccent,
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: employeeDocs!.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('${employeeDocs![index]?.name}'),
                subtitle: Text('${employeeDocs![index]?.type}'),
                onTap: (){
                  showOpenWithBottomSheet(context, employeeDocs![index]?.filePath);
                },
              ),
            );
          },
        );
  }
}
