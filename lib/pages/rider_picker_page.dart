import 'package:provider/provider.dart';
import 'package:ut_order/data/order_view.dart';
import 'package:ut_order/data/place_bloc.dart';
import 'package:ut_order/models/order.dart';
import 'package:ut_order/models/place_item_res.dart';
import 'package:flutter/material.dart';
import '../utils/constans.dart';

class RidePickerPage extends StatefulWidget {
  final String selectedAddress;
  final Function(PlaceItemRes, bool) onSelected;
  final bool _isFromAddress;
  RidePickerPage(this.selectedAddress, this.onSelected, this._isFromAddress);

  @override
  _RidePickerPageState createState() => _RidePickerPageState();
}

class _RidePickerPageState extends State<RidePickerPage> {
  var _addressController = new TextEditingController();
  var placeBloc = PlaceBloc();
  BuildContext _ctx;

  @override
  void initState() {
    print("data alamat : ${widget.selectedAddress}");
    _addressController = TextEditingController(text: widget.selectedAddress);
    super.initState();
  }

  @override
  void dispose() {
    placeBloc.dispose();
//    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationPicker = Provider.of<OrderViewModel>(context);
    _ctx = context;
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xfff8f8f8),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                        height: 60,
                        child: Center(
                          child: Image.asset("assets/ic_location_black.png"),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        width: 40,
                        height: 60,
                        child: Center(
                          child: FlatButton(
                              onPressed: () {
                                _addressController.text = "";
                              },
                              child: Image.asset("assets/ic_remove_x.png")),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 50),
                        child: TextField(
                          controller: _addressController,
                          textInputAction: TextInputAction.search,
                          onChanged: (value){
                            placeBloc.searchPlace(value);
                          },
                          onSubmitted: (String str) {
                            print("onSubmit: ${str}");
                          },
                          style:TextStyle(fontSize: 16, color: Color(0xff323643)),

                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              height: SizeConfig.blockHeight * 77,
              color: Colors.amber,
              child: StreamBuilder(
                  stream: placeBloc.placeStream,
                  builder: (context, snapshot) {
                    print("data snapshot ${snapshot.data}");

                    if (snapshot.hasData) {
                      print(snapshot.data.toString());
                      if (snapshot.data == "start") {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

//                      print(snapshot.data.toString());
                      List<PlaceItemRes> places = snapshot.data;
                      print("Jumlah Place :${places.length}");
                      return ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(places.elementAt(index).name),
                              subtitle: Text(places.elementAt(index).address),
                              onTap: () {
                                print("on tap");
                                Navigator.of(context).pop();
                                print(places.elementAt(index));
                                if(widget._isFromAddress){
                                  locationPicker.setFrom(places.elementAt(index));
                                }else{
                                  locationPicker.setTo(places.elementAt(index));
                                }

                                widget.onSelected(places.elementAt(index),widget._isFromAddress);

                              },
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Color(0xfff5f5f5),
                          ),
                          itemCount: places.length);
                    } else {
                      return Container();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
