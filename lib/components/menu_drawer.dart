import 'package:flutter/material.dart';
import '../utils/constans.dart';
class MenuHome extends StatefulWidget {
  @override
  String UserName;
  MenuHome({this.UserName});
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  @override
  
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            accountName: Text(widget.UserName),
            accountEmail: Row(
              children: <Widget>[
                Text("5.0"),
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 12,
                )
              ],
            ),
            currentAccountPicture: ClipOval(
              child: Image.asset(
                "assets/avatar5.png",
                width: 10,
                height: 10,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                linkMenuDrawer('Profil', () {
                  Navigator.pushNamed(context, RoutePaths.Profile);
                }),
                linkMenuDrawer('Payment', () {
                  Navigator.pushNamed(context, RoutePaths.Payment);
                }),
                linkMenuDrawer('Saldo', () {
                  Navigator.pushNamed(context, RoutePaths.TopUp);
                }),
                linkMenuDrawer('Your Trips', () {
                  Navigator.pushNamed(context, RoutePaths.MyTrip);
                }),
                linkMenuDrawer('Settings', () {
                  Navigator.pushNamed(context, RoutePaths.Settings);
                }),
                linkMenuDrawer('Pemberitahuan', () {
                  Navigator.pushNamed(context, RoutePaths.Notifications);
                }),
                linkMenuDrawer('Help', () {
                  Navigator.pushNamed(context, RoutePaths.Help);
                }),

                Divider(
                    color: Colors.black45,
                ),

                linkMenuDrawer('Legal', () => Navigator.pushNamed(context, RoutePaths.Legal)),
              ]),
        ],
      );
  }

  Widget linkMenuDrawer(String title, Function onPressed) {
  return InkWell(
    onTap: onPressed,
    splashColor: Colors.black,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      width: double.infinity,
      child: Text(title,style: TextStyle(fontSize: 15.0),),
    ),
  );
}
}