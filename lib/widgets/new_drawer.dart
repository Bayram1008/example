import 'package:flutter/material.dart';
import 'package:new_project/pages/login_page.dart';
import 'package:new_project/pages/translation.dart';
import 'package:new_project/pages/user_prof.dart';
import 'package:new_project/service/api_service.dart';
import 'package:new_project/service/savedData.dart';
import 'package:new_project/widgets/provider.dart';
import 'package:provider/provider.dart';

class NewDrawer extends StatefulWidget {
  const NewDrawer({super.key});

  @override
  State<NewDrawer> createState() => _NewDrawerState();
}

class _NewDrawerState extends State<NewDrawer> {
  Translation translation = Translation();
  ApiService apiService = ApiService();
  TokenService tokenService = TokenService();
  bool selectedAnimatedProfileIndex = false;
  ChangeIndex changeIndex = ChangeIndex();
  @override
  void dispose() {
    changeIndex.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => changeIndex,
      child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text(translation.profile[changeIndex.selectedLanguageIndex]),
                  onTap: () async {
                    final user = await apiService
                        .getUserInfo(await tokenService.getAccessToken());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfile(
                          userProf: user,
                          selectedLanguageIndex: changeIndex.selectedLanguageIndex,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnimatedProfileIndex = !selectedAnimatedProfileIndex;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: selectedAnimatedProfileIndex ? 120 : 65,
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.translate,
                          ),
                          title: Text(
                            translation.changeLanguage[changeIndex.selectedLanguageIndex],
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      if (selectedAnimatedProfileIndex)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  changeIndex.selectTurkmen;
                                  print('Turkmen is selected');
                                },
                                child: Text(
                                  translation.turkmen[changeIndex.selectedLanguageIndex],
                                  style: TextStyle(),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  changeIndex.selectEnglish;
                                  print('English is selected');
                                },
                                child: Text(
                                  translation.english[changeIndex.selectedLanguageIndex],
                                  style: TextStyle(),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(translation.logoutButton[changeIndex.selectedLanguageIndex]),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(translation.hint[changeIndex.selectedLanguageIndex]),
                          content:
                              Text(translation.message[changeIndex.selectedLanguageIndex]),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    translation.noButton[changeIndex.selectedLanguageIndex],
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    tokenService.clearTokens();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    translation.okButton[changeIndex.selectedLanguageIndex],
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}