import 'package:ut_order/models/place_item_res.dart';
import 'package:ut_order/pages/rider_picker_page.dart';
import 'package:flutter/material.dart';

class RidePicker extends StatefulWidget{
  final Function(PlaceItemRes, bool) onSelected;
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  RidePicker(this.onSelected,{this.toAddress,this.fromAddress});

  @override
  _RidePickerState createState() => _RidePickerState();
}

class _RidePickerState extends State<RidePicker> {
  Widget build(BuildContext context) {
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
      child:Column(
        children: <Widget>[
          TextPlaceSearch(typeCari: 'origin',addressName: widget.fromAddress == null ? 'Lokasi Jemput':widget.fromAddress.address,placeholder: 'Lokasi Jemput',
            onPress: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RidePickerPage(
                      widget.fromAddress == null ? "" : widget.fromAddress.name,
                          (place, isFrom) {
                        widget.onSelected(place, isFrom);
                        widget.fromAddress = place;
                      }, true)));
            },
          ),
          TextPlaceSearch(typeCari: 'origin',addressName: widget.toAddress == null ? 'Lokasi Tujuan':widget.toAddress.address,placeholder: 'Lokasi Tujuan',
            onPress: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RidePickerPage(
                      widget.fromAddress == null ? "" : widget.fromAddress.name,
                          (place, isFrom) {
                        widget.onSelected(place, isFrom);
                        widget.fromAddress = place;
                      }, false)));
            },
          ),
        ],
      ),
    );
  }
}


class TextPlaceSearch extends StatelessWidget {
  final String typeCari;
  final String addressName;
  final String placeholder;
  final Function onPress;
  TextPlaceSearch({@required this.typeCari,this.addressName,this.placeholder,this.onPress});
  @override
  Widget build(BuildContext context) {
      var icon = typeCari == 'origin' ? 'ic_location_black':'ic_map_nav';
      return Container(
        width: double.infinity,
        height: 50,
        child: FlatButton(
                onPressed: onPress,
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
        
      );
  }
}
