import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/all_documents.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class EditDocument extends StatefulWidget {
  final int selectedLanguageIndex;
  final Document editDocument;
  const EditDocument(
      {super.key,
      required this.editDocument,
      required this.selectedLanguageIndex});

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
        await apiService.getData(await tokenService.getAccessToken(), 1, null);
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

  List<String> documentTypes = [
    'zagran',
    'pasport',
    'maglumat',
    'diplom',
    'hasiyetnama'
  ];

  String? selectedDocumentType;

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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translation.enterDocumentName[widget.selectedLanguageIndex];
                }
                return null;
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            DropdownButtonFormField(
              hint: Text(widget.editDocument.type),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
                items: documentTypes.map((doc) {
                  return DropdownMenuItem(
                    value: doc,
                    child: Text(doc),
                  );
                }).toList(),
                onChanged: (doc){
                  selectedDocumentType = doc;
                },
                value: selectedDocumentType,
                ),
            SizedBox(
              height: 16.0,
            ),
            DropdownButtonFormField(
              hint: Text(translation.employee[widget.selectedLanguageIndex]),
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
              onChanged: (employee) {
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
                    expiredDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    name: documentName.text,
                    type: selectedDocumentType!,
                    id: widget.editDocument.id, 
                    employee: selectedEmployee?.id);
                print('we are above of the query');
                print('The selected employee is: $selectedEmployee');
                print('employee_id : ${selectedEmployee?.id}');
                print('Document id is: ${widget.editDocument.id}');
                print('we are above of the apiService.updateDocument');
                await apiService.updateDocument(
                    await tokenService.getAccessToken(),
                    edittedDocument);
                final newDocuments = await apiService
                    .getAllDocuments(await tokenService.getAccessToken(), 12, 1);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllDocuments(
                      documents: newDocuments,
                      selectedLanguageIndex: widget.selectedLanguageIndex,
                    ),
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
