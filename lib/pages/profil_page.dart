import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
class ProfilPage extends StatefulWidget {
  static String tag = RoutePaths.Profile;
  String title;
  ProfilPage({Key key,this.title}): super(key:key);
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  Choice _selectedChoice = choices[0];
  final _spKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _spKey,
      appBar: AppBar(
        title: Text("Profile",style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500,letterSpacing: 2.0),),
        centerTitle: true,
        elevation: 8.0,
        actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: InkWell(
                      onTap:(){
                        print(choice.tag);
                        Navigator.pushNamed(context, choice.tag);
                      },
                      child: Text(choice.title)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blueGrey,
              child: Center(
                child: Container(
                  width: SizeConfig.blockWidth * 25,
                  height: SizeConfig.blockWidth * 25,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage("https://i.pravatar.cc/200")
                    )

                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Depan",style: TextStyle(fontSize: 19,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),),
                        Text("Belakang",style: TextStyle(fontSize: 19,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          RaisedButton(
            onPressed: (){
              Navigator.pushNamed(context, RoutePaths.EditProfile);
            },
          ),
        ],
      ),
    );
  }

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }
}

class Choice {
  const Choice({this.title, this.icon,this.tag});

  final String title;
  final IconData icon;
  final String tag;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Ganti Profil', icon: Icons.settings_applications,tag:RoutePaths.ChangeProfile),
  const Choice(title: 'Ganti Password', icon: Icons.security,tag: RoutePaths.ChangePassword),
];
