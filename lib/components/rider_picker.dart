import 'package:provider/provider.dart';
import 'package:ut_order/models/order.dart';
import 'package:ut_order/models/place_item_res.dart';

import 'package:ut_order/pages/rider_picker_page.dart';
import 'package:flutter/material.dart';

class RidePicker extends StatefulWidget {
  final Function(PlaceItemRes, bool) onSelected;
  RidePicker(this.onSelected);

  @override
  _RidePickerState createState() => _RidePickerState();
}

class _RidePickerState extends State<RidePicker> {
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;

  @override

  Widget build(BuildContext context) {
    final pickerLokasi = Provider.of<OrderPemesanan>(context);
    print("picker lokasi : ${pickerLokasi.toJson()}");

    print("fromAdrress : ${fromAddress}");
    print("toAddress : ${toAddress}");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Color(0x88999999),
              offset: Offset(0, 5),
              blurRadius: 5.0,
            ),
          ]
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RidePickerPage(
                        pickerLokasi.fromAddress == null ? "" : pickerLokasi.fromAddress.name,
                            (place, isFrom) {
                          widget.onSelected(place, isFrom);
//                          fromAddress = place;
                        }, true)));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_location_black.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_remove_x.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        (pickerLokasi.fromAddress == null || pickerLokasi.fromAddress.name == null) ? "Lokasi Penjemputan" : pickerLokasi.fromAddress.name,
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RidePickerPage(pickerLokasi.toAddress == null ? "" : pickerLokasi.toAddress.name,
                                (place, isFrom) {
                              widget.onSelected(place, isFrom);
                              print(place);
                              pickerLokasi.setTo(place);
//                              toAddress = place;
                              setState(() {});
                            }, false)));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_map_nav.png"),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 40,
                      height: 50,
                      child: Center(
                        child: Image.asset("assets/ic_remove_x.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 50),
                      child: Text(
                        (pickerLokasi.toAddress == null || pickerLokasi.toAddress.name == null) ? "Lokasi Tujuan" : pickerLokasi.toAddress.name,
                        overflow: TextOverflow.ellipsis,
                        style:TextStyle(fontSize: 16, color: Color(0xff323643)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
