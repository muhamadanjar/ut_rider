import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsBlocError extends Error {
  final String message;

  PrefsBlocError(this.message);
}

class PrefsState {
  final bool showWebView;
  final String token;
  const PrefsState({this.showWebView,this.token});
}

class PrefsNotifier with ChangeNotifier {
  PrefsState _currentPrefs = PrefsState(showWebView: false);

  bool get showWebView => _currentPrefs.showWebView;

  set showWebView(bool newValue) {
    if (newValue == _currentPrefs.showWebView) return;
    _currentPrefs = PrefsState(showWebView: newValue);
    notifyListeners();
    _saveNewPrefs();
  }

  PrefsNotifier() {
    _loadSharedPrefs();
  }

  Future<void> _loadSharedPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    var showWebView = sharedPrefs.getBool('showWebView') ?? false;
    var _token = sharedPrefs.getString('token');
    _currentPrefs = PrefsState(showWebView: showWebView,token: _token);
    notifyListeners();
  }

  Future<void> _saveNewPrefs() async {
    var sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('showWebView', _currentPrefs.showWebView);
    await sharedPrefs.setString('token', _currentPrefs.token);
  }
}
