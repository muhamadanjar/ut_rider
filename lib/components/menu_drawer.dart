import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/models/auth.dart';

import '../utils/constans.dart';
class HomeMenu extends StatelessWidget {
  final String name;
  HomeMenu({this.name});
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.lightBlue),
            accountName: Text(name),
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
                linkMenuDrawer('Konfirmasi Top Up', () {
                  Navigator.pushNamed(context, RoutePaths.Payment);
                }),
                linkMenuDrawer('Bank Top Up saldo', () {
                  Navigator.pushNamed(context, RoutePaths.TopUp);
                }),
                linkMenuDrawer('Histori Perjalanan', () {
                  Navigator.pushNamed(context, RoutePaths.MyTrip);
                }),
                linkMenuDrawer('Pengaturan', () {
                  Navigator.pushNamed(context, RoutePaths.Settings);
                }),
                linkMenuDrawer('Pemberitahuan', () {
                  Navigator.pushNamed(context, RoutePaths.Notifications);
                }),
                linkMenuDrawer('Bantuan', () {
                  Navigator.pushNamed(context, RoutePaths.Help);
                }),

                Divider(
                    color: Colors.black45,
                ),

                linkMenuDrawer('Logout', () async{
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');

                  // Navigator.of(context)
                  //     .pushReplacementNamed(UserProductsScreen.routeName);
                  Provider.of<AuthBloc>(context, listen: false).logout();
                }),
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