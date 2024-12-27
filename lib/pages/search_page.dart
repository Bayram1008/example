// import 'package:flutter/material.dart';
// import 'package:new_project/model/user_model.dart';
// import 'package:new_project/pages/user_info.dart';
// import 'package:new_project/service/api_service.dart';
// import 'package:new_project/service/savedData.dart';

// class UserSearchPage extends StatefulWidget {
//   @override
//   _UserSearchPageState createState() => _UserSearchPageState();
// }

// class _UserSearchPageState extends State<UserSearchPage> {
//   final ApiService apiService = ApiService();
//   final TextEditingController _searchController = TextEditingController();
//   final TokenService tokenService = TokenService();
//   List<Employee> employees = [];
//   bool _isLoading = false;

//   void _searchUsers(Map<String, String?> query) async {
//     if (query.isEmpty) {
//       setState(() {
//         employees = [];
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final users = await apiService.searchEmployeesInPostData(
//         query,
//         await tokenService.getAccessToken(),
//       );
//       setState(() {
//         employees = users;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Search Users")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Users',
//                 border: OutlineInputBorder(),
//                 suffixIcon:
//                     _isLoading
//                         ? CircularProgressIndicator()
//                         : IconButton(
//                           icon: Icon(Icons.clear),
//                           onPressed: () {
//                             _searchController.clear();
//                             _searchUsers;
//                           },
//                         ),
//               ),
//               onChanged: (_){
//                // _searchUsers(query);
//               },
//             ),
//           ),
//           Expanded(
//             child:
//                 employees.isEmpty
//                     ? Center(child: Text('No users found'))
//                     : ListView.builder(
//                       itemCount: employees.length,
//                       itemBuilder: (context, index) {
//                         final user = employees[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) =>
//                                         EmployeeInfo(employeeInformation: user),
//                               ),
//                             );
//                           },
//                           child: ListTile(
//                             title: Text('${user.firstName} ${user.lastName}'),
//                             subtitle: Text(user.position),
//                           ),
//                         );
//                       },
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }
