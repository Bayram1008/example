import 'dart:io';

import 'package:dio/dio.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/service/savedData.dart';

List<dynamic> information = [];

final tokenService = TokenService();

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options.baseUrl = 'http://192.168.4.58/api/v1/';
    dio.options.headers = {'Content-Type': 'application/json'};
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<String> getToken(
    String usernameController,
    String passwordController,
  ) async {
    try {
      print('hello world');
      final response = await dio.post(
        'auth/login',
        data: {"login": usernameController, "password": passwordController},
      );
      print('We are below of the post method: $response');

      if (response.statusCode == 200) {
        final data = response.data;
        print('$data');
        final newData = Login.fromJson(data);
        print('Everything is ok in getToken: ${newData.data}');
        final tokens = newData.data;
        print('The variable tokens: $tokens');
        await tokenService.saveTokens(tokens["accessToken"], tokens["refreshToken"]);
        print('${tokens["accessToken"]}');
        return tokens["accessToken"];
      } else {
        throw Exception('Something went wrong in getToken');
      }
    } catch (e) {
      print('Error in getToken: $e');
      throw Exception('Failed to retrieve token');
    }
  }

  Future<List<Employee>?> getData(String? accessToken, int page, int? limit) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      print(accessToken);
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are below of the dio.options.headers');
        var response;
        if (limit == null) {
          response = await dio.get('employee', queryParameters:{'page': page});
        }else{
          response = await dio.get('employee', queryParameters: {'limit': limit, 'page': page});
        }

        print('We are in getData');

        if (response.statusCode == 200) {
          print(response.statusCode);
          final information = response.data;
          print(information);
          final list = EmployeeList.fromJson(information);
          print('Bu list: ${list}');
          final netije = list.data!.map((e) => Employee.fromJson(e)).toList();
          print('Bu netije: ${netije}');
          return netije;
        } else {
          throw Exception('Something went wrong in getData');
        }
      } catch (e) {
        print('Error in getData: $e');
        throw Exception('Failed to fetch data');
      }
    } else if (tokenService.isTokenExpired(accessToken!)) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String? newAccessToken = responce.data['accessToken'];
        print(newAccessToken);
        tokenService.updateAccessToken(newAccessToken!);
        getData(newAccessToken, page, limit);
      }
    }
    return [];
  }

  Future<void> postData(FormData user, String? accessToken) async {
    print('we are in the postData method');
    print('the accesstoken in postData method : $accessToken');
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers = {'Content-Type': 'multipart/form-data'};
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        final response = await dio.post(
          'employee', 
          data: user,
        );
        print('We just post the user');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Employee added successfully');
        } else {
          print('Failed to add employee: ${response.data}');
        }
      } catch (error){
        print('Error in postData: $error');
        throw Exception('Failed to post data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        '/auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        postData(user, newAccessToken);
      }
    }
    return;
  }

  Future<void> deleteData(String id, String? accessToken) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';

        final response = await dio.delete('employee/$id');

        if (response.statusCode == 200 || response.statusCode == 204) {
          print('Data with ID $id deleted successfully');
        } else {
          print('Failed to delete data: ${response.data}');
        }
      } catch (error) {
        print('Error in deleteData: $error');
        throw Exception('Failed to delete data: $error');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        deleteData(id, newAccessToken);
      }
    }
    return;
  }

  Future<void> updateData(String id, String? accessToken, FormData user) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';

        final response = await dio.patch('employee/$id', data: user);

        if (response.statusCode == 200 || response.statusCode == 204) {
          print('Data is updated successfully');
        } else {
          print('Failed to delete data: ${response.data}');
        }
      } catch (e) {
        print('Error in updateData: $e');
        throw Exception('Failed to update data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        updateData(id, newAccessToken, user);
      }
    }
    return;
  }

  Future<List<Employee>> searchEmployeesInPostData(
      Map<String, String?> query, String? accessToken) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        final response = await dio.post(
          'employee/search',
          data: query,
        );
        if (response.statusCode == 200) {
          final fromJson = EmployeeList.fromJson(response.data);
          final result =
              (fromJson.data!).map((e) => Employee.fromJson(e)).toList();
          return result;
        } else {
          throw Exception('Failed to load users');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        searchEmployeesInPostData(query, newAccessToken);
      }
    }
    return [];
  }

  // Future<List<Employee>> searchEmployeesInGetData(
  //     String? query, String? accessToken) async {
  //   print('we are just in the searchEmployeesInGetData');
  //   if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
  //     print('we are just in the condition');
  //     try {
  //       dio.options.headers['Authorization'] = 'Bearer $accessToken';

  //       print('We are in getData');
  //       final response =
  //           await dio.get('employee/', queryParameters: {'filter': query});

  //       if (response.statusCode == 200) {
  //         final fromJson = EmployeeList.fromJson(response.data);
  //         final result =
  //             (fromJson.data!).map((e) => Employee.fromJson(e)).toList();
  //         return result;
  //       } else {
  //         throw Exception('Something went wrong in getData');
  //       }
  //     } catch (e) {
  //       print('Error in getData: $e');
  //       throw Exception('Failed to fetch data');
  //     }
  //   } else if (accessToken != null) {
  //     final String? refreshToken = await tokenService.getRefreshToken();
  //     final responce = await dio.post(
  //       'auth/token',
  //       data: {'refreshtoken': refreshToken},
  //     );
  //     if (responce.statusCode == 200) {
  //       String? newAccessToken = responce.data['access'];
  //       tokenService.updateAccessToken(newAccessToken!);
  //       searchEmployeesInGetData(newAccessToken, query);
  //     }
  //   }
  //   return [];
  // }

  Future<List<Document>?> getEmployeeDocuments(
      int? id, String? accessToken) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      print(accessToken);
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';

        print('We are in getData');
        final response = await dio.get('employee/$id');

        if (response.statusCode == 200) {
          print(response.statusCode);
          final information = response.data;
          print(information['data']);
          final list = EmployeeList.fromJson(information['data']);
          print('Bu list: ${list}');
          final netije =
              list.documents?.map((e) => Document.fromJson(e)).toList();
          print('Bu netije: $netije');
          return netije;
        } else {
          throw Exception('Something went wrong in getData');
        }
      } catch (e) {
        print('Error in getData: $e');
        throw Exception('Failed to fetch data');
      }
    } else if (tokenService.isTokenExpired(accessToken!)) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String? newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken!);
        getEmployeeDocuments(id, newAccessToken);
      }
    }
    return [];
  }

  Future<void> deleteDocument(int? id, String? accessToken) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';

        final response = await dio.delete('doc/$id');

        if (response.statusCode == 200 || response.statusCode == 204) {
          print('Data with ID $id deleted successfully');
        } else {
          print('Failed to delete data: ${response.data}');
        }
      } catch (e) {
        print('Error in deleteData: $e');
        throw Exception('Failed to delete data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        deleteDocument(id, newAccessToken);
      }
    }
    return;
  }

  Future<void> postDocument(
      String? accessToken, FormData query) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers = {'Content-Type': 'multipart/form-data'};
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are in the postData under the dio.options.headers');
        final response = await dio.post(
          'doc',
          data: query,
        );
        print('We just post the user');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Document added successfully');
        } else {
          print('Failed to add document: ${response.data}');
        }
      } catch (e) {
        print('Error in postDocumentToEmployee: $e');
        throw Exception('Failed to post data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        postDocument(newAccessToken, query);
      }
    }
  }

  Future<List<Document>?> getAllDocuments(String? accessToken, int limit, int page) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      print(accessToken);
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';

        print('We are in getData');
        final response = await dio.get('doc', queryParameters: {"limit" : limit, "page" : page});

        if (response.statusCode == 200) {
          print(response.statusCode);
          final information = response.data;
          print(information);
          final list = Documents.fromJson(information);
          print('Bu list: $list');
          final netije = list.data!.map((e) => Document.fromJson(e)).toList();
          return netije;
        } else {
          throw Exception('Something went wrong in getData');
        }
      } catch (e) {
        print('Error in getData: $e');
          throw Exception('Failed to fetch data');
      }
    } else if (tokenService.isTokenExpired(accessToken!)) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String? newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken!);
        getAllDocuments(newAccessToken, limit, page);
      }
    }
    return [];
  }

  Future<void> updateDocument(
      String? accessToken, Document newDocument) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are in the postData under the dio.options.headers');
        final response = await dio.put(
          'doc/${newDocument.id}',
          data: {
            "employee_id" : newDocument.employee,
            "expiry_date" : newDocument.expiredDate,
            "name" : newDocument.name,
            "type" : newDocument.type
          },
        );
        print('We just post the user');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Document added successfully');
        } else {
          print('Failed to add document: ${response.data}');
        }
      } catch (e) {
        print('Error in postDocumentToEmployee: $e');
        throw Exception('Failed to post data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        updateDocument(newAccessToken, newDocument);
      }
    }
  }
  Future<String> getEmployeeById(String? accessToken, int? id) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      print(accessToken);
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are below of dio.options.headers and id is : $id');
        final response =await dio.get('employee/$id');

        print('We are in getData');

        if (response.statusCode == 200) {
          final information = response.data;
          print('the variable information is :$information');
          final list = Employee.fromJson(information["data"]);
          print('Bu list: ${list}');
          final netije = '${list.firstName} ${list.lastName}';
          print('Bu netije: ${netije}');
          return netije;
        } else {
          throw Exception('Something went wrong in getData');
        }
      } catch (e) {
        print('Error in getEmployeeById: $e');
        throw Exception('Failed to fetch data');
      }
    } else if (tokenService.isTokenExpired(accessToken!)) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String? newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken!);
        getEmployeeById(newAccessToken, id);
      }
    }
    return '';
  }
  Future<UserProf?> getUserInfo(String? accessToken)async{
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      print(accessToken);
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';

        final response =await dio.get('auth');

        print('We are in getUserInfo');

        if (response.statusCode == 200) {
          final information = response.data;
          print(information);
          final list = UserProf.fromJson(information["data"]);
          print('Bu list: ${list.id}');
          return list;
        } else {
          throw Exception('Something went wrong in getUserInfo');
        }
      } catch (e) {
        print('Error in getData: $e');
        throw Exception('Failed to fetch data');
      }
    } else if (tokenService.isTokenExpired(accessToken!)) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String? newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken!);
        getUserInfo(newAccessToken);
      }
    }
    return null;
  }
  Future<void> updateUserProfile(
      String? accessToken, String password, int? id) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are in the postData under the dio.options.headers');
        print('user_id is: $id');
        final response = await dio.patch(
          'auth/$id',
          data: {'password':password},
        );
        print('We just post the user');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Document added successfully');
        } else {
          print('Failed to add document: ${response.data}');
        }
      } catch (e) {
        print('Error in postDocumentToEmployee: $e');
        throw Exception('Failed to post data');
      }
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'auth/token',
        data: {'refreshToken': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['accessToken'];
        tokenService.updateAccessToken(newAccessToken);
        updateUserProfile(newAccessToken, password, id);
      }
    }
  }
}
