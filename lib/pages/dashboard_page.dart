import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/components/menu_drawer.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/utils/promoService.dart';
import '../models/promo.dart';
import '../models/user.dart';
import '../data/rest_ds.dart';
BuildContext _ctx;
class DashboardPage extends StatefulWidget {
  static String tag = RoutePaths.Dashboard;
  DashboardPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  RestDatasource _rd =  new RestDatasource();
  List<Promo> lPromo = [];
  @override
  void initState() {
    _rd.getPromo().then((data){
      lPromo = data;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<User>(context);
    print(dp);
    _ctx = context;
    final drawer = Drawer(
        child: HomeMenu(name: dp.name)
    );
    return Scaffold(
      drawer: drawer,
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Profile(
            name: "Customer 1",
            imgUrl: "https://i.pravatar.cc/200",
          ),
          Divider(),
          MenuUtama(
            menuList: menuUtamaItem,
          ),
//          StreamBuilder<List<Promo>>(
//            stream: StreamP,
//            builder: (BuildContext context,AsyncSnapshot<List<Promo>> snapshot){
//              if (snapshot.hasError) {
//                return Text('Error: ${snapshot.error}');
//              }
//              switch (snapshot.connectionState) {
//                case ConnectionState.waiting:
//                  return const Text('Loading...');
//                default:
//                  if (snapshot.data.isEmpty) {
//                    return const Text("Data tidak ada");
//                  }
//                  return PromoWidget(list_promo: snapshot.data,);
//              }
//            }
//          ),
          PromoWidget(list_promo: lPromo,),
        ],
      ),
    );
  }
}


class PromoWidget extends StatelessWidget {
  List<Promo> list_promo = [];
  PromoWidget({this.list_promo});
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
            onPressed: () {
              Navigator.pushNamed(context, RoutePaths.Promo);
            },
          ),
        ),
        Container(
          width: double.infinity,
          height: 150.0,
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list_promo.length,
              itemBuilder: (context,idx){
                var allcon = Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(100, 176, 223, 229),
                          Color.fromARGB(100, 0, 142, 204)
                        ]
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),

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
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, RoutePaths.Promo);
                          },
                          child: Text(
                            'Lihat Semua \nPromo',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  ),
                );
                var listCon = Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(100, 176, 223, 229),
                            Color.fromARGB(100, 0, 142, 204)
                          ]),
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                          image: NetworkImage(list_promo[idx].imgUrl),
                          fit: BoxFit.cover
                      )
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                  height: 150.0,
                  width: 300.0,
                );
                return (idx == 0) ? listCon:listCon;
              }
          ),
        )
      ],
    );
  }
}


class MenuUtama extends StatelessWidget {
  List menuList;
  MenuUtama({this.menuList});
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2),
      children: menuList,
    );
  }
}
List<MenuUtamaItems> menuUtamaItem = [
  MenuUtamaItems(
    title: "Rencar",
    icon: Icons.local_taxi,
    colorBox: Colors.blue,
    colorIcon: Colors.white,
    onPress: (){
      print(RoutePaths.Rental);
      Navigator.pushNamed(_ctx, RoutePaths.Rental);
    },
  ),
  MenuUtamaItems(
    title: "Reguler",
    icon: Icons.local_taxi,
    colorBox: Colors.grey,
    colorIcon: Colors.white,
    onPress: (){
      Navigator.pushNamed(_ctx, RoutePaths.Home);
    },
  ),

];
class MenuUtamaItems extends StatelessWidget {
  MenuUtamaItems({this.title, this.icon, this.colorBox, this.colorIcon,this.onPress});
  final String title;
  final IconData icon;
  final Color colorBox, colorIcon;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
        onTap: onPress,
        child:Card(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                Container(
                  width: SizeConfig.blockWidth * 15,
                  height: SizeConfig.blockHeight * 15,
                  decoration: BoxDecoration(
                    color: colorBox,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: colorIcon,
                    size: 40.0,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
      ],
      ),
          ),
        )
    );
  }
}

class Profile extends StatelessWidget {
  String imgUrl;
  String name;
  Profile({this.name,this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(imgUrl))),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.attach_money),
              label: Text("Saldo"),
              onPressed: () {
                Navigator.pushNamed(context, RoutePaths.TopUp);
              },
              color: Colors.grey[200],
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
            )
          ],
        ),
      ),
    );
  }
}
