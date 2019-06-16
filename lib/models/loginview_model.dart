import 'package:flutter/widgets.dart';
import 'package:ut_order/utils/authentication.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  AuthenticationService _authenticationService;

  LoginViewModel({
    @required AuthenticationService authenticationService,
  }) : _authenticationService = authenticationService;

  Future<bool> login(String userIdText) async {
    setBusy(true);
    var success = await _authenticationService.getUser(userIdText);
    setBusy(false);
    return success;
  }
}
