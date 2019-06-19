import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
class RegisterPage extends StatefulWidget {
  String tag = RoutePaths.Register;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: ListView(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              hintText: 'Username'
            ),
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
          RaisedButton(
            onPressed: (){},
            child: Text("Daftar",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w200),),
          )

        ],
      ),
    );
  }
}
