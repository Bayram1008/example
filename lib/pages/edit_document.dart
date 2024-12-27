import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/all_documents.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class EditDocument extends StatefulWidget {
  final int selectedLanguageIndex;
  final Document editDocument;
  const EditDocument({super.key, required this.editDocument, required this.selectedLanguageIndex});

  @override
  State<EditDocument> createState() => _EditDocumentState();
}

class _EditDocumentState extends State<EditDocument> {
  Translation translation = Translation();
  ApiService apiService = ApiService();
  TokenService tokenService = TokenService();

  List<Employee>? allEmployees = [];

  TextEditingController documentName = TextEditingController();
  TextEditingController documentType = TextEditingController();
  TextEditingController employeeID = TextEditingController();

  void getEmployeesAgain() async {
    final employees =
        await apiService.getData(await tokenService.getAccessToken(), 0, null);
        setState(() {
          allEmployees = employees;
        });
  }

  @override
  void initState() {
    getEmployeesAgain();
  }

  File? avatarFile;
  Employee? selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation.editTheDocument[widget.selectedLanguageIndex]),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () async {
                File? pickedFile = await tokenService.pickedAvatar();
                setState(() {
                  avatarFile = pickedFile;
                });
              },
              child: Text(translation.chooseFile[widget.selectedLanguageIndex]),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              controller: documentName = TextEditingController(
                text: widget.editDocument.name,
              ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextFormField(
              controller: documentType = TextEditingController(
                text: widget.editDocument.type,
              ),
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 16.0,
            ),
            DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: allEmployees?.map((employee) {
                  return DropdownMenuItem(
                    value: employee,
                    child: Text(
                      '${employee.firstName} ${employee.lastName}',
                    ),
                  );
                }).toList(),
                onChanged: (employee){
                    selectedEmployee = employee;
                },
                value: selectedEmployee,
                ),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () async {
                print('we are above of edittedDocument');
                Document edittedDocument = Document(
                    employee: int.tryParse(employeeID.text),
                    name: documentName.text,
                    type: documentType.text, 
                    id: widget.editDocument.id);
                    print('we are above of the query');    
                FormData query = FormData.fromMap({
                  'employee': selectedEmployee?.id,
                  'name': edittedDocument.name,
                  'type': edittedDocument.type,
                  'file_path':avatarFile != null ? [await MultipartFile.fromFile(avatarFile!.path)]: null,
                });
                print('we are above of the apiService.updateDocument');
                await apiService.updateDocument(
                    await tokenService.getAccessToken(),
                    query,
                    widget.editDocument.id);
                final newDocuments = await apiService
                    .getAllDocuments(await tokenService.getAccessToken());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllDocuments(documents: newDocuments, selectedLanguageIndex: widget.selectedLanguageIndex,),
                  ),
                );
              },
              child: Text(
                translation.editButton[widget.selectedLanguageIndex],
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
