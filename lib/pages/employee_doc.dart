import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/new_document.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';
import 'package:open_file/open_file.dart';

class EmployeeDoc extends StatefulWidget {
  final int selectedLanguageIndex;
  List<Document>? employeeDocuments;
  final int? id;
  EmployeeDoc({super.key, required this.employeeDocuments, required this.id, required this.selectedLanguageIndex});

  @override
  State<EmployeeDoc> createState() => _EmployeeDocState();
}

class _EmployeeDocState extends State<EmployeeDoc> {
  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();
  final Translation translation = Translation();

  void showOpenWithBottomSheet(BuildContext context, String? filePath) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.file_open),
                title: Text('Open with default app'),
                onTap: () async {
                  final result = await OpenFile.open(filePath!);
                  Navigator.pop(context);
                  if (result.type != ResultType.done) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to open file')),
                    );
                  }
                },
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          translation.documentsOfEmployee[widget.selectedLanguageIndex],
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: widget.employeeDocuments!.isEmpty
          ? Center(
              child: Text(
                translation.thereIsNoAnyDocument[widget.selectedLanguageIndex],
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.employeeDocuments?.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.note, size: 24.0),
                    title: Text(widget.employeeDocuments![index].name),
                    subtitle: Text(widget.employeeDocuments![index].type),
                    onTap: () {
                      showOpenWithBottomSheet(
                        context,
                        widget.employeeDocuments![index].filePath,
                      );
                    },
                    trailing: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await apiService.downloadDocument(
                                  await tokenService.getAccessToken(),
                                  widget.employeeDocuments![index].name,
                                  widget.employeeDocuments![index].filePath, context);
                            },
                            icon: Icon(Icons.download, size: 24.0, color: Colors.blueGrey,),
                          ),
                          IconButton(
                            onPressed: () async {
                              await apiService.deleteDocument(
                                widget.employeeDocuments![index].id,
                                await tokenService.getAccessToken(),
                              );
                              final newDocuments =
                                  await apiService.getEmployeeDocuments(
                                widget.id,
                                await tokenService.getAccessToken(),
                              );
                              setState(() {
                                widget.employeeDocuments = newDocuments;
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 24.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewDocument(
                id: widget.id, selectedLanguageIndex: widget.selectedLanguageIndex,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
