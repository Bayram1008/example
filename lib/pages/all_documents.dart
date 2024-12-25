import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/doc_info.dart';
import 'package:new_project/pages/edit_document.dart';
import 'package:new_project/service/api_service.dart';
import 'package:open_file/open_file.dart';

class AllDocuments extends StatefulWidget {
  List<Document>? documents;
  AllDocuments({super.key, required this.documents});

  @override
  State<AllDocuments> createState() => _AllDocumentsState();
}

class _AllDocumentsState extends State<AllDocuments> {
  ApiService apiService = ApiService();

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
    Future<String> getEmployeeName(int index) async {
    final employeeName = await apiService.getEmployeeById(await tokenService.getAccessToken(), widget.documents![index].employee);
    return employeeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Documents'),
        centerTitle: true,
      ),
      body: widget.documents!.isEmpty
          ? Center(
              child: Text('There is no any Documents'),
            )
          : ListView.builder(
              itemCount: widget.documents!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.note, size: 24.0),
                    title: Text(widget.documents![index].name),
                    subtitle: Text(widget.documents![index].type),
                    onTap: () async{
                      final employeeName = await getEmployeeName(index);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> DocInfo(documentInfo: widget.documents![index], employeeName: employeeName,),),);
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
                                  widget.documents![index].name,
                                  widget.documents![index].filePath, context);
                            },
                            icon: Icon(
                              Icons.download,
                              size: 24.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditDocument(
                                    editDocument: widget.documents![index],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 24.0,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await apiService.deleteDocument(
                                widget.documents![index].id,
                                await tokenService.getAccessToken(),
                              );
                              final newDocuments =
                                  await apiService.getEmployeeDocuments(
                                widget.documents![index].id,
                                await tokenService.getAccessToken(),
                              );
                              setState(() {
                                widget.documents = newDocuments;
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
    );
  }
}
