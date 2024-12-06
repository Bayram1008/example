import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class NewEmployee extends StatefulWidget {
  const NewEmployee({super.key});

  @override
  State<NewEmployee> createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  final serviceInNewEmployee = ApiService();
  final savedData = TokenService();

  FocusNode newFirstNameFocus = FocusNode();

  FocusNode newLastNameFocus = FocusNode();

  FocusNode newPositionFocus = FocusNode();

  FocusNode newEmailFocus = FocusNode();

  FocusNode newPhoneFocus = FocusNode();

  FocusNode newBirthdayFocus = FocusNode();

  FocusNode newHiredDFayFocus = FocusNode();

  FocusNode newResignedDayFocus = FocusNode();

  final newFirstNameController = TextEditingController();

  final newLastNameController = TextEditingController();

  final newPositionController = TextEditingController();

  final newEmailController = TextEditingController();

  final newPhoneController = TextEditingController();

  final newBirthdayController = TextEditingController();

  final newHiredDayController = TextEditingController();

  final newResignedDayController = TextEditingController();

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      controller.text = "${pickedDate.toLocal()}".split(' ')[0];
    }
  }

  void changeField(
    BuildContext context,
    FocusNode currentField,
    FocusNode nextField,
  ) {
    currentField.unfocus();
    FocusScope.of(context).requestFocus(nextField);
  }

  @override
  void dispose() {
    super.dispose();
    newFirstNameFocus.dispose();
    newLastNameFocus.dispose();
    newPositionFocus.dispose();
    newEmailFocus.dispose();
    newPhoneFocus.dispose();
    newBirthdayFocus.dispose();
    newHiredDFayFocus.dispose();
    newResignedDayFocus.dispose();
  }

  void clear(){
    newFirstNameController.clear();
    newLastNameController.clear();
    newPositionController.clear();
    newEmailController.clear();
    newPhoneController.clear();
    newBirthdayController.clear();
    newHiredDayController.clear();
    newResignedDayController.clear();
    setState(() {
      avatarFile = null;
    });
  }

  

  File? avatarFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Information of new Employee',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ElevatedButton(
              onPressed: () async {
                File? pickedFile = await savedData.pickedAvatar();
                setState(() {
                  avatarFile = pickedFile;
                });
              },
              child: Text(
                'Choose the image for avatar',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              focusNode: newFirstNameFocus,
              onFieldSubmitted: (_) {
                changeField(context, newFirstNameFocus, newLastNameFocus);
              },
              controller: newFirstNameController,
              decoration: const InputDecoration(
                labelText: 'First name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newLastNameFocus,
              onFieldSubmitted: (_) {
                changeField(context, newLastNameFocus, newPositionFocus);
              },
              controller: newLastNameController,
              decoration: const InputDecoration(
                labelText: 'Last name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newPositionFocus,
              onFieldSubmitted: (_) {
                changeField(context, newPositionFocus, newEmailFocus);
              },
              controller: newPositionController,
              decoration: const InputDecoration(
                labelText: 'Position',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newEmailFocus,
              onFieldSubmitted: (_) {
                changeField(context, newEmailFocus, newPhoneFocus);
              },
              controller: newEmailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newPhoneFocus,
              onFieldSubmitted: (_) {
                changeField(context, newPhoneFocus, newBirthdayFocus);
              },
              controller: newPhoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newBirthdayFocus,
              onFieldSubmitted: (_) {
                changeField(context, newBirthdayFocus, newHiredDFayFocus);
              },
              controller: newBirthdayController,
              readOnly: true,
              onTap: () => selectDate(context, newBirthdayController),
              decoration: const InputDecoration(
                labelText: 'Birthday',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: newHiredDFayFocus,
                    onFieldSubmitted: (_) {
                      changeField(
                        context,
                        newHiredDFayFocus,
                        newResignedDayFocus,
                      );
                    },
                    controller: newHiredDayController,
                    readOnly: true,
                    onTap: () => selectDate(context, newHiredDayController),
                    decoration: const InputDecoration(
                      labelText: 'Hired Day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    focusNode: newResignedDayFocus,
                    controller: newResignedDayController,
                    readOnly: true,
                    onTap: () => selectDate(context, newResignedDayController),
                    decoration: const InputDecoration(
                      labelText: 'Resigned Day',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (avatarFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select an avatar image'),
                        ),
                      );
                      return print('This is the avatarFile:${avatarFile}');
                    }
                    print('This is the avatarFile:${avatarFile!.path}');
                    Employee newUser = Employee(
                      firstName: newFirstNameController.text,
                      lastName: newLastNameController.text,
                      birthDate: DateTime.parse(newBirthdayController.text),
                      phoneNumber: newPhoneController.text,
                      position: newPositionController.text,
                      email: newEmailController.text,
                      hireDate: DateTime.parse(newHiredDayController.text),
                    );
                    print('hello world, we are under the newUser');
                    try {
                      FormData newData = FormData.fromMap({
                        'avatar': [
                          await MultipartFile.fromFile(avatarFile!.path),
                        ],
                        'first_name': newUser.firstName,
                        'last_name': newUser.lastName,
                        'birth_date': DateFormat(
                          'yyyy-MM-dd',
                        ).format(newUser.birthDate),
                        'phone_number': newUser.phoneNumber,
                        'position': newUser.position,
                        'email': newUser.email,
                        'hire_date': DateFormat(
                          'yyyy-MM-dd',
                        ).format(newUser.hireDate),
                      });
                      print(
                        'This is the path of avatarFile${avatarFile!.path}',
                      );
                      print('We are below of the newData');
                      print(
                        'We have to post the following data ${newData.fields}',
                      );
                      await serviceInNewEmployee.postData(
                        newData,
                        await savedData.getAccessToken(),
                      );

                      final newEmployeeList = await serviceInNewEmployee
                          .getData(await savedData.getAccessToken());

                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  UserList(employeeList: newEmployeeList),
                        ),
                      );
                    } catch (e) {
                      print('Error: ${e.toString()}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
