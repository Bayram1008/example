import 'package:flutter/material.dart';
import 'package:new_project/pages/login_page.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  TokenService tokenService = TokenService();
  ApiService apiService = ApiService();

  
    Future<void> _checkAccessToken() async {
    Duration(seconds: 3);
    String? accessToken = await tokenService.getAccessToken();

    if (accessToken != null) {
      final employees = await apiService.getData(accessToken, 1, 12);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserList(employeeList: employees,),),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _checkAccessToken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[500],
      body: Center(
        child: Text(
          'You are welcome',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
    );
  }
}
