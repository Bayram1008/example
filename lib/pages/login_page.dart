import 'package:flutter/material.dart';
import 'package:new_project/pages/user_list.dart';
import 'package:new_project/service/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final service = ApiService();

  bool hidePassword = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameFocus = FocusNode();
  final passwordFocus = FocusNode();

  void changeField(
      BuildContext context, FocusNode currentField, FocusNode nextField) {
    currentField.unfocus();
    FocusScope.of(context).requestFocus(nextField);
  }

  @override
  void dispose() {
    super.dispose();
    nameFocus.dispose();
    passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50.0,
                child: Icon(
                  Icons.person,
                  size: 50.0,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextFormField(
                focusNode: nameFocus,
                //autofocus: true,
                onFieldSubmitted: (_) {
                  changeField(context, nameFocus, passwordFocus);
                },
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextFormField(
                obscureText: hidePassword,
                focusNode: passwordFocus,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextButton(
                onPressed: () async {
                  final token = await service.getToken(usernameController.text, passwordController.text);
                  final employeeList = await service.getData(token);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserList(
                        employeeList: employeeList,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
