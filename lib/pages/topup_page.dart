import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
class TopupPage extends StatefulWidget {
  static String Tag = RoutePaths.TopUp;
  @override
  _TopupPageState createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  @override
  Widget build(BuildContext context) {
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
                  "Top up",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Wrap(
                children: <Widget>[
                  TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Total ',
                      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    onTap: (){},
                    child: Container(
                      child: Text("10",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black
                      ),
                      width: SizeConfig.blockWidth * 20,
                      height: 50,
                    ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      child: Text("10",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue
                      ),
                      height: 50,
                      width: SizeConfig.blockWidth * 20,
                    ),
                  ),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      child: Text("10",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green
                      ),
                      height: 50,
                      width: SizeConfig.blockWidth * 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.only(left: 10,right: 10),
                child:RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text("Tambah"),
                  onPressed: (){},
                )
              )
            ],
          ),
      ),
    );
  }
}