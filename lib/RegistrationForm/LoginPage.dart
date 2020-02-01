import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/Model/User.dart';
import 'package:task/Network_utils/Pages_Network.dart';
import 'package:task/UI/SimilarWidgets.dart';

import '../MyHomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  SimilarWidgets similarWidgets = new SimilarWidgets();
  PagesNetwork pagesNetwork = new PagesNetwork();
  bool passwordVisibility = false;
  String _selectedtype = 'Please choose a type';
  List<String> type = ['Please choose a type', '1', '2', '3', '4'];
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                similarWidgets.buildLogo(size),

//-------------------------------Email Field-------------------------------------------------
                similarWidgets.phoneField(phoneController),
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
                //------------------------------------------------------------------------------------
                passwordFormField(passwordVisibility),
                buildForgotPassword(),
                buildLoginButton(size),
                buildSignUpText(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordFormField(bool visible) {
    return Container(
//      padding: EdgeInsets.only(left: 20, right: 15),
      child: TextFormField(
        obscureText: !visible,
        controller: passwordController,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Password",
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          suffixIcon: buildEye(visible),
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
          MediaQuery.of(context).size.height / 100),
    );
  }

  Widget buildLoginButton(Size size) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height / 30,
          bottom: MediaQuery.of(context).size.height / 60),
      child: FlatButton(
        onPressed: () {
          // TODO: implement validate function
          _onLoading();
        },
        child: Text(
          "Sign In",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        shape: StadiumBorder(),
        color: Colors.blue,
        //splashColor: Colors.indigo,
        padding: EdgeInsets.fromLTRB(size.width / 8, 15, size.width / 8, 15),
      ),
    );
  }

  Widget buildSignUpText(Size size) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Don't Have an account yet, "),
          InkWell(
            child: Text(
              "SignUp Now",
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () {
              //Navigator.pop(context);
              Navigator.pushNamed(context, '/SignUp');
            },
          )
        ],
      ),
    );
  }

  Widget buildEye(bool visible) {
    return IconButton(
        icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            passwordVisibility = !passwordVisibility;
          });
        });
  }

  Widget buildForgotPassword() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 45),
      child: Align(
          child: InkWell(
            child: Text(
              "Forgot Password?!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, '/ForgetPassword'),
          ),
          alignment: Alignment.centerLeft),
    );
  }

  Future<bool> forgotPassword() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('You Really Forgot Your Password?!!!'),
            content: new Text('Are you really that dumb?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
            ],
          ),
        ) ??
        false;
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
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      User newUser = User(
        type: _selectedtype,
        phoneNumber: phoneController.text,
        password: passwordController.text,
      );

      User user = await pagesNetwork.createAndForgetUser(
          context, 'http://app.4-cars.sa/api/auth/login',
          body: newUser.toLogin());
      print(newUser.toMap());
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName('/LoginPage'));
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
        similarWidgets.showDialogWidget(e, context);
      });
    }
  }

  /*Future<void> validateForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      User newUser = User(
          token: "hVF4CVDlbuUg18MmRZBA4pDkzuXZi9Rzm5wYvSPtxvF8qa8CK9GiJqMXdAMv",
          email: emailController.text,
          password: passwordController.text);

      User user = await pagesNetwork.userLogin(
          context, 'http://mr-fix.org/en/api/login',
          body: newUser.toLogin());

      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
            ModalRoute.withName('/LoginPage'));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("idPref", /*3*/ user.userID);
        await prefs.setString("namePref", user.name);
        await prefs.setString("emailPref", user.email);
        await prefs.setString("phonePref", user.phoneNumber);
        await prefs.setString("passwordPref", passwordController.text);
        await prefs.setString("tokenPref", user.token);
        await prefs.setString("locationPref", user.location);
      } else {
        similarWidgets.showDialogWidget(
            "make_sure_of_email_or_password", context);
      }

      formState.reset();
    }
  }*/
}
