import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/Model/User.dart';
import 'package:task/Network_utils/Pages_Network.dart';
import 'package:task/UI/SimilarWidgets.dart';

import '../MyHomePage.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  SimilarWidgets similarWidgets = new SimilarWidgets();
  PagesNetwork pagesNetwork = new PagesNetwork();

  final _formKey = GlobalKey<FormState>();

  ////////////////////////////////////////////////////////////////////////////
  /*Return Coordiantes from geolocator and then take this coordinates to get place */

  String _selectedtype = 'Please choose a type';
  List<String> type = ['Please choose a type', '1', '2', '3', '4'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Container(
        //margin: EdgeInsets.only(top: size.height / 15),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                similarWidgets.buildLogo(size),
                similarWidgets.nameField(nameController, context),

                DropdownButton<String>(
                    value: _selectedtype,
                    items: type.map((val) {
                      return new DropdownMenuItem<String>(
                        value: val,
                        child: new Text(val),
                      );
                    }).toList(),
                    hint: Text("Please choose a type"),
                    onChanged: (newVal) {
                      setState(() {
                        _selectedtype = newVal;
                      });
                    }),

                similarWidgets.phoneField(phoneController),

//-------------------------------Email Field-------------------------------------------------

                Container(
//      padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      hintStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      //suffixIcon: buildEye(visible),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "password_shouldnt_be_empty";
                      } else if (value.length < 6) {
                        return "password_should_be_long";
                      }
                      return null;
                    },
                  ),
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.height / 30,
                      0,
                      MediaQuery.of(context).size.height / 30,
                      MediaQuery.of(context).size.height / 50),
                ),

                Container(
                  child: TextFormField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "The Password cannot be empty";
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          return "Not Matched";
                        }
                        return null;
                      }),
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.height / 30,
                      0,
                      MediaQuery.of(context).size.height / 30,
                      0),
                ),

                Container(
                  margin: EdgeInsets.only(top: size.height / 50),
                  child: FlatButton(
                    onPressed: () {
                      // TODO: implement validate function
                      _onLoading();
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    shape: StadiumBorder(),
                    color: Colors.blue,
                    //splashColor: Colors.indigo,
                    padding: EdgeInsets.fromLTRB(
                        size.width / 8, 15, size.width / 8, 15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onLoading() {
    if (_validateAndSave()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            title: new Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
      new Future.delayed(new Duration(seconds: 5), () {
        //pop dialog
        validateAndSubmit();
      });
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    String userId = "";
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      User newUser = User(
          name: nameController.text,
          type: _selectedtype,
          phoneNumber: phoneController.text,
          password: passwordController.text,
          passwordConfirmation: confirmPasswordController.text);

      User user = await pagesNetwork.createAndForgetUser(
          context, 'http://app.4-cars.sa/api/auth/signup',
          body: newUser.toMap());
      print(newUser.toMap());
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName('/SignUp'));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("idPref", /*3*/ user.userID);
        await prefs.setString("namePref", user.name);
        await prefs.setString("typePref", user.type);
        await prefs.setString("phonePref", user.phoneNumber);
        await prefs.setString("tokenPref", user.accessToken);
      }
    } catch (e) {
      setState(() {
        print(e);
        similarWidgets.showDialogWidget(
            "Your account is already existed", context);
      });
    }
  }
}
