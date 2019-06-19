import 'dart:async';

import '../models/user.dart';
import '../data/rest_ds.dart';

class AuthenticationService {
  final RestDatasource _api;

  AuthenticationService({RestDatasource api}) : _api = api;

  StreamController<User> _userController = StreamController<User>();

  Stream<User> get user => _userController.stream;

  Future<bool> getUser(String userId) async {
    var fetchedUser = await _api.getUser(userId);
    var hasUser = fetchedUser != null;
    if (hasUser) {
      _userController.add(fetchedUser);
    }

    return hasUser;
  }

  Future<User> login(String username,String password) async{
    var fetchUser = await _api.login(username, password);
    var hasUser = fetchUser != null;
    if(hasUser){
      _userController.add(fetchUser);
    }
    return fetchUser;
  }
}
