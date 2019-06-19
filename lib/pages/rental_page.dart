import 'package:flutter/material.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:ut_order/data/rest_ds.dart';
import 'package:provider/provider.dart';
import 'package:ut_order/models/package.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:ut_order/models/order.dart';
const kGoogleApiKey = google_web_api;
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class RentalPage extends StatefulWidget {
  static String tag = RoutePaths.Rental;
  @override
  _RentalPageState createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  List litems = [];
  RestDatasource rs = new RestDatasource();
  String selectedHour;
  LocationManager.LocationData  _currentLocation;
  List<PlacesSearchResult> places = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController titikJemputTxt = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    rs = Provider.of<RestDatasource>(context);
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Rental Mobil'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: SizeConfig.blockHeight * 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/rental.png"),
                    fit: BoxFit.contain
                )
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                ],
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Titik Jemput ',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                  controller: titikJemputTxt,
                  onTap: _handlePressButton,
                ),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.only(left: 10,right: 10,top:20),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment(0, 0),
                            color: Colors.cyan, height: 80,child: InkWell(

                            child:Text("Pilih Paket",style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),onTap: _showModalSheet,),),
                          flex: 2,

                        ),
                        FlatButton(
                          color: Colors.lightBlueAccent,
                          onPressed: _showModalSheet,
                          child: Text("Pilih Paket"),
                        ),
                        FlatButton(
                          color: Colors.teal,
                          child: Text("Pesan"),
                          onPressed: (){},
                        )
                      ],
                    ),
                  ),
                ],
              ),


            ],
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    get_package();
  }
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[

                new ListTile(
                    leading: new Icon(Icons.music_note),
                    title: new Text('Music'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        }
    );
  }
  void get_package() async{
    var package = await rs.getPackage(1);

    setState(() {
      litems = package;
    });
  }

  void _showModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
              color: Colors.lightBlueAccent,
              child: new Center(
                child: new ListView.builder(
                    itemCount: litems.length,
                    itemBuilder: (BuildContext ctxt, int idx) {

                      return new ListTile(
                          leading: new Icon(Icons.hourglass_full),
                          title: new Text("${litems[idx]['name']} - ${litems[idx]['harga']}K",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),),
                          onTap: (){
                            selectedHour = (litems[idx]['id']).toString();
                            Navigator.pop(context);
                          }
                      );
                    }
                ),
              )
          );
        }
    );
  }

  void getNearbyPlaces(LatLng center) async {


    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);
    setState(() {

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

      }
    });
  }
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: (PlacesAutocompleteResponse response){
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(response.errorMessage)),
            );
          },
          mode: Mode.fullscreen,
          language: "en",
          location: center == null ? null : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);
          titikJemputTxt.text = p.placeId;


//      showDetailPlace(p.placeId);

    } catch (e) {
      return;
    }
  }
  Future<LatLng> getUserLocation() async {

    final location = new LocationManager.Location();
    try {
      _currentLocation = await location.getLocation();
      print(_currentLocation);
      final lat = _currentLocation.latitude;
      final lng = _currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      _currentLocation = null;
      return null;
    }
  }
}