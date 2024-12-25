import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/all_documents.dart';
import 'package:new_project/pages/employee_doc.dart';
import 'package:new_project/pages/login_page.dart';
import 'package:new_project/pages/new_user.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/pages/update_employee.dart';
import 'package:new_project/pages/user_info.dart';
import 'package:new_project/pages/user_prof.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class UserList extends StatefulWidget {
  List<Employee>? employeeList;
  UserList({super.key, required this.employeeList});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();
  final Translation translation = Translation();
  final ScrollController scrollController = ScrollController();
  int offset = 12;
  final int limit = 12;

  TextEditingController newFirstNameController = TextEditingController();
  TextEditingController newLastNameController = TextEditingController();
  TextEditingController newPositionController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController newBirthdayMonthController = TextEditingController();
  TextEditingController newFirstNameControllerForSearchInGetData =
      TextEditingController();
  TextEditingController newLastNameControllerForSearchInPostData =
      TextEditingController();

  List<Employee> filteredEmployeeList = [];

  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    filteredEmployeeList = widget.employeeList!;

    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        getEmployees();
      }
    });
  }

  Future<void> getEmployees() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newEmployees = await apiService.getData(
        await tokenService.getAccessToken(),
        limit,
        offset,
      );
      setState(() {
        offset += limit;
        filteredEmployeeList.addAll(newEmployees!);
        if (newEmployees.length < limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      print('Error fetching items: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterEmployees(String query) {
    final filteredList = widget.employeeList?.where((employee) {
      return employee.firstName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
          employee.lastName.toLowerCase().contains(query.toLowerCase()) ||
          employee.position.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredEmployeeList = filteredList!;
    });
  }

  void clear() {
    newFirstNameController.clear();
    newLastNameController.clear();
    newPositionController.clear();
    newPhoneController.clear();
    newBirthdayMonthController.clear();
  }

  void _searchEmployeesInPostData(Map<String, String?> query) async {
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
      final users = await apiService.searchEmployeesInPostData(
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

  void _searchEmployeesInGetData(String? query) async {
    if (query!.isEmpty) {
      setState(() {
        filteredEmployeeList = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final users = await apiService.searchEmployeesInGetData(
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  int? selectedAnimatedContainerIndex;
  bool selectedAnimatedProfileIndex = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            onPressed: () async {
              final allDocuments = await apiService
                  .getAllDocuments(await tokenService.getAccessToken());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllDocuments(
                    documents: allDocuments,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.folder,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Search Bar with GetData'),
                    content: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller:
                                newFirstNameControllerForSearchInGetData,
                            decoration: InputDecoration(
                              labelText: 'First name',
                              border: const OutlineInputBorder(),
                              suffixIcon: _isLoading
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        newFirstNameControllerForSearchInGetData
                                            .clear();
                                      },
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller:
                                newLastNameControllerForSearchInPostData,
                            decoration: InputDecoration(
                              labelText: 'Last name',
                              border: const OutlineInputBorder(),
                              suffixIcon: _isLoading
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        newLastNameControllerForSearchInPostData
                                            .clear;
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              newFirstNameControllerForSearchInGetData.clear();
                              newLastNameControllerForSearchInPostData.clear();
                              setState(() {
                                filteredEmployeeList = widget.employeeList!;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              newFirstNameControllerForSearchInGetData.clear();
                              newLastNameControllerForSearchInPostData.clear();
                              setState(() {
                                filteredEmployeeList = widget.employeeList!;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (newFirstNameControllerForSearchInGetData
                                  .text.isNotEmpty) {
                                _searchEmployeesInGetData(
                                  newFirstNameControllerForSearchInGetData.text,
                                );
                              } else if (newLastNameControllerForSearchInPostData
                                  .text.isNotEmpty) {
                                _searchEmployeesInGetData(
                                  newLastNameControllerForSearchInPostData.text,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('There are no such employee'),
                                  ),
                                );
                                setState(() {
                                  filteredEmployeeList = widget.employeeList!;
                                });
                              }
                              Navigator.pop(context);
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
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Profile'),
                onTap: () async {
                  final user = await apiService
                      .getUserInfo(await tokenService.getAccessToken());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        userProf: user,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedAnimatedProfileIndex = !selectedAnimatedProfileIndex;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: selectedAnimatedProfileIndex ? 120 : 65,
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.translate,
                        ),
                        title: Text(
                          'Change Language',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    if (selectedAnimatedProfileIndex)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                print('Turkmen is selected');
                              },
                              child: Text(
                                'Turkmen',
                                style: TextStyle(
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('English is selected');
                              },
                              child: Text(
                                'English',
                                style: TextStyle(
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                onTap: () {
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
              ),
            ),
          ],
        ),
      ),
      body: filteredEmployeeList.isEmpty
          ? Center(
              child: Text(
                'Olar yaly isgar yok',
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontSize: 24.0,
                ),
              ),
            )
          : ListView.builder(
              controller: scrollController,
              itemCount: filteredEmployeeList.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == filteredEmployeeList.length) {
                  return Center(child: CircularProgressIndicator());
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAnimatedContainerIndex =
                          selectedAnimatedContainerIndex == index
                              ? null
                              : index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(),
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: selectedAnimatedContainerIndex == index ? 175 : 115,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Container(
                            height: 75.0,
                            width: 75.0,
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
                          subtitle: Text(
                            filteredEmployeeList[index].position,
                          ),
                          trailing: SizedBox(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateEmployee(
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
                                    final refreshedEmployeeList =
                                        await apiService.getData(
                                      await tokenService.getAccessToken(),
                                      12,
                                      0,
                                    );
                                    if (mounted) {
                                      setState(() {
                                        widget.employeeList =
                                            refreshedEmployeeList!;
                                        filteredEmployeeList =
                                            refreshedEmployeeList!;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (selectedAnimatedContainerIndex == index)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final employeeDoc =
                                        await apiService.getEmployeeDocuments(
                                            filteredEmployeeList[index].id,
                                            await tokenService
                                                .getAccessToken());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeDoc(
                                          id: filteredEmployeeList[index].id,
                                          employeeDocuments: employeeDoc,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Documents',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeInfo(
                                          employeeInformation:
                                              filteredEmployeeList[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Information',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const NewEmployee(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          ElevatedButton(
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
                              decoration: InputDecoration(
                                labelText: 'First name',
                                border: const OutlineInputBorder(),
                                suffixIcon: _isLoading
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          newFirstNameController.clear();
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newLastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last name',
                                border: const OutlineInputBorder(),
                                suffixIcon: _isLoading
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          newLastNameController.clear;
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newPositionController,
                              decoration: InputDecoration(
                                labelText: 'Position',
                                border: const OutlineInputBorder(),
                                suffixIcon: _isLoading
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          newPositionController.clear();
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newPhoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: const OutlineInputBorder(),
                                suffixIcon: _isLoading
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          newPhoneController.clear();
                                        },
                                      ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: newBirthdayMonthController,
                              decoration: InputDecoration(
                                labelText: 'Month of the Birthday',
                                border: const OutlineInputBorder(),
                                suffixIcon: _isLoading
                                    ? CircularProgressIndicator()
                                    : IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () {
                                          newBirthdayMonthController.clear();
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
                                      filteredEmployeeList =
                                          widget.employeeList!;
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
                                    clear();
                                    Navigator.pop(context);
                                    setState(() {
                                      filteredEmployeeList =
                                          widget.employeeList!;
                                    });
                                  },
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final Map<String, String?> searchBar = {
                                      'first_name': newFirstNameController.text,
                                      'last_name': newLastNameController.text,
                                      'position': newPositionController.text,
                                      'phone_number': newPhoneController.text,
                                      'birth_date_month':
                                          newBirthdayMonthController.text,
                                    };
                                    _searchEmployeesInPostData(searchBar);
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
