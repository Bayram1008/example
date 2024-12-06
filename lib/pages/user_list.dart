import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/login_page.dart';
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

  TextEditingController newFirstNameController = TextEditingController();
  TextEditingController newLastNameController = TextEditingController();
  TextEditingController newPositionController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController newBirthdayMonthController = TextEditingController();

  List<Employee> filteredEmployeeList = [];

  bool _isLoading = false;

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

  void clear() {
    newFirstNameController.clear();
    newLastNameController.clear();
    newPositionController.clear();
    newPhoneController.clear();
    newBirthdayMonthController.clear();
  }

  void _searchUsers(Map<String, String?> query) async {
    if (query.isEmpty) {
      setState(() {
        filteredEmployeeList = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final users = await apiService.searchUsers(
        query,
        await tokenService.getAccessToken(),
      );
      setState(() {
        filteredEmployeeList = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('HINT'),
                  content: const Text('Do you really want to log out?'),
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
                            tokenService.clearTokens();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
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
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[400],
        title: const Text(
          'List of Employees',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
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
                      color: Colors.blueGrey[100],
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
                                      : AssetImage('assets/images.jpg')
                                          as ImageProvider,
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
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green[800],
                                ),
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
                                      widget.employeeList =
                                          refreshedEmployeeList;
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const NewEmployee(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: Center(
                        child: ListView(
                          children: [
                            Text('Search Bar'),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newFirstNameController,
                              onChanged: (_) {
                                final Map<String, String?> searchBar = {
                                  'first_name': newFirstNameController.text,
                                  'last_name': newLastNameController.text,
                                  'position': newPositionController.text,
                                  'phone_number': newPhoneController.text,
                                  'birth_date_month':
                                      newBirthdayMonthController.text,
                                };
                                _searchUsers(searchBar);
                              },
                              decoration: InputDecoration(
                                labelText: 'First name',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            newFirstNameController.clear();
                                            _searchUsers;
                                          },
                                        ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newLastNameController,
                              onChanged: (_) {
                                final Map<String, String?> searchBar = {
                                  'first_name': newFirstNameController.text,
                                  'last_name': newLastNameController.text,
                                  'position': newPositionController.text,
                                  'phone_number': newPhoneController.text,
                                  'birth_date_month':
                                      newBirthdayMonthController.text,
                                };
                                _searchUsers(searchBar);
                              },
                              decoration: InputDecoration(
                                labelText: 'Last name',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            newFirstNameController.clear();
                                            _searchUsers;
                                          },
                                        ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newPositionController,
                              onChanged: (_) {
                                final Map<String, String?> searchBar = {
                                  'first_name': newFirstNameController.text,
                                  'last_name': newLastNameController.text,
                                  'position': newPositionController.text,
                                  'phone_number': newPhoneController.text,
                                  'birth_date_month':
                                      newBirthdayMonthController.text,
                                };
                                _searchUsers(searchBar);
                              },
                              decoration: InputDecoration(
                                labelText: 'Position',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            newFirstNameController.clear();
                                            _searchUsers;
                                          },
                                        ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newPhoneController,
                              onChanged: (_) {
                                final Map<String, String?> searchBar = {
                                  'first_name': newFirstNameController.text,
                                  'last_name': newLastNameController.text,
                                  'position': newPositionController.text,
                                  'phone_number': newPhoneController.text,
                                  'birth_date_month':
                                      newBirthdayMonthController.text,
                                };
                                _searchUsers(searchBar);
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            newFirstNameController.clear();
                                            _searchUsers;
                                          },
                                        ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newBirthdayMonthController,
                              onChanged: (_) {
                                final Map<String, String?> searchBar = {
                                  'first_name': newFirstNameController.text,
                                  'last_name': newLastNameController.text,
                                  'position': newPositionController.text,
                                  'phone_number': newPhoneController.text,
                                  'birth_date_month': DateFormat.MMMM().format(newBirthdayMonthController.text as DateTime),
                                };
                                _searchUsers(searchBar);
                              },
                              decoration: InputDecoration(
                                labelText: 'Month of the Birthday',
                                border: const OutlineInputBorder(),
                                suffixIcon:
                                    _isLoading
                                        ? CircularProgressIndicator()
                                        : IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            newFirstNameController.clear();
                                            _searchUsers;
                                          },
                                        ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    clear();
                                    Navigator.pop(context);
                                    setState(() {
                                      initState();
                                    });
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.search),
          ),
        ],
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
