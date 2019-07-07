import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ut_order/components/car_pickup.dart';
import 'package:ut_order/components/menu_drawer.dart';
import 'package:ut_order/components/network.dart';
//import 'package:ut_order/components/functionalButton.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:ut_order/components/rider_picker.dart';
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

  // GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor _markerIcon;
  int _polylineIdCounter = 1;
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
  var _tripDistance = 0;

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
    //_mapController.mar();
    super.initState();
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _addHomePoly() {
    _homeCameraPosition();
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.black,
      width: 5,
      points: _createHomePoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _addGymPoly() {
    _gymCameraPosition();
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.black,
      width: 5,
      points: _createGymPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _addWorkPoly() {
    _workCameraPosition();
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.black,
      width: 5,
      points: _createWorkPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
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
        infoWindow: InfoWindow(title: place.name,snippet: place.address));
      print(markers);
  }

  void _moveCamera() {
    print("move camera: ${markers.values}");
    if (markers.values.length > 1) {
      var fromLatLng = markers["from_address"].position;
      var toLatLng = markers["to_address"].position;
      print("dari Halaman ${markers.containsKey("from_address")}");
      var sLat, sLng, nLat, nLng;
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
      print("sLat : ${sLat}");

      LatLngBounds bounds = LatLngBounds(northeast: LatLng(nLat, nLng), southwest: LatLng(sLat, sLng));

      mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } else {
      mapController.animateCamera(CameraUpdate.newLatLng(markers.values.elementAt(0).position));
    }
  }

  void _checkDrawPolyline() {
//  remove old polyline
//    mapController.clearPolylines();

    if (markers.length > 1) {
      var from = markers["from_address"].position;
      var to = markers["to_address"].position;
      PlaceService.getStep(from.latitude, from.longitude, to.latitude, to.longitude).then((vl) {
        TripInfoRes infoRes = vl;
        _tripDistance = infoRes.distance;
        List<StepsRes> rs = infoRes.steps;
        List<LatLng> paths = new List();
        for (var t in rs) {
          paths
              .add(LatLng(t.startLocation.latitude, t.startLocation.longitude));
          paths.add(LatLng(t.endLocation.latitude, t.endLocation.longitude));
        }
//        print(paths);
//        mapController.addPolyline(PolylineOptions(points: paths, color: Color(0xFF3ADF00).value, width: 10));
      });
    }
  }

  Future<void> _homeCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(3.6422756, 98.5294038),
      zoom: 12.10,
    )));
  }

  Future<void> _gymCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(-8.912014, 13.204197),
      zoom: 12.5,
    )));
  }

  Future<void> _workCameraPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(-8.914843, 13.201518),
      zoom: 18.5,
    )));
  }

  void refresh() async {
    final center = await getUserLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    getNearbyPlaces(center);
  }

  void onHandleOrder() async{
    var data = Order(origin: 'Medan',destination: 'Ayam',originLat: 0,originLng: 0,destinationLat: 0,destinationLng: 0,harga: 0,);
    var response = await rs.orderCar(data);
    return response;
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
          _createLatLng(f.geometry.location.lat, f.geometry.location.lng);
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
    final dataProvider = Provider.of<User>(context);
    final dataOrder = Provider.of<Order>(context);
    final drawer = Drawer(
      child: HomeMenu(name: "User")
    );
    final body = Stack(
      children: <Widget>[
        GoogleMap(
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
        Positioned(
          top: 100.0,
          right: 15.0,
          left: 15.0,
          child:Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey,offset: Offset(1.0, 5.0),blurRadius: 15,spreadRadius: 3)
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                icon: Container(margin: EdgeInsets.only(left: 20, top: 18), width: 10, height: 10, decoration: BoxDecoration(color: Colors.black)),
                hintText: "Tujuan ?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),

              ),
              controller: _destinationText,
              onTap: _handlePressButton,

            ),
          ),
        ),
        Positioned(
          top: 160.0,
          right: 15.0,
          left: 15.0,
          child:Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 15,
                    spreadRadius: 3
                )
              ],
            ),
            child: TextField(
              key: Key('jemputTxt'),
              decoration: InputDecoration(
                icon: Container(margin: EdgeInsets.only(left: 20, top: 18), width: 10, height: 10, decoration: BoxDecoration(color: Colors.black)),
                hintText: "Jemput ?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
              controller: _originText,
              onTap: _handlePressButton,

            ),
          ),
        ),
        Positioned(
            top: 30,
            left: 6,
            child: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {
                homeScaffoldKey.currentState.openDrawer();
              },
            )
        ),



      ],
    );
    final column = Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
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
            )

          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: <Widget>[
              cardWidget(
                  context,
                  'assets/logo.png',
                  'KenGen Power',
                  'ID: 123456789',
                  'Auto Pay on 24th May 18',
                  '\$1240.00',
                  '12 Km',
                  Colors.green),

            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: RaisedButton(
            color: Colors.indigo[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 15.0,bottom: 15.0),
              child: Text('Pay all bills', style: TextStyle(color: Colors.white),),
            ),
            onPressed: (){

            },
          ),
        )
      ],
    );
    final mapscreen = new Column(
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

              Positioned(left: 20, right: 20, bottom: 40,height: 248,
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
                          Expanded(flex: 1,child: Container(height:SizeConfig.blockHeight * 15,color: Colors.transparent,child: Center(child: Text("Saldo",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),)),),),
                          Expanded(flex: 1,child: Container(height:SizeConfig.blockHeight * 15,color: Colors.blue,child: Center(child: Text("Promo")),),),
                          Expanded(flex: 1,child: Container(height:SizeConfig.blockHeight * 15,color: Colors.black,child: Center(child: Text("Catatan")),),),
                        ],
                      ),
                      Divider(),
                      Container(
                        height: 50,
                        child: Text("Harga",style: TextStyle(fontFamily: 'Montserrat',fontSize: 30.0,fontWeight: FontWeight.bold),) ,
                      ),
                      Divider(),
                      Padding(
                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                          child: ButtonTheme(
                            height: 50.0,
                            minWidth: SizeConfig.screenWidth,
                            child: RaisedButton(
                              color: Colors.blue[700],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                              child: Text('Pesan', style: TextStyle(color: Colors.white)),
                              onPressed: onHandleOrder,
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ),

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
    final networkwidget = NetworkWidget(
      child: mapscreen,
    );
    print(dataOrder);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: homeScaffoldKey,
//      bottomSheet: Container(
//        height: 100,
//        decoration: BoxDecoration(
//            color: Colors.black
//        ),
//        child: Column(
//        ),
//      ),
      drawer: drawer,
      body: networkwidget,
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

  List<LatLng> _createHomePoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(-8.913012, 13.202450));
    points.add(_createLatLng(-8.913297, 13.202253));
    points.add(_createLatLng(-8.913752, 13.202803));
    points.add(_createLatLng(-8.913455, 13.203063));
    points.add(_createLatLng(-8.913012, 13.202450));
    return points;
  }

  List<LatLng> _createGymPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(-8.911857, 13.203656));
    points.add(_createLatLng(-8.911580, 13.204369));
    points.add(_createLatLng(-8.912060, 13.204649));
    points.add(_createLatLng(-8.912406, 13.204128));
    points.add(_createLatLng(-8.911857, 13.203656));
    return points;
  }

  List<LatLng> _createWorkPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(_createLatLng(-8.914580, 13.202106));
    points.add(_createLatLng(-8.915066, 13.201708));
    points.add(_createLatLng(-8.915269, 13.201441));
    points.add(_createLatLng(-8.915345, 13.201232));
    points.add(_createLatLng(-8.915301, 13.201075));
    points.add(_createLatLng(-8.915058, 13.200855));
    points.add(_createLatLng(-8.914824, 13.201195));
    points.add(_createLatLng(-8.914180, 13.201826));
    points.add(_createLatLng(-8.914580, 13.202106));

    return points;
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

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold()
      : super(
    apiKey: google_web_api,
    sessionToken: Uuid().generateV4(),
    language: "en",
    components: [Component(Component.country, "id")],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}
class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, searchScaffoldKey.currentState);
      },
      logo: Row(
        children: [FlutterLogo()],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
    return Container(
      child: body,
    );
//    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    searchScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      searchScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(response.toString())),
      );
    }
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

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
class OrangeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2 + 85.0, size.height);

    var firstControlPoint = Offset(size.width / 2 + 140.0, size.height - 105.0);
    var firstEndPoint = Offset(size.width - 1.0, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

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
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width / 2 + 75.0, size.height / 2 - 30.0);

    path.lineTo(size.width / 2, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}