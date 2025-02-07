import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/all_documents.dart';
import 'package:new_project/pages/employee_doc.dart';
import 'package:new_project/pages/new_user.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/pages/update_employee.dart';
import 'package:new_project/pages/user_info.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';
import 'package:new_project/widgets/new_drawer.dart';
import 'package:new_project/widgets/provider.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  List<Employee>? employeeList;
  UserList({super.key, required this.employeeList});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Translation translation = Translation();
  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();
  final ScrollController scrollController = ScrollController();
  int page = 2;
  final int limit = 10;

  TextEditingController newFirstNameController = TextEditingController();
  TextEditingController newLastNameController = TextEditingController();
  TextEditingController newPositionController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController newBirthdayMonthController = TextEditingController();
  TextEditingController newEmailAddressController = TextEditingController();
  TextEditingController newFirstNameControllerForSearchInGetData =
      TextEditingController();
  TextEditingController newLastNameControllerForSearchInPostData =
      TextEditingController();

  List<Employee> filteredEmployeeList = [];
  ChangeIndex changeIndex = ChangeIndex();

  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredEmployeeList = widget.employeeList!;
    });

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
        page,
        limit,
      );
      setState(() {
        page = page + 1;
        filteredEmployeeList.addAll(newEmployees!);
        if (newEmployees.length < limit) {
          _hasMore = false;
        }
        print(page);
      });
    } catch (e) {
      print('Error fetching items: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void clear() {
    newFirstNameController.clear();
    newLastNameController.clear();
    newPositionController.clear();
    newPhoneController.clear();
    newBirthdayMonthController.clear();
    newEmailAddressController.clear();
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

  @override
  void dispose() {
    changeIndex.dispose();
    scrollController.dispose();
    super.dispose();
  }

  int? selectedAnimatedContainerIndex;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => changeIndex,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueGrey[400],
          title: Text(
            translation.listOfEmployees[changeIndex.selectedLanguageIndex],
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final allDocuments = await apiService.getAllDocuments(
                    await tokenService.getAccessToken(), 12, 1);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllDocuments(
                      documents: allDocuments,
                      selectedLanguageIndex: changeIndex.selectedLanguageIndex,
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
                      title: Text(translation
                          .searchBar[changeIndex.selectedLanguageIndex]),
                      content: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller:
                                  newFirstNameControllerForSearchInGetData,
                              decoration: InputDecoration(
                                labelText: translation.firstName[
                                    changeIndex.selectedLanguageIndex],
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
                                labelText: translation.lastName[
                                    changeIndex.selectedLanguageIndex],
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
                                newFirstNameControllerForSearchInGetData
                                    .clear();
                                newLastNameControllerForSearchInPostData
                                    .clear();
                                setState(() {
                                  filteredEmployeeList = widget.employeeList!;
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                translation.cancelButton[
                                    changeIndex.selectedLanguageIndex],
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                newFirstNameControllerForSearchInGetData
                                    .clear();
                                newLastNameControllerForSearchInPostData
                                    .clear();
                                setState(() {
                                  filteredEmployeeList = widget.employeeList!;
                                });
                                Navigator.pop(context);
                              },
                              child: Text(
                                translation.clearButton[
                                    changeIndex.selectedLanguageIndex],
                                style: TextStyle(color: Colors.blue),
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
        drawer: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewDrawer(),
              ),
            );
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        body: filteredEmployeeList.isEmpty
            ? Center(
                child: Text(
                  translation
                      .thereIsNoSuchEmployee[changeIndex.selectedLanguageIndex],
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
                    return null;
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
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      height:
                          selectedAnimatedContainerIndex == index ? 175 : 125,
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
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
                            ),
                            subtitle: Text(
                              '${filteredEmployeeList[index].position} / ${filteredEmployeeList[index].phoneNumber}',
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.white),
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
                                            selectedLanguageIndex: changeIndex
                                                .selectedLanguageIndex,
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
                                      try {
                                        await apiService.deleteData(
                                          filteredEmployeeList[index]
                                              .id
                                              .toString(),
                                          await tokenService.getAccessToken(),
                                        );
                                        final refreshedEmployeeList =
                                            await apiService.getData(
                                          await tokenService.getAccessToken(),
                                          1,
                                          12,
                                        );
                                        if (mounted) {
                                          setState(() {
                                            widget.employeeList =
                                                refreshedEmployeeList!;
                                            filteredEmployeeList =
                                                refreshedEmployeeList;
                                          });
                                        }
                                      } catch (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                              '${translation.cannotDeleteEmployee[changeIndex.selectedLanguageIndex]} $error',
                                              style: TextStyle(
                                                  color: Colors.white54),
                                            ),
                                          ),
                                        );
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                            selectedLanguageIndex: changeIndex
                                                .selectedLanguageIndex,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      translation.documents[
                                          changeIndex.selectedLanguageIndex],
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
                                            selectedLanguageIndex: changeIndex
                                                .selectedLanguageIndex,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      translation.information[
                                          changeIndex.selectedLanguageIndex],
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
                    builder: (BuildContext context) => NewEmployee(
                      selectedLanguageIndex: changeIndex.selectedLanguageIndex,
                    ),
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
                              Text(translation.searchBar[
                                  changeIndex.selectedLanguageIndex]),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: newFirstNameController,
                                decoration: InputDecoration(
                                  labelText: translation.firstName[
                                      changeIndex.selectedLanguageIndex],
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
                                  labelText: translation.lastName[
                                      changeIndex.selectedLanguageIndex],
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
                                controller: newEmailAddressController,
                                decoration: InputDecoration(
                                  labelText: translation.emailAddress[
                                      changeIndex.selectedLanguageIndex],
                                  border: const OutlineInputBorder(),
                                  suffixIcon: _isLoading
                                      ? CircularProgressIndicator()
                                      : IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            newEmailAddressController.clear();
                                          },
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                controller: newPositionController,
                                decoration: InputDecoration(
                                  labelText: translation.position[
                                      changeIndex.selectedLanguageIndex],
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
                                  labelText: translation.phoneNumber[
                                      changeIndex.selectedLanguageIndex],
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
                                  labelText: translation.birthdayMonth[
                                      changeIndex.selectedLanguageIndex],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    child: Text(
                                      translation.cancelButton[
                                          changeIndex.selectedLanguageIndex],
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
                                    child: Text(
                                      translation.clearButton[
                                          changeIndex.selectedLanguageIndex],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 24.0,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final Map<String, String?> searchBar = {
                                        newFirstNameController.text.isNotEmpty
                                            ? "first_name"
                                            : newFirstNameController.text: '',
                                        // newLastNameController
                                        //         .text.isNotEmpty
                                        //     ? "last_name": newLastNameController.text
                                        //     : null,
                                        // newPositionController
                                        //         .text.isNotEmpty
                                        //     ? "position": newPositionController.text
                                        //     : null,
                                        //     newPhoneController.text.isNotEmpty
                                        //         ? "phone_number": newPhoneController.text
                                        //         : null,
                                        //     newBirthdayMonthController
                                        //             .text.isNotEmpty
                                        //         ? "birth_month": newBirthdayMonthController
                                        //             .text
                                        //         : null,
                                        // newEmailAddressController
                                        //         .text.isNotEmpty
                                        //     ? "email": newEmailAddressController.text
                                        //     : null,
                                      };
                                      _searchEmployeesInPostData(searchBar);
                                      clear();
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      translation.searchButton[
                                          changeIndex.selectedLanguageIndex],
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
      ),
    );
  }
}
