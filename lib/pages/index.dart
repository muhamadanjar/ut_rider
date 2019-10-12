import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/models/auth.dart';
import 'package:ut_order/pages/dashboard_page.dart';
import 'package:ut_order/pages/splash_page.dart';

import 'login_page.dart';
class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  bool _isAuthenticated = false;
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      model: AuthBloc(),
      onModelReady: (model){
        model.tryAutoLogin();
        model.userSubject.listen((bool isAuthenticated) {
            setState(() {
              _isAuthenticated = isAuthenticated;
            });
        });
      },
      builder:(context,auth,_){
        return _isAuthenticated ? DashboardPage() : LoginPage();
      }

    );
  }

}
