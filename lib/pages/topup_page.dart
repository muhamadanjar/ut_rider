import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/data/rest_ds.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/models/user.dart';
class TopupPage extends StatefulWidget {
  static String Tag = RoutePaths.TopUp;
  @override
  _TopupPageState createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  final saldoCtrl = TextEditingController();
  RestDatasource rs = new RestDatasource();
  String reqCode;
  @override
  Widget build(BuildContext context) {
    final up = Provider.of<User>(context);
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: Text("Top up Saldo"),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ListView(
            padding: EdgeInsets.only(left: 20,right: 20),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 26),
                child: Text(
                  "Top Up Saldo",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Wrap(
                children: <Widget>[
                  TextField(
                    controller: saldoCtrl,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Isi Disini ',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child:RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text("Konfirm Topup"),
                  onPressed: (){
                    var saldo = saldoCtrl.text;
                    rs.postRequestSaldo(saldo,up.token).then((v){
                      if(v['status']){
                        setState(() {
                          reqCode = v['data']['req_code'];
                        });
                      }
                      print(v);
                      saldoCtrl.text = "";

                    }).catchError((e){
                      print(e);
                    });

                  },
                )
              ),
              Card(
                  margin:EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child:  Card(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  margin: EdgeInsets.all(15.0),
                  color: Colors.blueAccent,
                  child: Container(
                    height: 180,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(10),
                                height: 60,
                            ),
                          ],
                          //color: Colors.black,
                        ),

                        Container(
                          //color: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          // height: 200,
                          child: Center(
                            //padding: EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              //color: Colors.grey,
                              child: Text("Rudy",textAlign: TextAlign.left,style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),
                          ),
                        ),
                        Container(
                          //color: Colors.green,
                          //margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          child: Text(
                          "BRI",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                          fontFamily: "SemiBoldFont",
                          fontSize: 15.0,
                          color: Colors.white),
                          ),
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          child: Text(
                          "736501005821534",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          ),
                        ),

                    ],
                    )
                  ),
                  )
              ),
            ],
          ),
      ),
    );
  }
  @override
  void dispose() {
    saldoCtrl.dispose();
    super.dispose();
  }

//  Widget cardImage() {
//    if (cardtype == CardType.visa) {
//      return Image.asset(
//        "images/visa.png",
//        fit: BoxFit.scaleDown,
//      );
//    } else if (cardtype == CardType.mastercard) {
//      return Image.asset(
//        "images/mastercard.png",
//        fit: BoxFit.scaleDown,
//      );
//    } else if (cardtype == CardType.discover) {
//      return Image.asset(
//        "images/discover.png",
//        fit: BoxFit.scaleDown,
//      );
//    } else if (cardtype == CardType.dinnerClub) {
//      return Image.asset(
//        "images/diners_club.png",
//        fit: BoxFit.scaleDown,
//      );
//    } else if (cardtype == CardType.americanExpress) {
//      return Image.asset(
//        "images/amex.png",
//        fit: BoxFit.scaleDown,
//      );
//    }
//    return null;
//  }


}