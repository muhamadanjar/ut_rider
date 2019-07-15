import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/models/tipemobil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/constans.dart';
import '../data/app_bloc.dart';
class RentalPage extends StatefulWidget {
  static String tag = RoutePaths.Rental;
  @override
  _RentalPageState createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  AppBloc appBloc;

  @override
  void initState() {
    super.initState();
    appBloc = new AppBloc();
    appBloc.getPackage(1);
  }
  @override
  void dispose() {
    appBloc.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Promo"),),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Geser",

                    ),
                    Spacer(),

                  ],
                ),
              ),
              // tipeMobil(),
              paketMobil(),


            ]
        )
          ],
        ),
      ),
    );
  }

  
  Widget tipeMobil(){
    return Container(
        height: 240.0,
        child: StreamBuilder(
            stream: appBloc.tipeSnapshotStream,
            builder: (context, snapshot) {
              print(" has data ${snapshot.hasData}");
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    print(snapshot.data);
                    return InkWell(
                        onTap: (){
                          appBloc.getPackage(index);
                        },
                        child: TipeCard(
                            tipeMobil: TipeMobil.fromMap(snapshot.data[index])
                        )
                    );
                  });;
            }
        ),

    );
  }

  Widget paketMobil(){
    return Container(
      width: double.infinity,
      height: SizeConfig.blockHeight * 80,
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: StreamBuilder(
          stream: appBloc.packageSnapshotStream,
          builder: (context, snapshots) {
            print("snapshot paket: $snapshots.data");
            return !snapshots.hasData
                ? Center(child: CircularProgressIndicator()):
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshots.data.length,
              itemBuilder: (context,idx){
                var data = snapshots.data;
                print(data[idx]);

                var packageContainer = Container(
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
                          image: NetworkImage(data[idx]['imgUrl']),
                          fit: BoxFit.cover
                      )
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                  height: SizeConfig.blockHeight * 50,
                  width: SizeConfig.blockWidth * 90,

                );
                return !snapshots.hasData ? Center(child: CircularProgressIndicator()):packageContainer;
              },

            );
          }
      )
    );
  }
  Widget _buildTipeList(BuildContext context, List snapshots) {
    print("Data Tipe Snapshot ${snapshots}");
    return ListView.builder(
        itemCount: snapshots.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: (){
                appBloc.getPackage(snapshots[index].id);
              },
              child: TipeCard(
                  tipeMobil: TipeMobil.fromMap(snapshots[index])
              )
          );
        });
  }

}


class TipeCard extends StatelessWidget {
  final TipeMobil tipeMobil;

  TipeCard({this.tipeMobil});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 210.0,
                  width: 160.0,
                  child: CachedNetworkImage(
                    imageUrl: '${tipeMobil.imgUrl}',
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeIn,
                    placeholder: (context,url) => Center(child: CircularProgressIndicator()),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: 160.0,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0.1),
                            ])),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  bottom: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${tipeMobil.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0),
                          ),
                          Text(
                            '${tipeMobil.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                fontSize: 14.0),
                          ),
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
