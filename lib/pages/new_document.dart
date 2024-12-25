import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/employee_doc.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class NewDocument extends StatefulWidget {
  final int? id;
  const NewDocument({super.key,required this.id});

  @override
  State<NewDocument> createState() => _NewDocumentState();
}

class _NewDocumentState extends State<NewDocument> {
  TokenService tokenService = TokenService();

  ApiService apiService = ApiService();

  TextEditingController documentName = TextEditingController();

  TextEditingController documentType = TextEditingController();

  TextEditingController documentExpiredType = TextEditingController();

  FocusNode documentNameFocusNode = FocusNode();

  FocusNode documentTypeFocusNode = FocusNode();

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
    documentNameFocusNode.dispose();
    documentTypeFocusNode.dispose();
  }

  void clear() {
    documentName.clear();
    documentType.clear();
    documentExpiredType.clear();
  }

  File? avatarFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          'New Document',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            ElevatedButton(
              onPressed: () async {
                File? pickedFile = await tokenService.pickedAvatar();
                setState(() {
                  avatarFile = pickedFile;
                });
              },
              child: Text(
                'Choose the file',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              autofocus: true,
              focusNode: documentNameFocusNode,
              onFieldSubmitted: (_) {
                changeField(
                  context,
                  documentNameFocusNode,
                  documentTypeFocusNode,
                );
              },
              controller: documentName,
              style: TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
                labelText: 'Document name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              focusNode: documentTypeFocusNode,
              controller: documentType,
              style: TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
                labelText: 'Document type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: documentExpiredType,
              style: TextStyle(fontSize: 18.0),
              onTap: () => selectDate(context, documentExpiredType),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Expired Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Document newDocument = Document(
                      employee: widget.id,
                      name: documentName.text,
                      type: documentType.text,
                      expiredDate: DateTime.parse(documentExpiredType.text), 
                    );
                    FormData query = FormData.fromMap({
                      'employee':newDocument.employee,
                      'name': newDocument.name,
                      'type': newDocument.type,
                      'expiry_date': DateFormat('yyyy-MM-dd').format(newDocument.expiredDate!),
                      'file_path': [
                          await MultipartFile.fromFile(avatarFile!.path),
                        ],
                    });
                    await apiService.postDocument(await tokenService.getAccessToken(), query);

                    final employeeDoc = await apiService.getEmployeeDocuments(widget.id, await tokenService.getAccessToken());

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EmployeeDoc(id: widget.id, employeeDocuments: employeeDoc,),),);

                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
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
