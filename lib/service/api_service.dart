import 'package:dio/dio.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/service/savedData.dart';

List<dynamic> information = [];

final tokenService = TokenService();

class ApiService {
  final Dio dio = Dio();

  ApiService() {
    dio.options.baseUrl = 'http://192.168.4.72/api/';
    dio.options.headers = {'Content-Type': 'application/json'};
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<String?> getToken(
    String usernameController,
    String passwordController,
  ) async {
    try {
      final response = await dio.post(
        'token/',
        data: {'username': usernameController, 'password': passwordController},
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
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
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
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'http://192.168.4.72/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (responce.statusCode == 200) {
        String? newAccessToken = responce.data['access'];
        tokenService.updateAccessToken(newAccessToken!);
        getData(newAccessToken);
      }
    }
    return [];
  }

  Future<void> postData(FormData user, String? accessToken) async {
    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        print('We are in the postData under the dio.options.headers');
        final response = await dio.post(
          'employees/',
          data: user, 
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
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'http://192.168.4.72/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['access'];
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
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'http://192.168.4.72/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['access'];
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
    } else if (accessToken != null) {
      final String? refreshToken = await tokenService.getRefreshToken();
      final responce = await dio.post(
        'http://192.168.4.72/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['access'];
        tokenService.updateAccessToken(newAccessToken);
        updateData(id, newAccessToken, user);
      }
    }
    return;
  }

  Future<List<Employee>> searchUsers(Map<String, String?> query, String? accessToken) async {

    if (accessToken != null && !tokenService.isTokenExpired(accessToken)) {
      try {
        dio.options.headers['Authorization'] = 'Bearer $accessToken';
        final response = await dio.post(
          'employees/search/',
          data: query,
        );
        if (response.statusCode == 200) {
          final fromJson = EmployeeList.fromJson(response.data);
          final result =
              (fromJson.results).map((e) => Employee.fromJson(e)).toList();
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
        'http://192.168.4.72/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      if (responce.statusCode == 200) {
        String newAccessToken = responce.data['access'];
        tokenService.updateAccessToken(newAccessToken);
        searchUsers(query, newAccessToken);
      }
    }
    return [];
  }
}
