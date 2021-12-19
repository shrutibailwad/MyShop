import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:my_shop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

bool get isAuth{
  return token!=null;
}

String get token{
  if(_expiryDate!=null && _expiryDate.isAfter(DateTime.now()) && _token!=null){
    return _token;
  }
  return null;
}
String get userId{
  return _userId;
}
  Future<void> authenticate(String email,String password,String urlSegment) async{
    final url=Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD_g-qi7ibNXgC9OgxQKfP-jOdTlAEbW3Y');
    try{
      final response=await http.post(url,body: jsonEncode({'email':email,
        'password':password,
        'returnSecureToken':true}));
      final responseData=jsonDecode(response.body);
      print(responseData);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }

      _token=responseData['idToken'];
      print('Token:$_token');
      _expiryDate=DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn'])));
      _userId=responseData['localId'];
      autoLogout();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userData=jsonEncode({'token':_token,'userId':_userId,'expiryDate':_expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
    }
    catch(error){
      throw error;
    }
  }

  Future<void> signup(String email,String password) async{
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email,String password) async{
   return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async{
  _token=null;
  _userId=null;
  _expiryDate=null;
  if(_authTimer!=null){
    _authTimer.cancel();
    _authTimer=null;
  }
  notifyListeners();
  final prefs=await SharedPreferences.getInstance();
  prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs =await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
        return false;
    }
    final extractedData=jsonDecode(prefs.getString('userData')) as Map<String,Object>;
    var expriryDate=DateTime.parse(extractedData['expiryDate']);
    if(expriryDate.isBefore(DateTime.now())){
      return false;
    }
    _token=extractedData['token'];
    _userId=extractedData['userId'];
    _expiryDate=expriryDate;
    notifyListeners();
    autoLogout();
    return true;
}
  void autoLogout(){
  if(_authTimer!=null){
    _authTimer.cancel();
  }
  var timeToExpiry=_expiryDate.difference(DateTime.now()).inSeconds;
  _authTimer=Timer(Duration(seconds: timeToExpiry),logout);
  }
}