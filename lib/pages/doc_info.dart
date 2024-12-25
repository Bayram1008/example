import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';

class DocInfo extends StatelessWidget {
  final String employeeName;
  final Document documentInfo;
  const DocInfo({super.key, required this.documentInfo, required this.employeeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[500],
        title: Text('Document Information', style: TextStyle(color: Colors.white, fontSize: 24.0),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.person, color: Colors.white, size: 20.0,),
              title: Text(employeeName),
            ),
          ),
          SizedBox(height: 16.0,),
          Card(
            child: ListTile(
              leading: Icon(Icons.info, color: Colors.white, size: 20.0,),
              title: Text(documentInfo.type),
            ),
          ),
          SizedBox(height: 16.0,),
          Card(
            child: ListTile(
              leading: Icon(Icons.folder, color: Colors.white, size: 20.0,),
              title: Text(documentInfo.name),
            ),
          ),
        ],
      ),
    );
  }
}