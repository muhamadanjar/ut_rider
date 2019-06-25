import 'package:flutter/material.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/models/loginview_model.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/utils/authentication.dart';
import 'package:provider/provider.dart';
class RegisterPage extends StatefulWidget {
  String tag = RoutePaths.Register;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _agreedToTOS = true;
  String email,username,password,c_password,name,no_telp;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(authenticationService: Provider.of(context)),
      child: Container(),
      builder: (context,model,child){
        return Scaffold(
            resizeToAvoidBottomPadding: true,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                            child: Text(
                              'Daftar',
                              style:
                                  TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                            child: Text(
                              '.',
                              style: TextStyle(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value)=>email = value,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                // hintText: 'EMAIL',
                                // hintStyle: ,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            onSaved: (value)=>password = value,
                            decoration: InputDecoration(
                                labelText: 'Password ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                            obscureText: true,
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            onSaved: (value) => c_password = value,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Ketik Ulang Password',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            onSaved: (value)=> name = value,
                            decoration: InputDecoration(
                                labelText: 'Nama ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            onSaved: (value) => no_telp = value,
                            decoration: InputDecoration(
                                labelText: 'No Telp ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue))),
                          ),
                          SizedBox(height: 10.0),
                          model.busy ? CircularProgressIndicator():
                          ButtonTheme(
                            minWidth: double.infinity,
                            child: RaisedButton (
                              // padding: EdgeInsets.only(left: 10,right: 10.0),
                              onPressed: (){
                                var data = _storeToData();
                                model.register(data).then((v){
                                  if(v['status']){
                                    print("Pendaftaran Berhasil");
                                  }

                                });
                              },
                              child: Text("Daftar",style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),),
                              color: Colors.blue,
                              elevation: 7,
                            ),
                            shape:new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                            ),
                          ),
                          
                          SizedBox(height: 20.0),
                          Container(
                            height: 40.0,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Center(
                                  child: Text('Kembali',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Montserrat')),
                                ),
                                
                                
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  
                  ]
                ),
              ),
            )
        );
      },
    );
    
  }
  void _setAgreedToTOS(bool newValue) {
    setState(() {
      _agreedToTOS = newValue;
    });
  }
  Map _storeToData() {
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      var data = new Map();
      data['email'] = email;
      data['name'] = name;
      data['no_telepon'] = no_telp;
      data['password'] = password;
      data['c_password'] = c_password;
      print("${email}, ${name}, ${no_telp} ,${password} ${c_password}");
      return data;
    }
    
    print('Form submitted');
  }
  bool _submittable() {
    return _agreedToTOS;
  }
}
