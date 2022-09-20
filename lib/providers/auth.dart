// contains signup and sign in mechanism

import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/providers/http_exception.dart';
import 'package:flutter_complete_guide/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

//if token not expired
  bool get isAuth {
    print('TOKEN: ' + token.toString());
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  Future<void> signup(String email, String password) async {
    var MainUrl = Api.authUrl;
    var AuthKey = Api.authKey;
    String endPoint = 'signUp';
    final url = '$MainUrl/accounts:signUp?key=$AuthKey';
    print('Final URL: ' + url.toString());
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  String get userId {
    return _userId;
  }

  Future<void> login(String email, String password) async {
    var MainUrl = Api.authUrl;
    var AuthKey = Api.authKey;
    String endPoint = 'signUp';
    final url = '$MainUrl/accounts:signInWithPassword?key=$AuthKey';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      print('userID : ' +
          _userId.toString() +
          '_expiryDate' +
          _expiryDate.toString());
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
