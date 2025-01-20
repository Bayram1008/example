import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class NewEmployee extends StatefulWidget {
  final int selectedLanguageIndex;
  const NewEmployee({super.key, required this.selectedLanguageIndex});

  @override
  State<NewEmployee> createState() => _NewEmployeeState();
}

class _NewEmployeeState extends State<NewEmployee> {
  final formKey = GlobalKey<FormState>();
  final Translation translation = Translation();
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

  void clear() {
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
        title: Text(
          translation.informationOfNewEmployee[widget.selectedLanguageIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
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
                translation.chooseImage[widget.selectedLanguageIndex],
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
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                labelText: translation.firstName[widget.selectedLanguageIndex],
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
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                labelText: translation.lastName[widget.selectedLanguageIndex],
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translation
                      .enterFirstName[widget.selectedLanguageIndex];
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newPositionFocus,
              onFieldSubmitted: (_) {
                changeField(context, newPositionFocus, newEmailFocus);
              },
              controller: newPositionController,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                labelText: translation.position[widget.selectedLanguageIndex],
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translation
                      .enterLastName[widget.selectedLanguageIndex];
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newEmailFocus,
              onFieldSubmitted: (_) {
                changeField(context, newEmailFocus, newPhoneFocus);
              },
              controller: newEmailController,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                labelText:
                    translation.emailAddress[widget.selectedLanguageIndex],
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return translation
                      .enterEmailAddress[widget.selectedLanguageIndex];
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              focusNode: newPhoneFocus,
              onFieldSubmitted: (_) {
                changeField(context, newPhoneFocus, newBirthdayFocus);
              },
              controller: newPhoneController,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                labelText:
                    translation.phoneNumber[widget.selectedLanguageIndex],
                border: OutlineInputBorder(),
                hintText: '-- ------',
                prefixIcon: Center(
                    child: Text(
                  '+993',
                  style: TextStyle(fontSize: 18.0),
                )),
                prefixIconConstraints:
                    BoxConstraints(maxWidth: 60, minWidth: 50),
                floatingLabelAlignment: FloatingLabelAlignment.start,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(' '),
                LengthLimitingTextInputFormatter(8),
                CardNumberInputFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 9  ) {
                  return translation
                      .enterPhoneNumber[widget.selectedLanguageIndex];
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: TextStyle(fontSize: 18.0),
              focusNode: newBirthdayFocus,
              onFieldSubmitted: (_) {
                changeField(context, newBirthdayFocus, newHiredDFayFocus);
              },
              controller: newBirthdayController,
              readOnly: true,
              onTap: () => selectDate(context, newBirthdayController),
              decoration: InputDecoration(
                labelText: translation.birthDay[widget.selectedLanguageIndex],
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translation
                      .selectBirthdayDate[widget.selectedLanguageIndex];
                }
                return null;
              },
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
                    decoration: InputDecoration(
                      labelText:
                          translation.hiredDate[widget.selectedLanguageIndex],
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translation
                            .selectHiredDate[widget.selectedLanguageIndex];
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    focusNode: newResignedDayFocus,
                    controller: newResignedDayController,
                    readOnly: true,
                    onTap: () => selectDate(context, newResignedDayController),
                    decoration: InputDecoration(
                      labelText: translation
                          .resignedDate[widget.selectedLanguageIndex],
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
                  child: Text(
                    translation.cancelButton[widget.selectedLanguageIndex],
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // if (formKey.currentState!.validate()) {
                    //   if (avatarFile == null) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(translation
                    //             .chooseImage[widget.selectedLanguageIndex]),
                    //       ),
                    //     );
                    //     return print('This is the avatarFile:${avatarFile}');
                    //   }
                      List<String> phoneNumberList = newPhoneController.text.split('');
                      phoneNumberList.removeAt(2);
                      String newPhoneNumber = '+993${phoneNumberList[0]}${phoneNumberList[1]}${phoneNumberList[2]}${phoneNumberList[3]}${phoneNumberList[4]}${phoneNumberList[5]}${phoneNumberList[6]}${phoneNumberList[7]}';
                      print(newPhoneNumber);
                      DateTime birthDayDateTime = DateTime.parse(newBirthdayController.text);
                      DateTime hiredDayDateTime = DateTime.parse(newHiredDayController.text);
                      DateTime? resignDayDateTime = newResignedDayController.text != '' ? DateTime.parse(newResignedDayController.text) : null;
                      //print('This is the avatarFile:${avatarFile!.path}');
                     //var avatar = await MultipartFile.fromFile(avatarFile!.path);
                      Employee newUser = Employee(
                        firstName: newFirstNameController.text,
                        lastName: newLastNameController.text,
                        birthDate: DateFormat('yyyy-MM-dd').format(birthDayDateTime),
                        phoneNumber: newPhoneNumber,
                        position: newPositionController.text,
                        email: newEmailController.text,
                        hireDate: DateFormat('yyyy-MM-dd').format(hiredDayDateTime),
                        resignDate: resignDayDateTime != null ? DateFormat('yyyy-MM-dd').format(resignDayDateTime) : '',
                      );
                      print('hello world, we are under the newUser');
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
                          'resign_date' : newUser.resignDate ?? '',
                        });
                        print(
                          'This is the path of avatarFile${avatarFile!.path}',
                        );
                        print('We are below of the newData');
                        //print('We have to post the following data ${newUser.fields}');
                        await serviceInNewEmployee.postData(
                          newData,
                          await savedData.getAccessToken(),
                        );

                        final newEmployeeList = await serviceInNewEmployee
                            .getData(await savedData.getAccessToken(), 1, 12);

                        if (!mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserList(employeeList: newEmployeeList),
                          ),
                        );
                      } catch (e) {
                        print('Error in new_user: ${e.toString()}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       backgroundColor: Colors.redAccent,
                    //       content: Text(
                    //         translation.fillBoxesCorrectly[widget.selectedLanguageIndex],
                    //         style: TextStyle(color: Colors.white54),
                    //       ),
                    //     ),
                    //   );
                    // }
                  },
                  child: Text(
                    translation.addButton[widget.selectedLanguageIndex],
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

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write(' '); 
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
