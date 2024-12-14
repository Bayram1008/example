import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/new_document.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';
import 'package:open_file/open_file.dart';

class EmployeeDoc extends StatefulWidget {
  List<Document>? employeeDocuments;
  final int? id;
  EmployeeDoc({super.key,required this.employeeDocuments, required this.id});

  @override
  State<EmployeeDoc> createState() => _EmployeeDocState();
}

class _EmployeeDocState extends State<EmployeeDoc> {
  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();

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
          'Documents of Employee',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body:
          widget.employeeDocuments!.isEmpty
              ? Center(
                child: Text(
                  'There is no any documents',
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                size: 24.0,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            IconButton(
                              onPressed: () async {
                                await apiService.deleteDocument(
                                  widget.employeeDocuments![index].id,
                                  await tokenService.getAccessToken(),
                                );
                                final newDocuments = await apiService
                                    .getDocuments(
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=> NewDocument(id: widget.id,),),);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
