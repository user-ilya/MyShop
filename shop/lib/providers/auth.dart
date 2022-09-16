import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {

  String? _token;
  String? _userId;
  DateTime? _endDateTime;
  late String refreshToken;
  Timer? _authTime;

  bool get isAuth  {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token  {
  
  if (_endDateTime != null && _endDateTime!.isAfter(DateTime.now()) && _token != null ) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate (String? email, String? password, String urlSegment) async {
    try {
      final response = await http.post(Uri.parse(urlSegment), body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));
      final responseData = await json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _userId = responseData['localId'];
      _token = responseData['idToken'];
      _endDateTime = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLoguot();
      notifyListeners();
      final prefs =  await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userId, '_endDateTime': _endDateTime!.toIso8601String()});
      await prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp (String? email, String? password) async {
    return _authenticate(email, password, 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAB7kVB3CPZxljBmK3-g3P8WPQQvuSnPxA');
    
  }

  Future<void> signIn (String? email, String? password) async {
    return _authenticate(email, password, 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAB7kVB3CPZxljBmK3-g3P8WPQQvuSnPxA');
  }

  Future<void> logout () async {
    _endDateTime = null;
    _token = null;
    _userId = null;
    if (_authTime != null) {
      _authTime!.cancel();
      _authTime = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLoguot () {
    if (_authTime != null) {
      _authTime!.cancel();
    }
    final timeToCompletion = _endDateTime!.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: timeToCompletion), logout);

  }

  Future<bool> tryAutoSignIn () async {
    print('go');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final _getUserData = json.decode(prefs.getString('userData') as String) as Map<String, dynamic>;
    if (DateTime.parse( _getUserData['endDateTime']).isBefore(DateTime.now())) {
      return false;
    };

    _token = _getUserData['token'];
    _endDateTime = _getUserData['endDateTime'];
    _userId = _getUserData['userId'];
    notifyListeners();
    _autoLoguot();
    return true;
  }
}

