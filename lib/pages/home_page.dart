import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ut_order/components/base_widget.dart';
import 'package:ut_order/models/auth.dart';
import '../utils/network_util.dart';
import 'package:ut_order/components/network.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:ut_order/components/rider_picker.dart';
import 'package:ut_order/models/step_res.dart';
import 'package:ut_order/models/trip_info_res.dart';
import 'package:ut_order/utils/place.dart';
import '../data/rest_ds.dart';
import '../utils/constans.dart';
import 'place_detail.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:ut_order/models/order.dart';
import 'package:ut_order/models/place_item_res.dart';
import '../data/order_view.dart';


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
  NetworkUtil _networkUtil = new NetworkUtil();


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

  void _checkDrawPolyline() async {
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
      Map resTypecar = await _networkUtil.get("http://utama-trans.com/new/api/type_car");
      var basicCar = resTypecar['data'][0];

      print("checkDrawPolyline from: ${from}");
      PlaceService.getStep(from.latitude, from.longitude, to.latitude, to.longitude).then((vl) {
        TripInfoRes infoRes = vl;
        _tripDistance = infoRes.distance * 0.001;

        // var harga = kalkulasiHarga(int.parse(basicCar['per_miles']), _tripDistance.toInt(), int.parse(basicCar['per_min']));
        var harga = 100;
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

  void refresh(model) async {
    final center = await getUserLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
    model.getNearbyPlaces(center);
  }

  void onHandleOrder(OrderPemesanan data) async{
    final res = data.toJson();
    final order = Order(origin: res['origin'].name,
        destination: res['destination'].name,originLat: res['origin'].lat,originLng: res['origin'].lng,
        destinationLat: res['destination'].lat,destinationLng: res['destination'].lng,
        harga:30,typeOrder: 1,duration: 1,distance: 1);
    final _response = await rs.orderCar(order);
    print(_response);
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
    final state = Provider.of<OrderViewModel>(context);
    var info;
    print(info);
    if (state.fromAddress != null && state.toAddress != null) {
      info =  Positioned(
          left: 20,
          right: 20,
          bottom: 20,
          height: 248,
          child: Container(
            height: (SizeConfig.blockHeight * 50),
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
                    Kotak(name: 'A',),
                    Kotak(name:'B'),
                  ],
                ),
                Divider(),
                Container(
                  height: 50,
                  child: Text(tripTotal.toString(), style: TextStyle(
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
                      onPressed: ()=>print('proses'),
                    ),
                  ),
                ),


              ],
            ),
          )
      );
    }else{
      info = Container();
    }
    final mapScreen = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                  child: BaseWidget(
                    model: OrderViewModel(token: Provider.of<AuthBloc>(context).token),
                    onModelReady: (model){},
                    builder: (context,mOrder,child){
                      return GoogleMap(
                        markers: Set<Marker>.of(markers.values),
                        polylines: Set<Polyline>.of(polylines.values),
                        mapType: MapType.normal,
                        initialCameraPosition: _cameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          refresh(mOrder);
                          //_initCameraPosition();
                        },
                      );  
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
                      child: RidePicker(),
                    ),
                  ],
                ),
              ),
              info,
            ],
          ),
        )
      ],
    );
    final networkWidget = NetworkWidget(
      child: mapScreen,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: homeScaffoldKey,
      body: networkWidget,
    );

  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
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

class Kotak extends StatelessWidget {
  final String name;
  Kotak({this.name});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
            height: SizeConfig.blockHeight * 15,
            child: Center(child: Text(name,
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),)),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 1.0, color: Colors.grey.shade600),
                right: BorderSide(width: 1.0, color: Colors.grey.shade900),
              ),
              color: Colors.white,
            ),
      ),
    );
  }
}