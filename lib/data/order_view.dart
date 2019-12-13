import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ut_order/models/order.dart';
import 'package:ut_order/models/place_item_res.dart';
import 'package:ut_order/utils/constans.dart';
import 'package:http/http.dart' as http;
import 'package:ut_order/utils/place.dart';
import '../models/base_model.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/subjects.dart';

class OrderViewModel extends BaseModel {
  int distance = 0;
  int time = 0;
  int price = 0;
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  String token;
  List<PlacesSearchResult> places = [];
  Order _order;
  static const kGoogleApiKey = google_web_api;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  PublishSubject placeSubject;
  BehaviorSubject<String> bookingStatus = new BehaviorSubject<String>();

  

  OrderViewModel({
    @required String token
  }) : token = token;


  void dispose() {
    print('disposed app bloc');
    bookingStatus.close();
    super.dispose();
  }
  setFrom(PlaceItemRes res){
    fromAddress = res;
    notifyListeners();
  }

  setTo(PlaceItemRes res){
    toAddress = res;
    notifyListeners();
  }
  setHarga(int storeHarga){
    price = storeHarga;
    notifyListeners();
  }
  setJarak(jarak){
    distance = jarak;
    notifyListeners();
  }

  int getDistanceInKm(){
    return (distance * 0.001).toInt();
  }
  postPesanan() async{
    final url = "${apiURL}/bookings/reguler";
    _order = new Order(origin: '',
      destination: '',originLat: 0,
      originLng: 0,
      destinationLat: 0,
      destinationLng: 0,
      typeOrder: 1,harga: 0,duration: 0,distance: 0);
      final response = await http.post(url,
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
      }
    print(_order);
    
  }

  calculatePrice(base,time,timeRate,distanceRate,distance,surge){
    final double distanceInKm = distance * 0.001;

    final timeInMin = time * 0.0166667;
    final pricePerKm = timeRate * timeInMin;
    final pricePerMinute = distanceRate * distanceInKm;
//    final totalFare = (base + pricePerKm + pricePerMinute) * surge;
    final totalFare = (base * distanceInKm.roundToDouble());
//    var ta = base+(distanceInKm-(distanceInKm*0.01))*pricePerKm;
//    var tm = 0;
//    return ta +tm;
    return totalFare;
  }
  void getNearbyPlaces(LatLng center) async {

    final location = Location(center.latitude, center.longitude);
    final result = await _places.searchNearbyWithRadius(location, 2500);
      setBusy(true);
      if (result.status == "OK") {
        this.places = result.results;
        result.results.forEach((f) {
          var markers = _createLatLng(f.geometry.location.lat, f.geometry.location.lng);
          setBusy(false);
        });
      } else {
        // this.errorMessage = result.errorMessage;
        setBusy(false);
      }
    
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      print(detail);
    }
  }
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void searchPlace(String keyword) {
    print("place bloc search: " + keyword);

    placeSubject.add("start");
    PlaceService.searchPlace(keyword).then((rs) {
      placeSubject.add(rs);
    }).catchError(() {
      placeSubject.add("stop");
    });
  }

  void clearState(){
    price = 0;
    distance = 0;
    fromAddress = new PlaceItemRes('-','-',0,0);
    toAddress = new PlaceItemRes('-','-',0,0);
    setBusy(false);
  }

  Future<Null> getDistanceTime() async{
    var origin = "${fromAddress.lat.toString()},${fromAddress.lng.toString()}";
    var dest = "${toAddress.lat.toString()},${toAddress.lng.toString()}";
    var mode = 'driving';
    var key = google_web_api;
    var url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$dest&mode=$mode&key=$key";
    final response = await http.get(url,headers: {'Content-Type': 'application/json'},);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
    }
  }

  setBookBy(int userId){
    _order.bookBy = userId;
    setBusy(false);
  }

  postBooking(Order order) async{
    final url = "$apiURL/reguler";
    final bodyParams = order.toMapDatabase();
    final response = await http.post(url,
      body: json.encode(bodyParams),
      headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if(responseData['status']){
        bookingStatus.sink.add("pending");
      }
    }else{
      print(response.body);
      print(token);
    }

  }

}


