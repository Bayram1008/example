import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/doc_info.dart';
import 'package:new_project/pages/edit_document.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/service/api_service.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AllDocuments extends StatefulWidget {
  final int selectedLanguageIndex;
  List<Document>? documents;
  AllDocuments(
      {super.key,
      required this.documents,
      required this.selectedLanguageIndex});

  @override
  State<AllDocuments> createState() => _AllDocumentsState();
}

class _AllDocumentsState extends State<AllDocuments> {
  Translation translation = Translation();
  ApiService apiService = ApiService();
  final Dio dio =Dio();

  bool isDownloading = false;
  double downloadProgress = 0.0;

  Future<void> downloadDocument(
      String? accessToken, String filename, String? filePath) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are in the downloadDocument under the dio.options.headers');
        final status = await Permission.storage.request();
        if (status.isGranted) {
          print ('Hello Abdulla!!!!');
          final directory = Directory('/storage/emulated/0/Download');
          final exPath = directory.path;
          await Directory(exPath).create(recursive: true);
          if (directory != null) {
            final savedPath = "${directory.path}/$filename";
            setState(() {
              isDownloading = true;
            });
            final response = await dio.download(filePath!, savedPath,
                onReceiveProgress: (received, total) {
              setState(() {
                downloadProgress = received / total;
              });
            });
            setState(() {
              isDownloading = false;
              downloadProgress = 0.0;
            });
            print('Document downloaded successfully to $savedPath');
             if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Colors.green,
              content: Text(
                'Downloaded Succesfully',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
            ),
          );
          print('Document downloaded successfully to $filePath');
        } else {
          print('Failed to download document: ${response.data}');
        }
          }
        }
      } catch (e) {
        print('Error in postDocumentToEmployee: $e');
        throw Exception('Failed to post data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'http://192.168.4.72:81/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['access'];
        tokenService.updateAccessToken(newAccessToken);
        downloadDocument(newAccessToken, filename, filePath);
      }
    }
  }

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
    final employeeName = await apiService.getEmployeeById(
        await tokenService.getAccessToken(), widget.documents![index].employee);
    return employeeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation.allDocuments[widget.selectedLanguageIndex]),
        centerTitle: true,
      ),
      body: widget.documents!.isEmpty
          ? Center(
              child: Text(translation
                  .thereIsNoAnyDocument[widget.selectedLanguageIndex]),
            )
          : ListView.builder(
              itemCount: widget.documents!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.note, size: 24.0),
                    title: Text(widget.documents![index].name),
                    subtitle: Text(widget.documents![index].type),
                    onTap: () async {
                      final employeeName = await getEmployeeName(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DocInfo(
                            documentInfo: widget.documents![index],
                            employeeName: employeeName,
                            selectedLanguageIndex: widget.selectedLanguageIndex,
                          ),
                        ),
                      );
                    },
                    trailing: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              downloadDocument(
                                  await tokenService.getAccessToken(),
                                  widget.documents![index].name,
                                  widget.documents![index].filePath);
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
                                    selectedLanguageIndex:
                                        widget.selectedLanguageIndex,
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
