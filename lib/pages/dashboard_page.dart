import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
class DashboardPage extends StatefulWidget {
  static String tag = RoutePaths.Promo;
  DashboardPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Promo()
        ],
      ),
    );
  }
}


class Promo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Promo Saat Ini',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
          ),
          trailing: IconButton(
            icon: Icon(Icons.keyboard_arrow_right),
            onPressed: () {},
          ),
        ),
        Container(
          width: double.infinity,
          height: 150.0,
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue,
                        Colors.blue[800],
                      ]),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(left: 8.0),
                height: 150.0,
                width: 100.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(20.0,20.0),
                                bottomRight: Radius.elliptical(150.0, 150.0)
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0, left: 5.0, right: 30.0, bottom: 30.0),
                          child: Text('%', style: TextStyle(fontSize: 24.0,color: Colors.white),),
                        )),
                    Expanded(
                      child: Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Lihat Semua \nPromo',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 18.0),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue,
                          Colors.blue[800],
                        ]),
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: AssetImage('images/promo.jpeg'))),
                margin: EdgeInsets.only(left: 10.0),
                height: 150.0,
                width: 300.0,
                child: null,
              )
            ],
          ),
        )
      ],
    );
  }
}


class MenuUtama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
      children: menuUtamaItem,
    );
  }
}

List<MenuUtamaItems> menuUtamaItem = [
  MenuUtamaItems(
    title: "Tiket Pesawat",
    icon: Icons.flight,
    colorBox: Colors.blue,
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Hotel",
    icon: Icons.hotel,
    colorBox: Colors.blue[900],
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Pesawat + Hotel",
    icon: Icons.flight_land,
    colorBox: Colors.purple,
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Aktifitas & Rekreasi",
    icon: Icons.local_play,
    colorBox: Colors.green[300],
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Kuliner",
    icon: Icons.local_dining,
    colorBox: Colors.orange,
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Tiket Kereta Api",
    icon: Icons.train,
    colorBox: Colors.orange[300],
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Tiket Bus & Travel",
    icon: Icons.directions_bus,
    colorBox: Colors.green,
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Transportasi Bandara",
    icon: Icons.local_taxi,
    colorBox: Colors.blue[300],
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Rental Mobil",
    icon: Icons.directions_car,
    colorBox: Colors.green[900],
    colorIcon: Colors.white,
  ),
  MenuUtamaItems(
    title: "Semua Produk",
    icon: Icons.blur_on,
    colorBox: Colors.grey,
    colorIcon: Colors.black,
  )
];

class MenuUtamaItems extends StatelessWidget {
  MenuUtamaItems({this.title, this.icon, this.colorBox, this.colorIcon});
  final String title;
  final IconData icon;
  final Color colorBox, colorIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: colorBox,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorIcon,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}


