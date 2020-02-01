import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task/Model/User.dart';
import 'package:task/UI/SimilarWidgets.dart';

class PagesNetwork {
  Future<List<dynamic>> serviceCategories(String url) async {
    try {
      return http.get(url).then((http.Response response) async {
        final String responseBody = response.body;
        List<dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<List<dynamic>> service(String url) async {
    print(url);
    try {
      return http.get(url).then((http.Response response) async {
        // print();
        final String responseBody = response.body;
        List<dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  Future<Map<String, dynamic>> certainService(String url) async {
    print(url);
    try {
      return http.get(url).then((http.Response response) async {
        // print();
        final String responseBody = response.body;
        Map<String, dynamic> ordersItem;
        ordersItem = json.decode(responseBody);
        print(ordersItem);

        return ordersItem;
      });
    } catch (ex) {
      //_showDialog("Something happened errored");
    }
    // _showDialog("Something happened errored");
    return null;
  }

  // ignore: missing_return
  Future<User> userLogin(BuildContext con, String url, {Map body}) async {
    print(body);
    SimilarWidgets similarWidgets = new SimilarWidgets();

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;

        Map<String, dynamic> getObject = json.decode(responseBody);

        print(getObject);

        User userGet = User.fromJson(json.decode(responseBody));
        print(userGet.name);

        if (userGet.userID != null) {
          return userGet;
        } else {
          return null;
        }
      });
    } catch (ex) {
      similarWidgets.showDialogWidget("Something happened errored", con);
    } finally {
      //Navigator.pop(con);

    }

    similarWidgets.showDialogWidget("Something happened errored", con);
  }

  // ignore: missing_return
  Future<User> createAndForgetUser(BuildContext con, String url,
      {Map body}) async {
    print(body);

    try {
      return http.post(url, body: body).then((http.Response response) {
        final String responseBody = response.body;
        print(json.decode(responseBody));
        Map<String, dynamic> getObject = json.decode(responseBody);

        print("000000000000000000000");
        print(getObject);

        User userGet = User.fromJson(json.decode(responseBody));

        return userGet;

        //User.fromJson(json.decode(response.body));
      });
    } catch (ex) {
      //showDialog("Something happened errored");
    }
  }

  Future<bool> checkConnectivity() async {
    bool connect;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
