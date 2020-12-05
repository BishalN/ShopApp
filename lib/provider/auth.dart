import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryData;
  String _userId;

  Future<void> signup(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDGPASThvH1BNHT15AMR__QCal0frf9EJQ';
    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    print(json.decode(response.body));
  }

  Future<void> signin(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDGPASThvH1BNHT15AMR__QCal0frf9EJQ';
    final response = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    print(json.decode(response.body));
  }
}
