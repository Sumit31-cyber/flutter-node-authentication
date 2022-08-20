import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_node_auth/Models/user.dart';
import 'package:flutter_node_auth/Providers/user_provider.dart';
import 'package:flutter_node_auth/Screens/home_screen.dart';
import 'package:flutter_node_auth/Screens/signin_screen.dart';
import 'package:flutter_node_auth/Widgets/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/constants.dart';

class AuthService {
  void SignUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        token: '',
        password: password,
      );

      http.Response res = await http.post(
          Uri.parse('${Constant.uri}/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
          });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! login with the same credentials!');
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      http.Response res = await http.post(
          Uri.parse('${Constant.uri}/api/signin'),
          body: jsonEncode({'email': email, 'password': password}),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
          });

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            userProvider.setUser(res.body);

            await pref.setString('x-auth-token', jsonDecode(res.body)['token']);
            navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false);
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('x-auth-token');

    if (token == null) {
      pref.setString('x-auth-token', '');
    }

    var tokenRes = await http.post(Uri.parse('${Constant.uri}/tokenIsValid'),
        headers: <String, String>{
          'content-type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        });
    var response = jsonDecode(tokenRes.body);

    if (response == true) {
      http.Response userRes = await http.get(Uri.parse('${Constant.uri}/'),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          });
      userProvider.setUser(userRes.body);
    }
  }

  void signOut(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final navigator = Navigator.of(context);
    pref.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }
}
