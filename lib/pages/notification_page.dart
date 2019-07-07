import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
class NotificationPage extends StatefulWidget {
  final String tag = RoutePaths.Notifications;
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with SingleTickerProviderStateMixin {
  final _snKey = new GlobalKey<ScaffoldState>();
  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifikasi"),
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.black,
          tabs: [
            new Tab(icon: new Icon(Icons.info)),
            new Tab(
              icon: new Icon(Icons.transform),
            ),
            new Tab(
              icon: new Icon(Icons.notifications),
            )
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,),
          bottomOpacity: 1,
    ),

      body: TabBarView(
          children: [
          new Text("Info"),
          new Text("Promo"),
          new Text("This is notification Tab View"),
          ],
        controller: _tabController,
      ),
    );
  }

}
