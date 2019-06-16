import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:ut_order/data/rest_ds.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/models/loginview_model.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  RestDatasource rs = new RestDatasource();
  String _username, _password, _token;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  SharedPreferences _sp;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp){
      _sp = sp;
      var token =_sp.getString('token');
      setState(() {
        _token = token;
      });

    });

    print(_token);
    

  }
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: 'admin@example.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (value) => _username = value,
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: 'password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onSaved: (value) => _password = value,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: _submit,
          color: Colors.lightBlueAccent,
          child: Text('Log In', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );
    final form = Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
          child:
          Form(
            key: formKey,
            child:ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logo,
                SizedBox(height: 48.0),
                email,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                loginButton,
                forgotLabel
              ],
            ),
          )
      ),
    );
    final wrapLogin = BaseWidget<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      child: form,
      builder: (context,model,child) => Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              child,
              model.busy
                  ? CircularProgressIndicator()
                  : FlatButton(
                color: Colors.white,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: _submit
              )
            ],
          )
      ),
    );

    return form;

  }
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      print("data $_username $_password");

      rs.login(_username, _password).then((user){
        var te = user.toMap();
        print("calling user : $te");
        Navigator.of(context).pushNamed(HomePage.tag);
      });

    }

  }
  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }
  void onLoginSuccess(User user) async{
    print(user.toString());
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
  }

  getPrefs(val) async{
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString(val);
    });
  }

}
