import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/new_user.dart';
import 'package:new_project/pages/update_employee.dart';
import 'package:new_project/pages/user_info.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class UserList extends StatefulWidget {
  List<Employee> employeeList;
  UserList({super.key, required this.employeeList});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();

  List<Employee> filteredEmployeeList = [];

  @override
  void initState() {
    super.initState();
    filteredEmployeeList = widget.employeeList;
  }

  void _filterEmployees(String query) {
    final filteredList =
        widget.employeeList.where((employee) {
          return employee.firstName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              employee.lastName.toLowerCase().contains(query.toLowerCase()) ||
              employee.position.toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredEmployeeList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'List of Employees',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Search Field in the AppBar
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearchDelegate(widget.employeeList),
              );
            },
          ),
        ],
      ),
      body:
          filteredEmployeeList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: filteredEmployeeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => EmployeeInfo(
                                employeeInfo: filteredEmployeeList[index],
                              ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  filteredEmployeeList[index].avatar != null
                                      ? NetworkImage(
                                        '${filteredEmployeeList[index].avatar}',
                                      )
                                      : AssetImage('assets/images.jpg') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          '${filteredEmployeeList[index].firstName} ${filteredEmployeeList[index].lastName}',
                        ),
                        subtitle: Text(filteredEmployeeList[index].position),
                        trailing: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => UpdateEmployee(
                                            editEmployee:
                                                filteredEmployeeList[index],
                                          ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit, color: Colors.green[800]),
                              ),
                              const SizedBox(width: 8.0),
                              IconButton(
                                onPressed: () async {
                                  await apiService.deleteData(
                                    filteredEmployeeList[index].id.toString(),
                                    await tokenService.getAccessToken(),
                                  );
                                  final refreshedEmployeeList = await apiService
                                      .getData(
                                        await tokenService.getAccessToken(),
                                      );
                                  if (mounted) {
                                    setState(() {
                                      widget.employeeList = refreshedEmployeeList;
                                      filteredEmployeeList =
                                          refreshedEmployeeList;
                                    });
                                  }
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => const NewEmployee(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final List<Employee> employeeList;

  UserSearchDelegate(this.employeeList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results =
        employeeList
            .where(
              (employee) =>
                  employee.firstName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.lastName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.position.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${results[index].firstName} ${results[index].lastName}'),
          subtitle: Text(results[index].position),
          onTap: () {
            // Navigate to employee details page
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions =
        employeeList
            .where(
              (employee) =>
                  employee.firstName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.lastName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  employee.position.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '${suggestions[index].firstName} ${suggestions[index].lastName}',
          ),
          subtitle: Text(suggestions[index].position),
          onTap: () {
            query = suggestions[index].firstName;
            showResults(context);
          },
        );
      },
    );
  }
}
