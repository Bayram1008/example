import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/savedData.dart';

List<dynamic> information = [];

final tokenService = TokenService();

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    // Set default options for Dio
    dio.options.baseUrl = 'http://192.168.4.72/api/';
    dio.options.headers = {'Content-Type': 'application/json'};
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<String?> getToken(String usernameController, String passwordController) async {
    try {
      final response = await dio.post(
        'token/',
        data: {
          'username': usernameController,
          'password': passwordController,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('Everything is ok in getToken');
        await tokenService.saveTokens(data['access'], data['refresh']);
        return data['access'];
      } else {
        throw Exception('Something went wrong in getToken');
      }
    } catch (e) {
      print('Error in getToken: $e');
      throw Exception('Failed to retrieve token');
    }
  }

  Future<List<Employee>> getData(String? accessToken) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      print('We are in getData');
      final response = await dio.get('employees/');

      if (response.statusCode == 200) {
        print(response.statusCode);
        final information = response.data;
        print(information);
        final list = EmployeeList.fromJson(information);
        print('Bu list: ${list}');
        final netije = list.results.map((e) => Employee.fromJson(e)).toList();
        print('Bu netije: ${netije}');
        return netije;
      } else {
        throw Exception('Something went wrong in getData');
      }
    } catch (e) {
      print('Error in getData: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> postData(FormData user, String? accessToken) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      print('We are in the postData under the dio.options.headers');
      final response = await dio.post(
        'employees/',
        data: user, // Use toJson here
      );
      print('We just post the user');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Employee added successfully');
      } else {
        print('Failed to add employee: ${response.data}');
      }
    } catch (e) {
      print('Error in postData: $e');
      throw Exception('Failed to post data');
    }
  }

  Future<void> deleteData(String id, String? accessToken) async {
  try {
    // Add Authorization header
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Send DELETE request
    final response = await dio.delete('employees/$id/');

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Data with ID $id deleted successfully');
    } else {
      print('Failed to delete data: ${response.data}');
    }
  } catch (e) {
    print('Error in deleteData: $e');
    throw Exception('Failed to delete data');
  }
}

Future<void> updateData(String id, String? accessToken, FormData user) async {
  try {
    // Add Authorization header
    dio.options.headers['Authorization'] = 'Bearer $accessToken';

    // Send DELETE request
    final response = await dio.put('employees/$id/', data: user);

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Data is updated successfully');
    } else {
      print('Failed to delete data: ${response.data}');
    }
  } catch (e) {
    print('Error in deleteData: $e');
    throw Exception('Failed to delete data');
  }
}
//avatar: avatarFile != null ? MultipartFile.fromFile(avatarFile!.path).toString() : '',
// try {
//         const token = localStorage.getItem("token");
//         const response = await axios.post(
//           "http://192.168.4.72/api/employees/search/",
//           payload,
//           {
//             headers: {
//               Authorization: `Bearer ${token}`,
//               "Content-Type": "application/json",
//             },
//           }
//         );
//         // Maglumatlary avatarlary bilen sazlamak
//         const enrichedResults = response.data.results.map((employee) => ({
//           ...employee,
//           avatar: employee.avatar || "/default-avatar.jpg", // Default surat
//         }));
//         setSearchQuery({ ...response.data, results: enrichedResults });
//       } catch (error) {
//         console.error("Search failed:", error);
//       }
//     }, 200),
//     [firstName, lastName, hireDateStart, hireDateEnd]
//   );

}
