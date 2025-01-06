import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/doc_info.dart';
import 'package:new_project/pages/edit_document.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/service/api_service.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class AllDocuments extends StatefulWidget {
  final int selectedLanguageIndex;
  List<Document>? documents;

  AllDocuments({
    Key? key,
    required this.documents,
    required this.selectedLanguageIndex,
  }) : super(key: key);

  @override
  State<AllDocuments> createState() => _AllDocumentsState();
}

class _AllDocumentsState extends State<AllDocuments> {
  final Translation translation = Translation();
  final ApiService apiService = ApiService();
  final Dio dio = Dio();

  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? documentFormat;

  Future<void> downloadDocument(
      String? accessToken, String filename, String? filePath, String? documentFormat) async {
    if (accessToken == null && filePath == null && filePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid file or access token')),
      );
      return;
    }

    try {
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      final status = await Permission.manageExternalStorage.request();
      
      print('$status');
      if (status.isGranted) {
        print('we are in the status.isGranted');
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }

        final savedPath = "${directory.path}/$filename.$documentFormat";
        setState(() => isDownloading = true);

        final response = await dio.download(filePath!, savedPath,
            onReceiveProgress: (received, total) {
          setState(() => downloadProgress = received / total);
        });

        setState(() {
          isDownloading = false;
          downloadProgress = 0.0;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
              content: Text(
                'Downloaded Successfully to $savedPath',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          );
        } else {
          throw Exception('Failed to download document');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      print('Error during download: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<String> getEmployeeName(int index) async {
    final accessToken = await tokenService.getAccessToken();
    if (accessToken == null || widget.documents == null) return "Unknown";

    return await apiService.getEmployeeById(
        accessToken, widget.documents![index].employee);
  }

  void showOpenWithBottomSheet(BuildContext context, String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File not found')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.file_open),
                title: const Text('Open with default app'),
                onTap: () async {
                  final result = await OpenFile.open(filePath);
                  Navigator.pop(context);
	if (result.type != ResultType.done) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to open file')),
                    );
                  }
                },
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation.allDocuments[widget.selectedLanguageIndex]),
        centerTitle: true,
      ),
      body: widget.documents == null || widget.documents!.isEmpty
          ? Center(
              child: Text(translation
                  .thereIsNoAnyDocument[widget.selectedLanguageIndex]),
            )
          : ListView.builder(
              itemCount: widget.documents!.length,
              itemBuilder: (context, index) {
                final document = widget.documents![index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.note, size: 24.0),
                    title: Text(document.name),
                    subtitle: Text(document.type),
                    onTap: () async {
                      final employeeName = await getEmployeeName(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DocInfo(
                            documentInfo: document,
                            employeeName: employeeName,
                            selectedLanguageIndex: widget.selectedLanguageIndex,
                          ),
                        ),
                      );
                    },
                    trailing: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              List<String> documentData = document.filePath!.split('.');
                              documentFormat = documentData.last;
                              downloadDocument(
                                await tokenService.getAccessToken(),
                                document.name,
                                document.filePath,
                                documentFormat
                              );
                            },
                            icon: const Icon(
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
                                    editDocument: document,
                                    selectedLanguageIndex:
                                        widget.selectedLanguageIndex,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 24.0,
                              color: Colors.green,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await apiService.deleteDocument(
                                document.id,
                                await tokenService.getAccessToken(),
                              );
                              final updatedDocuments =
                                  await apiService.getEmployeeDocuments(
                                document.id,
                                await tokenService.getAccessToken(),
                              );
                              setState(() {
                                widget.documents = updatedDocuments;
                              });
                            },
                            icon: const Icon(
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