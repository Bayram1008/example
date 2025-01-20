import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class UpdateEmployee extends StatefulWidget {
  final int selectedLanguageIndex;
  final Employee editEmployee;
  const UpdateEmployee({super.key, required this.editEmployee, required this.selectedLanguageIndex});

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
  final Translation translation =Translation();
  File? avatarFile;

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translation.updateEmployee[widget.selectedLanguageIndex]), centerTitle: true),
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
                translation.chooseImage[widget.selectedLanguageIndex],
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
                    text: widget.editEmployee.birthDate,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
              onTap: () {
                selectDate(context, editedBirthDayController);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedHiredDateController = TextEditingController(
                    text: widget.editEmployee.hireDate),
              decoration: InputDecoration(border: OutlineInputBorder()),
              onTap: () {
                selectDate(context, editedHiredDateController);
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller:
                  editedResignedDateController = TextEditingController(
                    text: widget.editEmployee.resignDate,
                  ),
              decoration: InputDecoration(border: OutlineInputBorder()),
              onTap: () {
                selectDate(context, editedResignedDateController);
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                DateTime? birthdayDateTime = editedBirthDayController.text.isEmpty ? null : DateTime.parse(editedBirthDayController.text);
                DateTime? hiredDayDateTime = editedHiredDateController.text.isEmpty ? null : DateTime.parse(editedHiredDateController.text);
                DateTime? resignedDayDateTime = editedResignedDateController.text.isEmpty ? null : DateTime.parse(editedResignedDateController.text);
                Employee newUser = Employee(
                  firstName: editedFirstNameController.text.isNotEmpty ? editedFirstNameController.text : widget.editEmployee.firstName,
                  lastName: editedLastNameController.text.isNotEmpty ? editedLastNameController.text : widget.editEmployee.lastName,
                  birthDate: birthdayDateTime != null ? DateFormat('yyyy-MM-dd').format(birthdayDateTime) : '',
                  phoneNumber: editedPhoneNumberController.text.isNotEmpty ? editedPhoneNumberController.text : widget.editEmployee.phoneNumber,
                  position: editedPositionController.text.isNotEmpty ? editedPositionController.text : widget.editEmployee.position,
                  email: editedEmailController.text.isNotEmpty ? editedEmailController.text : widget.editEmployee.email,
                  hireDate: hiredDayDateTime != null ? DateFormat('yyyy-MM-dd').format(hiredDayDateTime) : '',
                  resignDate:resignedDayDateTime != null ? DateFormat('yyyy-MM-dd').format(resignedDayDateTime) : '', 
                );
                try {
                  FormData newData = FormData.fromMap({
                    'avatar': [await MultipartFile.fromFile(avatarFile!.path)],
                    'first_name': newUser.firstName,
                    'last_name': newUser.lastName,
                    'birth_date': newUser.birthDate,
                    'phone_number': newUser.phoneNumber,
                    'position': newUser.position,
                    'email': newUser.email,
                    'hire_date': newUser.hireDate,
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
                    await savedDataInUpdateEmployee.getAccessToken(), 1, 12
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
                translation.editButton[widget.selectedLanguageIndex],
                style: TextStyle(
                  color: Colors.greenAccent,
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
