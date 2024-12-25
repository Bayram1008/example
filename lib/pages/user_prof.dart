import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class UserProfile extends StatefulWidget {
  UserProf? userProf;
  UserProfile({super.key, required this.userProf});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newUsernameController = TextEditingController();
  ApiService apiService = ApiService();
  TokenService tokenService = TokenService();
  @override
  void dispose() {
    super.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newUsernameController.dispose();
  }

  void clear() {
    newUsernameController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  Future<void> editUserProfile(
      String? accessToken, String? username,String password , int? id) async {
    if (newPasswordController.text == confirmPasswordController.text) {
      await apiService.updateUserProfile(accessToken, username, password, id);
      final newUserProf =
          await apiService.getUserInfo(await tokenService.getAccessToken());
      setState(() {
        widget.userProf = newUserProf;
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
          content: Text(
            'Password and Confirm Password are not same',
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text(
          'User Information',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.black,
                size: 24.0,
              ),
              title: Text(
                '${widget.userProf?.username}',
                style: TextStyle(color: Colors.black, fontSize: 24.0),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.security,
                color: Colors.black,
                size: 24.0,
              ),
              title: Text(
                widget.userProf!.password,
                style: TextStyle(color: Colors.black, fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Center(
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: newUsernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            labelText: 'Enter Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: hideConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                              icon: Icon(hideConfirmPassword ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                clear();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 20.0),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                UserProf newUserInfo = UserProf(
                                    password: newPasswordController.text,
                                    username: newUsernameController.text);
                                    editUserProfile(await tokenService.getAccessToken(), newUserInfo.username, newUserInfo.password, widget.userProf!.id);
                              },
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.edit,
          size: 20.0,
        ),
      ),
    );
  }
}