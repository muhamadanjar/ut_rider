import 'package:flutter/material.dart';
import 'package:ut_order/components//profile_tile.dart';

class NotFoundPage extends StatelessWidget {
  final appTitle;
  final title;
  final message;
  final IconData icon;
  final String image;
  final iconColor;

  NotFoundPage(
      {this.appTitle = "Search",
        this.title = "No Result",
        this.message = "Try a more general keyword.",
        this.icon = Icons.search,
        this.image,
        this.iconColor = Colors.black});

  Widget bodyData() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 100.0,
          color: iconColor,
        ),
        SizedBox(
          height: 20.0,
        ),
        ProfileTile(
          title: title,
          subtitle: message,
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NotFound"),),
      body: bodyData(),
    );
  }
}
