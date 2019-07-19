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
                    rs.postRequestSaldo(saldo,"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImI3MDk1YmM1N2Y3MTA0YjY0NmE3N2FlNjM4NWUwZDk4NGVkZWUwY2QzYWJkZmFkMWQ3ZmQwYWIyZDE2NTBhODc3Yjk1NTQ4YjBkZjYyNjY3In0.eyJhdWQiOiIzIiwianRpIjoiYjcwOTViYzU3ZjcxMDRiNjQ2YTc3YWU2Mzg1ZTBkOTg0ZWRlZTBjZDNhYmRmYWQxZDdmZDBhYjJkMTY1MGE4NzdiOTU1NDhiMGRmNjI2NjciLCJpYXQiOjE1NjM1MTc0MzYsIm5iZiI6MTU2MzUxNzQzNiwiZXhwIjoxNTk1MTM5ODM2LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.gokyIBnG3SwmFPn9NqTiuRwmQ2BkHgvalRFD7ye3BCEqLRcKMlZYltzJMhaFKmmYIRRo8ubw7MynqFjqB3nQihMxDHrwdFDnIfOu-iWp0e0fjUSEAsxpzmWZW10kv5oFHoDK5EdTYZN7d2HsThLAqYoFLN0kIAdAB6-baZZGU5UQG27hJ4iVgaTZTZvgXVz0s_RHH7F99SP__4cRdUpXOvssWTe6FZzp1PUSoh6bvyuugj5j17wO4fqIh3v5JjDdfIyw-A2indUfs34Tyzc-s-UmH0cAL1xg3yP7aIBQVEekoesDTl3ctchGhGszeC08IetSz_54cPlYSwEFZrKMp90rdmAc1biNTYAPBq0C7-eSzdd1et_z55MhGXyiWCr_fVT1pbgH2YbVH528bNmqzHL3pU71OLMSH45TBOsr__WKshMCqP5knUN2k0ITlfq4Bz7oOERQydtmBbypxiWtgEyZEFa89Jt9oioYc0DnNkCoS7ecTvtW6BJ1gy-kq--39QWQg_9e3qY6IjOOVhC3ete-LXuSVQIGmJZ2i0o44gBhqUPiBnFRUrzsAi_KUwReVGKg7Ppn9UHaCpdQ-_OHoHwg-1f67GruCK3BmSx6-vuGUMyByHNC6byByoFvyN3u25c6jeI8mSTw_icx-xiuOp2d-OqmvwXRkoDOh2rdslo").then((v){
                      print(v);
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text(saldo),
                          );
                        },
                      );
                    }).catchError((e){
                      print(e);
                    });

                  },
                )
              )
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
}