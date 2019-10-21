import 'package:provider/provider.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/data/order_view.dart';
import 'package:ut_order/models/auth.dart';
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

    print("fromAdrress : $fromAddress");
    print("toAddress : $toAddress");
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
          TextPlaceSearch(typeCari:'origin',placeholder: "Lokasi Penjemputan",),
          TextPlaceSearch(typeCari:'destination',placeholder: "Lokasi Tujuan",),
        ],
      ),
    );
  }
}


class TextPlaceSearch extends StatelessWidget {
  final String typeCari;
  final String addressName;
  final String placeholder;
  TextPlaceSearch({@required this.typeCari,this.addressName,this.placeholder});
  @override
  Widget build(BuildContext context) {
      var icon = typeCari == 'origin' ? 'ic_location_black':'ic_map_nav';
      return Container(
        width: double.infinity,
        height: 50,
        child: BaseWidget(
            model:OrderViewModel(token: Provider.of<AuthBloc>(context).token),
            onModelReady: (model){},
            builder:(context,OrderViewModel pickerLokasi,_)=> FlatButton(
                onPressed: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => RidePickerPage(
//                         pickerLokasi.fromAddress == null ? "" : pickerLokasi.fromAddress.name,
//                             (place, isFrom) {
//                           widget.onSelected(place, isFrom);
// //                          fromAddress = place;
//                         }, true)));
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
                          child: Image.asset("assets/$icon.png"),
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
                          (addressName == null ) ? placeholder : addressName,
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
      );
  }
}


class PlacePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}