import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ut_order/components/car_pickup.dart';
import 'package:ut_order/components/menu_drawer.dart';
import 'package:ut_order/components/network.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:ut_order/components/rider_picker.dart';
import 'package:ut_order/data/app_bloc.dart';
import 'package:ut_order/models/step_res.dart';
import 'package:ut_order/models/trip_info_res.dart';
import 'package:ut_order/utils/place.dart';
import '../data/rest_ds.dart';
import '../utils/constans.dart';
import 'place_detail.dart';
import '../models/user.dart';
import '../models/place_item_res.dart';
import 'dart:math';
import 'package:ut_order/models/order.dart';
import 'package:provider/provider.dart';
const kGoogleApiKey = google_web_api;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();
TextEditingController _destinationText = new TextEditingController();
TextEditingController _originText = new TextEditingController();


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  static String tag = 'home-page';
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  _HomePageState();


  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor _markerIcon;
  PolylineId selectedPolyline;
  bool isLoading = false;
  String errorMessage;
  GoogleMapController mapController;
  LocationManager.LocationData  _currentLocation;
  List<PlacesSearchResult> places = [];
  RestDatasource rs = new RestDatasource();
  String tripAddressOrigin,tripAddressDestination;
  String tripOrLatitude,tripOrLongitude,tripDesLatitude,tripDesLongitude;
  int tripTotal,tripDuration,tripDistance;
  Order order;
  double _tripDistance = 0;

  Mode _mode = Mode.fullscreen;

  // Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  int jointTypesIndex = 0;
  List<JointType> jointTypes = <JointType>[
    JointType.mitered,
    JointType.bevel,
    JointType.round
  ];

  // Values when toggling polyline end cap type
  int endCapsIndex = 0;
  List<Cap> endCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline start cap type
  int startCapsIndex = 0;
  List<Cap> startCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline pattern
  int patternsIndex = 0;
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[],
    <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)],
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)],
  ];


  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(3.6422756, 98.5294038),
    zoom: 11.0,
  );

  @override
  void initState() {
    super.initState();
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void onPlaceSelected(PlaceItemRes place, bool fromAddress) {
    var mkId = fromAddress ? "from_address" : "to_address";
    print("place selected : ${mkId}");
    _addMarker(mkId, place);
    _moveCamera();
    _checkDrawPolyline();
  }

  void _addMarker(String mkId, PlaceItemRes place) async {
    // remove old
    markers.remove(mkId);
    markers[MarkerId(mkId)] = Marker(
//        icon: _markerIcon,
        markerId:MarkerId(mkId),
        position: LatLng(place.lat, place.lng),
//        infoWindow: InfoWindow(title: place.name,snippet: place.address)
        );
      print(markers);
  }

  void _moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    print("move camera: ${markers.values.elementAt(0).position}");
    var fromLatLng,toLatLng;
    markers.forEach((mkid,v){
      print(mkid.value);
      if(mkid.value == "from_address"){
        fromLatLng = v.position;
      }else{
        toLatLng = v.position;
      }
      var sLat, sLng, nLat, nLng;
      print("fromLatLng:${fromLatLng}");
      print("toLatLng:${toLatLng}");
      if(fromLatLng != null && toLatLng != null){
        if(fromLatLng.latitude <= toLatLng.latitude) {
          sLat = fromLatLng.latitude;
          nLat = toLatLng.latitude;
        } else {
          sLat = toLatLng.latitude;
          nLat = fromLatLng.latitude;
        }

        if(fromLatLng.longitude <= toLatLng.longitude) {
          sLng = fromLatLng.longitude;
          nLng = toLatLng.longitude;
        } else {
          sLng = toLatLng.longitude;
          nLng = fromLatLng.longitude;
        }
        LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }else{
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: markers.values.elementAt(0).position,
          zoom: 12.10,
        )));
      }

    });

  }

  void _checkDrawPolyline() {
    final String polylineIdVal = 'polyline_id_distance';
    print("Draw Polyline");
    polylines.remove(polylineIdVal);
    if (markers.length > 1) {
      var from;
      var to;
      markers.forEach((mkid,v){
        print(mkid.value);
        if(mkid.value == "from_address"){
          from = v.position;
        }else{
          to = v.position;
        }
      });

      print("checkDrawPolyline from: ${from}");
      PlaceService.getStep(from.latitude, from.longitude, to.latitude, to.longitude).then((vl) {
        TripInfoRes infoRes = vl;
        _tripDistance = infoRes.distance * 0.001;
        var harga = kalkulasiHarga(3700, 0, 6);
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = new List();
        for (var t in rs) {
          paths.add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }
        final PolylineId polylineId = PolylineId(polylineIdVal);
        final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.black,
          width: 5,
          points: paths,
          onTap: () {
            _onPolylineTapped(polylineId);
          },
        );


        setState(() {
          tripTotal = harga;
          polylines[polylineId] = polyline;
        });
      });
    }
  }

  void refresh() async {
    final center = await getUserLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    getNearbyPlaces(center);
  }

  void onHandleOrder(OrderPemesanan data) async{
    final res = data.toJson();
    final order = Order(origin: res['origin'].name,destination: res['destination'].name,originLat: res['origin'].lat,originLng: res['origin'].lng,destinationLat: res['destination'].lat,destinationLng: res['destination'].lng,harga:30,typeOrder: 1,duration: 1,distance: 1);
    print(order.toString());
  }

  Future<LatLng> getUserLocation() async {

    final location = new LocationManager.Location();
    try {
      _currentLocation = await location.getLocation();
      final lat = _currentLocation.latitude;
      final lng = _currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      _currentLocation = null;
      return null;
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  void getNearbyPlaces(LatLng center) async {
    setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((f) {
          var markers = _createLatLng(f.geometry.location.lat, f.geometry.location.lng);


//          final markerOptions = MarkerOptions(
//              position:
//              LatLng(f.geometry.location.lat, f.geometry.location.lng),
//              infoWindowText: InfoWindowText("${f.name}", "${f.types?.first}"));
//          mapController.addMarker(markerOptions);
        });
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }

  int kalkulasiHarga(base,tempuh_km,tarif_km){
    var ta = base+(tempuh_km-1)*tarif_km;
    var tm = 0;
    return ta +tm;
  }

  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: _mode,
          language: "en",
          location: center == null ? null : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);
      displayPrediction(p, homeScaffoldKey.currentState);

    } catch (e) {
      return;
    }
  }


  Future<Null> showDetailPlace(String placeId) async {
    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }
  }

  ListView buildPlacesList() {
    final placesWidget = places.map((f) {
      List<Widget> list = [
        Padding(
          padding: EdgeInsets.only(bottom: 4.0),
          child: Text(
            f.name,
            style: Theme.of(context).textTheme.subtitle,
          ),
        )
      ];
      if (f.formattedAddress != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.formattedAddress,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ));
      }

      if (f.vicinity != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.vicinity,
            style: Theme.of(context).textTheme.body1,
          ),
        ));
      }

      if (f.types?.first != null) {
        list.add(Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Text(
            f.types.first,
            style: Theme.of(context).textTheme.caption,
          ),
        ));
      }

      return Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
        child: Card(
          child: InkWell(
            onTap: () {
              showDetailPlace(f.placeId);
            },
            highlightColor: Colors.lightBlueAccent,
            splashColor: Colors.red,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return ListView(shrinkWrap: true, children: placesWidget);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<User>(context);
    final dataOrder = Provider.of<OrderPemesanan>(context);
    final dataType = Provider.of<AppBloc>(context);
    print(dataOrder);
    final mapScreen = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                  child: GoogleMap(
                    markers: Set<Marker>.of(markers.values),
                    polylines: Set<Polyline>.of(polylines.values),
                    mapType: MapType.normal,
                    initialCameraPosition: _cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      refresh();
                      //_initCameraPosition();
                    },
                  ),
                  padding: EdgeInsets.all(1.0),
               ),



              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Column(
                  children: <Widget>[
                    AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                      title: Text(
                        "Utama Trans Reguler",
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: FlatButton(
                          onPressed: () {
                            print("click menu");
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.navigate_before)
                      ),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: (){
                              print("ini notif");
                            },
                            child: Image.asset("assets/ic_notify.png")
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: RidePicker(onPlaceSelected),
                    ),
                  ],
                ),
              ),
              (dataOrder.fromAddress != null && dataOrder.toAddress != null) ?
                Positioned(left: 20,
                  right: 20,
                  bottom: 20,
                  height: 248,
                  child: Container(
                    height: SizeConfig.blockHeight * 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1,
                              child: Container(
                                height: SizeConfig.blockHeight * 15,

                                child: Center(child: Text(userProvider.saldo == null ? '0':userProvider.saldo,
                                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),)),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(width: 1.0, color: Colors.grey.shade600),
                                    right: BorderSide(width: 1.0, color: Colors.grey.shade900),
                                  ),
                                  color: Colors.white,
                                ),
                              ),),
                            Expanded(flex: 1,
                              child: Container(
                                height: SizeConfig.blockHeight * 15,
                                child: Center(child: Text("${_tripDistance.toStringAsFixed(2)} Km",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600))),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(width: 1.0, color: Colors.grey.shade600),
                                    right: BorderSide(width: 1.0, color: Colors.grey.shade900),
                                  ),
                                  color: Colors.white,
                                )
                              ),),
                            Expanded(flex: 1,
                              child: Container(
                                height: SizeConfig.blockHeight * 15,
                                child: Center(child: Text("Catatan")),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(width: 1.0, color: Colors.grey.shade600),
                                    right: BorderSide(width: 1.0, color: Colors.grey.shade900),
                                  ),
                                  color: Colors.white,
                                )
                              ),),
                          ],
                        ),
                        Divider(),
                        Container(
                          height: 50,
                          child: Text(tripTotal.toString(), style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: ButtonTheme(
                            height: 50.0,
                            minWidth: SizeConfig.screenWidth,
                            child: RaisedButton(
                              color: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Text('Pesan',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: ()=>onHandleOrder(dataOrder),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ):
                Container(),

//              Positioned(
//                bottom: 20,
//                left: 20,
//                right: 20,
//                child: Column(
//                  children: <Widget>[
//                    cardWidget(
//                        context,
//                        'assets/taxi.png',
//                        'Medan',
//                        'ID: 123456789',
//                        'Medan To Binjai',
//                        '\Rp. 200 K',
//                        '',
//                        Colors.blue[900]),
//                        Padding(
//                          padding: const EdgeInsets.only(top:8.0),
//                          child: ButtonTheme(
//                            height: 50.0,
//                            minWidth: SizeConfig.screenWidth,
//                            child: RaisedButton(
//                              color: Colors.blue[700],
//                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//                              child: Text('Pesan', style: TextStyle(color: Colors.white)),
//                              onPressed: onHandleOrder,
//                            ),
//                          ),
//                        ),
//
//                      ],
//                ),
//              ),


            ],
          ),
        )
      ],
    );
    final networkWidget = NetworkWidget(
      child: mapScreen,
    );
    print(dataOrder);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: homeScaffoldKey,
      body: networkWidget,
    );

  }

  Widget _buildDropdownMenu() => DropdownButton(
    value: _mode,
    items: <DropdownMenuItem<Mode>>[
      DropdownMenuItem<Mode>(
        child: Text("Overlay"),
        value: Mode.overlay,
      ),
      DropdownMenuItem<Mode>(
        child: Text("Fullscreen"),
        value: Mode.fullscreen,
      ),
    ],
    onChanged: (m) {
      setState(() {
        _mode = m;
      });
    },
  );
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
  Widget cardWidget(BuildContext context, String image, String title,String subtitle, String desc, String amount, String days, Color color) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 30.0,
        height: 130.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0),
                      ),
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black, width: 1),
                            image: DecorationImage(image: AssetImage(image))),
                      ),
                      subtitle: Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                      trailing: Container(
                        width: 80.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[300]),
                        child: Center(
                          child: Text(
                            'Cek Driver',
                            style: TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            desc, style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: color,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                amount, style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                days, style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 5.0,
                height: 45.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}

Widget linkMenuDrawer(String title, Function onPressed) {
  return InkWell(
    onTap: onPressed,
    splashColor: Colors.black,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      width: double.infinity,
      child: Text(title,style: TextStyle(fontSize: 15.0),),
    ),
  );
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    _destinationText.text = p.description;
    _originText.text = p.description;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    final int special = 8 + _random.nextInt(4);
    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) => _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) => value.toRadixString(16).padLeft(count, '0');
}
class OrangeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2 + 85.0, size.height);

    var firstControlPoint = Offset(size.width / 2 + 140.0, size.height - 105.0);
    var firstEndPoint = Offset(size.width - 1.0, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class BlackClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2 - 30.0, size.height);

    var firstControlPoint =
    Offset(size.width / 2 + 175.0, size.height / 2 - 30.0);
    var firstEndPoint = Offset(size.width / 2, 0.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width / 2 + 75.0, size.height / 2 - 30.0);
    path.lineTo(size.width / 2, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}