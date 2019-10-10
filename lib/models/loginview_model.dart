import 'package:flutter/widgets.dart';
import 'package:ut_order/utils/authentication.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<dynamic> login(String username,password) async {
    setBusy(true);
    var success = await _authenticationService.login(username,password);
    setBusy(false);
    return success;
  }

  Future<dynamic> register(Map data) async{
    print(data);
    setBusy(true);
    var success = await _authenticationService.register(data);

    setBusy(false);
    return success;
  }
}
