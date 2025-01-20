import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/translation.dart';

class EmployeeInfo extends StatelessWidget {
  final int selectedLanguageIndex;
  final Employee employeeInformation;
  EmployeeInfo({super.key, required this.employeeInformation, required this.selectedLanguageIndex});
  Translation translation = Translation();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popUntil(context, (route)=>route.isFirst);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey[300],
        title: Text(
          translation.employeeInfo[selectedLanguageIndex],
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Container(
            height: 250.0,
            width: 250.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(employeeInformation.avatar!.toString()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                '${employeeInformation.firstName} ${employeeInformation.lastName}',
              ),
              subtitle: Text(employeeInformation.position),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.mail),
              title: Text(translation.emailAddress[selectedLanguageIndex]),
              subtitle: Text(employeeInformation.email!),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: Text(translation.phoneNumber[selectedLanguageIndex]),
              subtitle: Text(' ${employeeInformation.phoneNumber}'),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(translation.birthDay[selectedLanguageIndex]),
              subtitle: Text(
                employeeInformation.birthDate,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(translation.resignedDate[selectedLanguageIndex]),
              subtitle: Text(
                employeeInformation.resignDate ?? translation.thereIsNoResignedDate[selectedLanguageIndex],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(translation.hiredDate[selectedLanguageIndex]),
              subtitle: Text(
                employeeInformation.hireDate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class EmployeeInfo extends StatelessWidget {
//   final Employee employeeInfo;
//   List<Document>? employeeDocuments;
//   EmployeeInfo({super.key, required this.employeeInfo, this.employeeDocuments});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.popUntil(context, (route) => route.isFirst);
//             },
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//           ),
//           backgroundColor: Colors.blueGrey[300],
//           title: const Text(
//             'Employee Information',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//           bottom: TabBar(
//             tabs: [
//               Icon(Icons.info, color: Colors.blueAccent),
//               Icon(Icons.message, color: Colors.blueAccent),
//             ],
//           ),
//         ),
//         body: UserInformation(employeeInformation: employeeInfo,),
//         // body: TabBarView(
//         //   children: [
//         //     UserInformation(employeeInformation: employeeInfo),
//         //     UserDocumation(employeeDocs: employeeDocuments, id: employeeInfo.id,),
//         //   ],
//         // ),
//       ),
//     );
//   }
// }

// class UserInformation extends StatelessWidget {
//   final Employee employeeInformation;
//   UserInformation({super.key, required this.employeeInformation});

//   late final DateTime? timeData = employeeInformation.resignDate;

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.all(8.0),
//       children: [
//         Container(
//           height: 250.0,
//           width: 250.0,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               image: NetworkImage(employeeInformation.avatar!.toString()),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20.0),
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.person),
//             title: Text(
//               '${employeeInformation.firstName} ${employeeInformation.lastName}',
//             ),
//             subtitle: Text(employeeInformation.position),
//           ),
//         ),
//         const SizedBox(height: 20.0),
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.mail),
//             title: const Text('Email address'),
//             subtitle: Text(employeeInformation.email!),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.phone),
//             title: const Text('Phone number'),
//             subtitle: Text(employeeInformation.phoneNumber),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.date_range),
//             title: const Text('Birth day'),
//             subtitle: Text(
//               DateFormat('dd/MM/yyyy').format(employeeInformation.birthDate),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.date_range),
//             title: const Text('Resign Date'),
//             subtitle: Text(
//               timeData == null
//                   ? 'There is no resignDate'
//                   : DateFormat('dd/MM/yyyy').format(timeData!),
//             ),
//           ),
//         ),
//         const SizedBox(height: 16.0),
//         Card(
//           child: ListTile(
//             leading: const Icon(Icons.date_range),
//             title: const Text('Hired date'),
//             subtitle: Text(
//               DateFormat('dd/MM/yyyy').format(employeeInformation.hireDate),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class UserDocumation extends StatefulWidget {
//   final int? id;
//   List<Document>? employeeDocs;
//   UserDocumation({super.key, required this.employeeDocs,required this.id});

//   @override
//   State<UserDocumation> createState() => _UserDocumationState();
// }

// class _UserDocumationState extends State<UserDocumation> {
//   final ApiService apiService = ApiService();

//   final TokenService tokenService = TokenService();

//   void showOpenWithBottomSheet(BuildContext context, String? filePath) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.file_open),
//                 title: Text('Open with default app'),
//                 onTap: () async {
//                   final result = await OpenFile.open(filePath!);
//                   Navigator.pop(context);
//                   if (result.type != ResultType.done) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to open file')),
//                     );
//                   }
//                 },
//               ),
//               Divider(),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.employeeDocs!.isEmpty
//         ? Center(
//           child: Text(
//             'There is no any Documents',
//             style: TextStyle(
//               color: Colors.deepOrangeAccent,
//               fontSize: 24.0,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         )
//         : ListView.builder(
//           padding: EdgeInsets.all(10.0),
//           itemCount: widget.employeeDocs!.length,
//           itemBuilder: (context, index) {
//             return Card(
//               child: ListTile(
//                 leading: Icon(Icons.note, size: 24.0),
//                 title: Text(widget.employeeDocs![index].name),
//                 subtitle: Text(widget.employeeDocs![index].type),
//                 onTap: () {
//                   showOpenWithBottomSheet(
//                     context,
//                     widget.employeeDocs![index].filePath,
//                   );
//                 },
//                 trailing: SizedBox(
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         onPressed: (){},
//                         icon: Icon(Icons.edit, size: 24.0, color: Colors.green),
//                       ),
//                       const SizedBox(width: 8.0),
//                       IconButton(
//                         onPressed: () async{
//                           await apiService.deleteDocument(widget.employeeDocs![index].id, await tokenService.getAccessToken());
//                           final newDocuments = await apiService.getDocuments(widget.id, await tokenService.getAccessToken());
//                           setState(() {
//                             widget.employeeDocs = newDocuments;
//                           });
//                         },
//                         icon: Icon(Icons.delete, size: 24.0, color: Colors.red),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//   }
// }
