import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import '../helpers/backend_config.dart';

class Auth with ChangeNotifier {
  String _userToken;
  String _userPhone;
  String _userId;
  String _userName;
  String _userEmail;
  int _invalidOtpCount = 0;
  Timer _authTimer;

  // determine if the app has authenticated user or not.
  bool get isAuth => _userToken != null;

  // retrieve the auth token when the app user is authenticated.
  String get authToken => _userToken == null ? null : _userToken;

  // retrieve app users phone number by which he/she is authenticated/to be authenticated
  String get userPhone => _userPhone == null ? null : _userPhone;

  bool get isRegistered => _userEmail != null;

  Future<void> requestOtp(String phone) async {
    _invalidOtpCount = 0;

    String url = '${BackendConfig.LOGIN_ROOT_ADDRESS}/generateOtp';

    final requestBody = json.encode({
      'PhoneNumber': phone,
    });

    try {
      final response = await http.post(url,
          body: requestBody, headers: BackendConfig.getLoginHeader);
      final responseBody = json.decode(response.body);

      if (responseBody['status'] && responseBody['messageCode'] == 200) {
        _userPhone = phone;
        notifyListeners();
      } else {
        throw HttpException(responseBody['errorCode']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> validateOtp(String otp, String deviceName) async {
    if (_invalidOtpCount == 2) {
      _invalidOtpCount = 0;
      _userPhone = null;
      notifyListeners();
      return;
    }

    String url = '${BackendConfig.LOGIN_ROOT_ADDRESS}/login';

    final requestBody = json.encode({
      'PhoneNumber': _userPhone,
      'OTP': otp,
      'DeviceName': deviceName,
    });

    try {
      final response = await http.post(url,
          body: requestBody, headers: BackendConfig.getLoginHeader);
      final responseBody = json.decode(response.body);

      if (responseBody['status'] && responseBody['messageCode'] == 200) {
        final authToken = responseBody['data']['UserKey'];
        final userId = responseBody['data']['UserId'];
        final userName = responseBody['data']['UserName'];
        final userEmail = responseBody['data']['UserEmail'];
        _userToken = authToken;
        _userId = userId;
        _userName = userName;
        _userEmail = userEmail;
        _autoLogout();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'userToken': _userToken,
          'userId': _userId,
          'userName': _userName,
          'userPhone': _userPhone,
          'userEmail': _userEmail
        });
        prefs.setString('userData', userData);
        notifyListeners();
      } else {
        throw HttpException(responseBody['errorCode']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    if (_userPhone != null) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    await Future.delayed(Duration(milliseconds: 800));

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userToken = extractedUserData['userToken'];
    _userId = extractedUserData['userId'];
    _userName = extractedUserData['userName'];
    _userPhone = extractedUserData['userPhone'];
    _userEmail = extractedUserData['userEmail'];
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    String url = '${BackendConfig.LOGIN_ROOT_ADDRESS}/logout';

    final requestBody = json.encode({
      'PhoneNumber': _userPhone,
      'UserKey': _userToken,
    });

    try {
      final response = await http.post(url,
          body: requestBody, headers: BackendConfig.getTokenHeader(_userToken));
      final responseBody = json.decode(response.body);
      if (responseBody['status'] && responseBody['data'] == "Logout") {
        _userToken = null;
        _userId = null;
        _userPhone = null;
        _userName = null;
        _userEmail = null;
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
      } else {
        throw HttpException(responseBody['errorCode']);
      }
    } catch (error) {
      throw error;
    }
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    _authTimer = Timer(
      Duration(days: 365),
      () => logout(),
    );
  }

  Future<void> register(Map<String, dynamic> info) async {
    info["UserInfo"]["mobileNumber"] = _userPhone;
    await Future.delayed(Duration(milliseconds: 100));
    print(info);

    final requestBody = json.encode(info);
    String url = '${BackendConfig.REGISTER_ROOT_ADDRESS}/registerCustomer';
    try {
      final response = await http.post(url,
          body: requestBody, headers: BackendConfig.getTokenHeader(_userToken));
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody['status']) {
        _userName = info["UserInfo"]["name"];
        _userEmail = info["UserInfo"]["email"];
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        final userData = json.encode({
          'userToken': _userToken,
          'userId': _userId,
          'userName': _userName,
          'userPhone': _userPhone,
          'userEmail': _userEmail
        });
        prefs.setString('userData', userData);
        notifyListeners();
      } else {
        throw HttpException(responseBody['errorCode']);
      }
    } catch (error) {
      throw error;
    }
  }
}
