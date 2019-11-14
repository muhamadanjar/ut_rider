import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ut_order/models/http_exception.dart';
import 'package:uuid/uuid.dart';
import 'package:ut_order/utils/webclient.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/models/user.dart';

import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:geolocator/geolocator.dart';


class AuthModel extends Model {
  String errorMessage = "";

  bool _rememberMe = false;
  bool _stayLoggedIn = true;
  bool _useBio = false;
  User _user;

  bool get rememberMe => _rememberMe;

  void handleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", value);
    });
  }

  bool get isBioSetup => _useBio;

  void handleIsBioSetup(bool value) {
    _useBio = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("use_bio", value);
    });
  }

  bool get stayLoggedIn => _stayLoggedIn;

  void handleStayLoggedIn(bool value) {
    _stayLoggedIn = value;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("stay_logged_in", value);
    });
  }

  void loadSettings() async {
    var _prefs = await SharedPreferences.getInstance();
    try {
      _useBio = _prefs.getBool("use_bio") ?? false;
    } catch (e) {
      print(e);
      _useBio = false;
    }
    try {
      _rememberMe = _prefs.getBool("remember_me") ?? false;
    } catch (e) {
      print(e);
      _rememberMe = false;
    }
    try {
      _stayLoggedIn = _prefs.getBool("stay_logged_in") ?? false;
    } catch (e) {
      print(e);
      _stayLoggedIn = false;
    }

    if (_stayLoggedIn) {
      User _savedUser;
      try {
        String _saved = _prefs.getString("user_data");
        print("Saved: $_saved");
        _savedUser = User.fromJson(json.decode(_saved));
      } catch (e) {
        print("User Not Found: $e");
      }
      if (_useBio) {
        if (await biometrics()) {
          _user = _savedUser;
        }
      } else {
        _user = _savedUser;
      }
    }
    notifyListeners();
  }

  Future<bool> biometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: false);
    } catch (e) {
      print(e);
    }
    return authenticated;
  }

  User get user => _user;

  Future<User> getInfo(String token) async {
    try {
      var _data = await WebClient(User(token: token,name: "A",email: 'd')).get(apiURL);
      // var _json = json.decode(json.encode(_data));
      var _newUser = User.fromJson(_data["data"]);
      _newUser?.token = token;
      return _newUser;
    } catch (e) {
      print("Could Not Load Data: $e");
      return null;
    }
  }

  Future<bool> login({
    @required String username,
    @required String password,
  }) async {
    var uuid = new Uuid();
    String _username = username;
    String _password = password;

    // TODO: API LOGIN CODE HERE
    await Future.delayed(Duration(seconds: 3));
    print("Logging In => $_username, $_password");

    if (_rememberMe) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString("saved_username", _username);
      });
    }

    // Get Info For User
    User _newUser = await getInfo(uuid.v4().toString());
    if (_newUser != null) {
      _user = _newUser;
      notifyListeners();

      SharedPreferences.getInstance().then((prefs) {
        var _save = json.encode(_user.toMap());
        print("Data: $_save");
        prefs.setString("user_data", _save);
      });
    }

    if (_newUser?.token == null || _newUser.token.isEmpty) return false;
    return true;
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("user_data", null);
    });
    return;
  }
}


class AuthBloc with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
  User _authenticatedUser;
  Position userPosition;
  PublishSubject<bool> _userSubject = PublishSubject();
  bool get isAuth {
    return token != null;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }
  User get user{
    return _authenticatedUser;
  }

  String get token {
    print("getting token and expire date $_expiryDate $_token");
//    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
//    }
//    print("anda sudah expire di $_expiryDate");
//    return null;
  }

  String get userId {
    return _userId;
  }
  // User get user{ return _authenticatedUser;}

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final url = '$apiURL/login';
    try {
      if(urlSegment != 'signupNewUser') {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'username': email,
              'password': password,
              'returnSecureToken': true,
            },
          ),
          headers: {'Content-Type': 'application/json'},
        );
        final responseData = json.decode(response.body);
        print("response data user $responseData");
        if (responseData['status'] == false) {
          throw HttpException(responseData['message']);
        }
        _token = responseData['data']['token'];
        _userId = responseData['data']['user']['id'].toString();
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: responseData['expiresIn'] != null
                ? responseData['expiresIn']
                : int.parse("3600"),
          ),
        );
        _userSubject.add(true);
        print(_token);
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
          },
        );
        print("userData $userData");
        prefs.setString('userData', userData);

      }else{
        print("register");
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      _userSubject.add(false);
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    _userSubject.add(true);
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    print("request logout");
    _token = null;
    _userId = null;
    _expiryDate = null;
    _userSubject.add(false);
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future getUser() async {
    try{
        final prefs = await SharedPreferences.getInstance();
        if (!prefs.containsKey('userData')) {
          return false;
        }
        final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
        final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
        // print("extract $extractedUserData");
        if (expiryDate.isBefore(DateTime.now())) {
          return false;
        }
        _token = extractedUserData['token'];
        _userId = extractedUserData['userId'];

        var headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${_token}',
        };
        
        final response = await http.post("${apiURL}/user/details",body: json.encode({}),headers:headers);
        final int statusCode = response.statusCode;

        _userSubject.add(true);
        print(statusCode);
        final responseData = json.decode(response.body);
        _authenticatedUser = User(name: responseData['data']['name'],
            email: responseData['data']['email'],
            saldo:responseData['data']['wallet'].toString(),
            photoUrl: responseData['data']['foto'],
            phoneNumber:responseData['data']['no_telepon'].toString(),
          token: responseData['data']['api_token']
        );
        print("data auth $_authenticatedUser");
        notifyListeners();
        print(_token);

    }catch(e){
      print("$e");
      // throw new Exception(response
    }
  }
  Future updatePosition(Position position) async{
      try {
        var url = "${apiURL}/user/update_position";
        var formData = {
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'latest_update': new DateTime.now().toString()
        };
        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        };
        final response = await http.post(url,
          body: json.encode(formData),
          headers: headers,
        );
        final responseData = json.decode(response.body);
        userPosition = position;
        notifyListeners();
      } catch (e) {
        print('Error Position :'+ e.toString());
      }
  }


  Future updateStatus(bool status) async{
    var data = status ? 1:0;
    try {
      final response = await http.post("${apiURL}/user/changeonline",body: json.encode({
        'online':data
      }),headers: {'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',});
      final responseData = json.decode(response.body);
      
    } catch (e) {
    }
  }
}