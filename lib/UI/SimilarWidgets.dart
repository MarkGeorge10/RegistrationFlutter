import 'package:flutter/material.dart';

class SimilarWidgets {
  void showDialogWidget(String str, BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: new Text(str),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget nameField(TextEditingController nameCon, BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.height / 30,
          0,
          MediaQuery.of(context).size.height / 30,
          MediaQuery.of(context).size.height / 50),
      child: TextFormField(
        controller: nameCon,
        obscureText: false,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          labelText: "Full Name",
          hintText: "Full Name",
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),

          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) {
            return "Full Name shouldn't be empty";
          }
          return null;
        },
      ),
    );
  }

  Widget phoneField(TextEditingController phoneCon) {
    return Container(
      margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
      child: TextFormField(
        controller: phoneCon,
        obscureText: false,
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          labelText: "Phone Number",
          hintText: "Phone Number",
          hintStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),

          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) {
            return "Phone Number shouldn't be empty";
          } else if (value.length < 11) {
            return "Phone Number must be 11 digits";
          }
          return null;
        },
      ),
    );
  }

  Widget buildLogo(Size size) {
    return Container(
      child: Image.asset(
        "img/logo.png",
        height: size.height / 4,
        width: size.width / 2,
      ),
//      margin: EdgeInsets.all(20),
    );
  }

  Widget emptyPage(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Page is Empty",
              style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
