import 'package:flutter/material.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';

class UserProfile extends StatefulWidget {
  final int selectedLanguageIndex;
  UserProf? userProf;
  UserProfile(
      {super.key, required this.userProf, required this.selectedLanguageIndex});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final formKey = GlobalKey<FormState>();
  final Translation translation = Translation();
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
      String? accessToken, String password, int? id) async {
    if (newPasswordController.text == confirmPasswordController.text) {
      await apiService.updateUserProfile(accessToken, password, id);
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
            translation.passwordAndConfirm[widget.selectedLanguageIndex],
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
          translation.userInformation[widget.selectedLanguageIndex],
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
                '${widget.userProf?.firstName} ${widget.userProf?.lastName}',
                style: TextStyle(color: Colors.black, fontSize: 24.0),
              ),
              subtitle: Text('Login : ${widget.userProf?.login}', style: TextStyle(fontSize: 16.0, color: Colors.black),),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(
          //       Icons.security,
          //       color: Colors.black,
          //       size: 24.0,
          //     ),
          //     title: Text(
          //       widget.userProf!.password,
          //       style: TextStyle(color: Colors.black, fontSize: 24.0),
          //     ),
          //   ),
          // ),
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
                  key: formKey,
                  child: Center(
                    child: ListView(
                      children: [
                        // TextFormField(
                        //   controller: newUsernameController,
                        //   decoration: InputDecoration(
                        //     labelText: translation.username[widget.selectedLanguageIndex],
                        //     border: const OutlineInputBorder(),
                        //   ),
                        // ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: hidePassword,
                          decoration: InputDecoration(
                            labelText: translation
                                .newPassword[widget.selectedLanguageIndex],
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: Icon(hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: hideConfirmPassword,
                          decoration: InputDecoration(
                            labelText: translation
                                .confirmPassword[widget.selectedLanguageIndex],
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                              icon: Icon(hideConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (confirmPasswordController.text !=
                                newPasswordController.text) {
                              return translation.enterConfirmPassword[
                                  widget.selectedLanguageIndex];
                            }
                            return null;
                          },
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
                                translation
                                    .cancelButton[widget.selectedLanguageIndex],
                                style: TextStyle(
                                    color: Colors.red, fontSize: 20.0),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  UserProf newUserInfo = UserProf(
                                      password: newPasswordController.text,
                                      );
                                  editUserProfile(
                                      await tokenService.getAccessToken(),
                                      newUserInfo.password,
                                      widget.userProf!.id);
                                  clear();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.redAccent,
                                      content: Text(
                                        translation.fillBoxesCorrectly[widget.selectedLanguageIndex],
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                translation
                                    .editButton[widget.selectedLanguageIndex],
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
