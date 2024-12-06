import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class UpdateEmployee extends StatefulWidget {
  final Employee editEmployee;
  const UpdateEmployee({super.key, required this.editEmployee});

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  TextEditingController editedFirstNameController = TextEditingController();
  TextEditingController editedLastNameController = TextEditingController();
  TextEditingController editedPositionController = TextEditingController();
  TextEditingController editedEmailController = TextEditingController();
  TextEditingController editedPhoneNumberController = TextEditingController();
  TextEditingController editedBirthDayController = TextEditingController();
  TextEditingController editedHiredDateController = TextEditingController();
  TextEditingController editedResignedDateController = TextEditingController();

  final ApiService serviceInUpdateEmployee = ApiService();
  final TokenService savedDataInUpdateEmployee = TokenService();
  File? avatarFile;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit the Employee'), centerTitle: true),
      body: Form(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                File? pickedFile =
                    await savedDataInUpdateEmployee.pickedAvatar();
                setState(() {
                  avatarFile = pickedFile;
                });
              },
              child: Text(
                'Change the image for avatar',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedFirstNameController = TextEditingController(
                    text: widget.editEmployee.firstName,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedLastNameController = TextEditingController(
                    text: widget.editEmployee.lastName,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedPositionController = TextEditingController(
                    text: widget.editEmployee.position,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedEmailController = TextEditingController(
                    text: widget.editEmployee.email,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedPhoneNumberController = TextEditingController(
                    text: widget.editEmployee.phoneNumber,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedBirthDayController = TextEditingController(
                    text: DateFormat(
                      'dd/MM/yyyy',
                    ).format(widget.editEmployee.birthDate),
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedHiredDateController = TextEditingController(
                    text: DateFormat(
                      'dd/MM/yyyy',
                    ).format(widget.editEmployee.hireDate),
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedResignedDateController = TextEditingController(
                    text: DateFormat(
                      'dd/MM/yyyy',
                    ).format(widget.editEmployee.resignDate ?? DateTime.now()),
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                Employee newUser = Employee(
                  firstName: editedFirstNameController.text,
                  lastName: editedLastNameController.text,
                  birthDate: DateTime.now(),
                  phoneNumber: editedPhoneNumberController.text,
                  position: editedPositionController.text,
                  email: editedEmailController.text,
                  hireDate: DateTime.now(),
                  resignDate: DateTime.now(),
                );
                try {
                  FormData newData = FormData.fromMap({
                    'avatar': [await MultipartFile.fromFile(avatarFile!.path)],
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
                  print('This is the path of avatarFile${avatarFile!.path}');
                  print('We are below of the newData');
                  print('We have to post the following data ${newData.fields}');
                  await serviceInUpdateEmployee.updateData(
                    '${widget.editEmployee.id}',
                    await savedDataInUpdateEmployee.getAccessToken(),
                    newData,
                  );

                  final newEmployeeList = await serviceInUpdateEmployee.getData(
                    await savedDataInUpdateEmployee.getAccessToken(),
                  );

                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => UserList(employeeList: newEmployeeList),
                    ),
                  );
                } catch (e) {
                  print('Error: ${e.toString()}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text(
                'Update Employee',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
