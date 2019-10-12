import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/data/app_bloc.dart';
import 'package:ut_order/models/auth.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/components/menu_drawer.dart';

import '../models/promo.dart';
BuildContext _ctx;
class DashboardPage extends StatefulWidget {
  static String tag = RoutePaths.Dashboard;
  DashboardPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  
  List<Promo> lPromo = [];
  @override
  void initState() {
    // _rd.getPromo().then((data){
    //   lPromo = data;
    // });
    super.initState();

  }
  Future<Null> _reload(model) async{
    print(model.user);
    Completer<Null> completer = new Completer<Null>();
    await model.getUser();
    Timer timer = new Timer(new Duration(seconds: 3), () {
      completer.complete();
    });
    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final drawer = Drawer(
        child: BaseWidget(
          model: AuthBloc(),
          builder :(context,dp,_) => HomeMenu(name: dp.user.toString())
        )
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
      body:  BaseWidget(
        onModelReady: (AuthBloc model){
          model.getUser();
          print("checking token ${model.isAuth}");
          print("df");
        },
        model: AuthBloc(),
        builder:(context,model,_) => RefreshIndicator(
          onRefresh: ()=>_reload(model),
          child: ListView(
            children: <Widget>[
              Profile(
                name: model.user != null ? model.user.name:"User Sample",
                imgUrl: "https://i.pravatar.cc/200",
                saldo: model.user != null ? model.user.saldo.toString() : '0',
              ),
              Divider(),
              MenuUtama(
                menuList: menuUtamaItem,
              ),
              StreamBuilder(
                stream: Provider.of<AppBloc>(context).promoSubject,
                builder: (context,asyncSnapshot){
                  if (asyncSnapshot.hasError) {
                    return new Text("Error!");
                  } else if (asyncSnapshot.data == null) {
                    print("data kosong");
                  }else{
                    print(asyncSnapshot.data);

                    return PromoWidget(listPromo: asyncSnapshot.data,);

                  }
                },
              ),


          ],
          ),
        ),
      ),
    );
  }
}


class PromoWidget extends StatelessWidget {
  final List<Promo> listPromo;
  PromoWidget({this.listPromo});
  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 250.0,
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listPromo.length,
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
                          image: NetworkImage(listPromo[idx].imgUrl),
                          fit: BoxFit.cover
                      )
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                  height: 250.0,
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
  final List menuList;
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
    title: "Promo",
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
  final String imgUrl;
  final String name;
  final String saldo;
  Profile({this.name,this.imgUrl,this.saldo});
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
              label: Text(saldo),
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
