import 'dart:async';
import 'dart:convert';

import '../models/user.dart';
import 'constans.dart';
import 'network_util.dart';

class AuthenticationService {
  final NetworkUtil _api;

  AuthenticationService({NetworkUtil api}) : _api = api;

  StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;

  Future<bool> getUser(String userId) async {
    var fetchedUser = await _api.get("$apiURL/user/details");

    var hasUser = fetchedUser != null;
    if (hasUser) {
      _userController.add(fetchedUser['data']);
    }
    return hasUser;
  }

  Future<User> login(String username,String password) async{
    var fetchUser = await _api.post("$apiURL/login",body: json.encode(
      {
        'username': username,
        'password': password,
        'returnSecureToken': true,
      },
    ),headers: {'Content-Type': 'application/json'});
    print("data login : $fetchUser");
    var hasUser = fetchUser != null;
    if(hasUser){
      _userController.add(fetchUser['data']);
    }
    return fetchUser;
  }

  Future<User> register(Map mapData) async{
    var dataUser = await _api.post("$apiURL/register",body: mapData,headers: {'Content-Type': 'application/json'});
    print("data register : ${dataUser}");
    var hasUser = dataUser != null;
    if(hasUser){
      _userController.add(dataUser['data']);
    }else{
      print("Print user error ${dataUser['error']}");
    }
    return dataUser;
    
  }
}
