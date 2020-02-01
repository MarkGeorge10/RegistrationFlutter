import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RegistrationForm/LoginPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phone, name;

  Future<void> retrieveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    name = prefs.get("namePref");

    phone = prefs.get("phonePref");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      drawer: buildDrawer(context),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(""),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          //body of the drawer

          InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  ModalRoute.withName('/MyHomePage'));
            },
            child: ListTile(
              title: Text("LogOut"),
              leading: Icon(
                Icons.exit_to_app,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
