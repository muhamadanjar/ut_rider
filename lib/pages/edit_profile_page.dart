import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/models/auth.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "EDIT PROFILE",
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new EditProfileScreen(),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  @override
  State createState() => new EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  File avatarImageFile, backgroundImageFile;
  String sex;

  Future getImage(bool isAvatar) async {
    var result = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (isAvatar) {
        avatarImageFile = result;
      } else {
        backgroundImageFile = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Stack(
              children: <Widget>[
                // Background
                (backgroundImageFile == null)
                    ? new Image.asset(
                  'assets/img/bg_uit.jpg',
                  width: double.infinity,
                  height: 150.0,
                  fit: BoxFit.cover,
                )
                    : new Image.file(
                  backgroundImageFile,
                  width: double.infinity,
                  height: 150.0,
                  fit: BoxFit.cover,
                ),

                // Button change background
                new Positioned(
                  child: new Material(
                    child: new IconButton(
                      icon: new Image.asset(
                        'assets/ic_menu.png',
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                      onPressed: () => getImage(false),
                      padding: new EdgeInsets.all(0.0),
                      highlightColor: Colors.black,
                      iconSize: 30.0,
                    ),
                    borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  right: 5.0,
                  top: 5.0,
                ),

                // Avatar and button
                new Positioned(
                  child: new Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? new Image.asset(
                        'assets/ic_menu_user.png',
                        width: 70.0,
                        height: 70.0,
                      )
                          : new Material(
                        child: new Image.file(
                          avatarImageFile,
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
                      ),
                      new Material(
                        child: new IconButton(
                          icon: new Image.asset(
                            'assets/img/ic_camera.png',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () => getImage(true),
                          padding: new EdgeInsets.all(0.0),
                          highlightColor: Colors.black,
                          iconSize: 70.0,
                        ),
                        borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ],
                  ),
                  top: 115.0,
                  left: MediaQuery.of(context).size.width / 2 - 70 / 2,
                )
              ],
            ),
            width: double.infinity,
            height: 200.0,
          ),
          new Column(
            children: <Widget>[
              // Username
              BaseWidget(
                model: AuthBloc(),
                onModelReady: (model)=>model.getUser(),
                builder: (context,AuthBloc auth,_){
                  return auth.user == null ? CircularProgressIndicator():Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          'Email',
                          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.blueGrey),
                        ),
                        margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                      ),
                      new Container(
                        child: new TextFormField(
                          initialValue: auth.user.email,
                          decoration: new InputDecoration(
                              hintText: 'Agya',
                              border: new UnderlineInputBorder(),
                              contentPadding: new EdgeInsets.all(5.0),
                              hintStyle: new TextStyle(color: Colors.grey)),
                        ),
                        margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                    ],
                  );
                },
              ),

              // Nama
              BaseWidget(
                model: AuthBloc(),
                onModelReady: (model)=>model.getUser(),
                builder:(context,AuthBloc auth,_){
                  var name = auth.user != null ? auth.user.name :'';
                  return auth.user == null ? CircularProgressIndicator() : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        'Nama',
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.blueGrey),
                      ),
                      margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                    ),
                    new Container(
                      child: new TextFormField(
                        initialValue: name,
                        decoration: new InputDecoration(
                            hintText: 'Medan',
                            border: new UnderlineInputBorder(),
                            contentPadding: new EdgeInsets.all(5.0),
                            hintStyle: new TextStyle(color: Colors.grey)),
                      ),
                      margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                  ],
                );
                }
              ),

              // Phone Number
              BaseWidget(
                model: AuthBloc(),
                onModelReady: (model)=>model.getUser(),
                builder:(context,auth,_)=> auth.user == null ? CircularProgressIndicator():Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(
                        'Phone',
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.blueGrey),
                      ),
                      margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                    ),
                    new Container(
                      child: new TextFormField(
                        initialValue: auth.user.phoneNumber,
                        decoration: new InputDecoration(
                            hintText: '0123456789',
                            border: new UnderlineInputBorder(),
                            contentPadding: new EdgeInsets.all(5.0),
                            hintStyle: new TextStyle(color: Colors.grey)),
                        keyboardType: TextInputType.number,
                      ),
                      margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                    ),
                  ],
                ),
              ),


              // Sex
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new Text(
                      'Sex',
                      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.blueGrey),
                    ),
                    margin: new EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  new Container(
                    child: new DropdownButton<String>(
                      items: <String>['Male', 'Female'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sex = value;
                        });
                      },
                      hint: sex == null
                          ? new Text('Male')
                          : new Text(
                        sex,
                        style: new TextStyle(color: Colors.black),
                      ),
                      style: new TextStyle(color: Colors.black),
                    ),
                    margin: new EdgeInsets.only(left: 50.0),
                  )
                ],
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RaisedButton(
                    color: ThemeData().accentColor,
                    child: Text("Simpan",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500,letterSpacing: 1.5),),
                    onPressed: (){

                    },
                  ),
                ),
              )

            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        ],
      ),
      padding: new EdgeInsets.only(bottom: 20.0),
    );
  }
}
