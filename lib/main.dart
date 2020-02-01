import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MyHomePage.dart';
import 'Preferences/Perference.dart';
import 'RegistrationForm/LoginPage.dart';
import 'RegistrationForm/SignUp.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: Preference.getID(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                return MyHomePage();
              }
              return LoginPage();
            }),
        routes: {
          '/SignUp': (context) => SignUp(),
          '/LoginPage': (context) => LoginPage(),

          //'/MapPage': (context) => MapPage(),
        });
  }
}
