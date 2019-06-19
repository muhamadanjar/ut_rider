import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
class ForgotPage extends StatefulWidget {
  String tag = RoutePaths.Forgot;
  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                color: Colors.teal,
                height: SizeConfig.blockHeight,

              )
            ],
          )
        ],
      ),
    );
  }
}
